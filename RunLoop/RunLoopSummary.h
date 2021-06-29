//
//  RunLoopSummary.h
//  test
//
//  Created by 张森 on 2021/3/26.
//

#ifndef RunLoopSummary_h
#define RunLoopSummary_h

#pragma mark - RunLoop线程保活


#pragma mark - RunLoop运行流程
/**
    1. __CFRunLoopDoObservers核心方法
        - __CFRUNLOOP_IS_CALLING_OUT_TO_AN_OBSERVER_CALLBACK_FUNCTION__
    2. __CFRunLoopDoBlocks
        - __CFRUNLOOP_IS_CALLING_OUT_TO_A_BLOCK__
    3. __CFRunLoopDoSources0
        - __CFRUNLOOP_IS_CALLING_OUT_TO_A_SOURCE0_PERFORM_FUNCTION__
    4. __CFRunLoopDoTimers
        - __CFRUNLOOP_IS_CALLING_OUT_TO_A_TIMER_CALLBACK_FUNCTION__
    5. __CFRUNLOOP_IS_SERVICING_THE_MAIN_DISPATCH_QUEUE__
    6. __CFRunLoopDoSource1
        - __CFRUNLOOP_IS_CALLING_OUT_TO_A_SOURCE1_PERFORM_FUNCTION__
 
    7. __CFRunLoopServiceMachPort线程睡觉
        - 底层调用这个方法:mach_msg()
        - 会从用户态切换到内核态
        - 等待消息,没有消息就让线程休眠
        - 有消息就唤醒线程
 */

/* rl, rlm are locked on entrance and exit */
static int32_t __CFRunLoopRun(CFRunLoopRef rl, CFRunLoopModeRef rlm, CFTimeInterval seconds, Boolean stopAfterHandle, CFRunLoopModeRef previousMode) {
    int32_t retVal = 0;
    do {
        // 通知Observer,即将处理Timers
        __CFRunLoopDoObservers(rl, rlm, kCFRunLoopBeforeTimers);
        // 通知Observer,即将处理Sources
        __CFRunLoopDoObservers(rl, rlm, kCFRunLoopBeforeSources);
        // 处理Blocks
        __CFRunLoopDoBlocks(rl, rlm);
        // 处理Sources0
        Boolean sourceHandledThisLoop = __CFRunLoopDoSources0(rl, rlm, stopAfterHandle);
        if (sourceHandledThisLoop) {
            // 再处理一遍Blocks
            __CFRunLoopDoBlocks(rl, rlm);
        }

        // 如果有source1,即基于Port的事件,则跳转到handle_msg标记处
        if (__CFRunLoopServiceMachPort(dispatchPort, &msg, sizeof(msg_buffer), &livePort, 0, &voucherState, NULL)) {
            goto handle_msg;
        }
        
        // 通知Observer,即将休眠
        __CFRunLoopDoObservers(rl, rlm, kCFRunLoopBeforeWaiting);
        // 进入休眠状态,等待其他事件唤醒
        __CFRunLoopSetSleeping(rl);
        __CFPortSetInsert(dispatchPort, waitSet);
        // 休眠期间等待其他人发消息, 有人发消息,则break
        do {
            __CFRunLoopServiceMachPort(waitSet, &msg, sizeof(msg_buffer), &livePort, poll ? 0 : TIMEOUT_INFINITY, &voucherState, &voucherCopy);
        } while (1);

        // RunLoop醒来
        __CFPortSetRemove(dispatchPort, waitSet);
        __CFRunLoopUnsetSleeping(rl);
    
        // 通知Observer,已经醒来
        __CFRunLoopDoObservers(rl, rlm, kCFRunLoopAfterWaiting);

        // handle_message标签
    handle_msg:
        if (/*被Timer唤醒的*/) {
            // 处理Timer的事情
            __CFRunLoopDoTimers(rl, rlm, mach_absolute_time())
        }
        else if (/*被GCD唤醒的*/) {
            // 处理GCD的事件
            __CFRUNLOOP_IS_SERVICING_THE_MAIN_DISPATCH_QUEUE__(msg);
        } else { // 其他情况,被source1唤醒的
            __CFRunLoopDoSource1(rl, rlm, rls, msg, msg->msgh_size, &reply) || sourceHandledThisLoop;
        }
        
        // 再执行一遍Block
        __CFRunLoopDoBlocks(rl, rlm);
        
        // 处理返回值
        if (sourceHandledThisLoop && stopAfterHandle) {
            retVal = kCFRunLoopRunHandledSource;
        } else if (timeout_context->termTSR < mach_absolute_time()) {
            retVal = kCFRunLoopRunTimedOut;
        } else if (__CFRunLoopIsStopped(rl)) {
            __CFRunLoopUnsetStopped(rl);
            retVal = kCFRunLoopRunStopped;
        } else if (rlm->_stopped) {
            rlm->_stopped = false;
            retVal = kCFRunLoopRunStopped;
        } else if (__CFRunLoopModeIsEmpty(rl, rlm, previousMode)) {
            retVal = kCFRunLoopRunFinished;
        }

    } while (0 == retVal);
    return retVal;
}


SInt32 CFRunLoopRunSpecific(CFRunLoopRef rl, CFStringRef modeName, CFTimeInterval seconds, Boolean returnAfterSourceHandled) {
     
    // 通知Observer,进入RunLoop
    __CFRunLoopDoObservers(rl, currentMode, kCFRunLoopEntry);
    // 核心RunLoop逻辑
    result = __CFRunLoopRun(rl, currentMode, seconds, returnAfterSourceHandled, previousMode);
    // 通知Observer,退出RunLoop
    __CFRunLoopDoObservers(rl, currentMode, kCFRunLoopExit);
    return result;
}

// 入口函数
void CFRunLoopRun(void) {
    int32_t result;
    do {
        result = CFRunLoopRunSpecific(CFRunLoopGetCurrent(), kCFRunLoopDefaultMode, 1.0e10, false);
        CHECK_FOR_FORK();
    } while (kCFRunLoopRunStopped != result && kCFRunLoopRunFinished != result);
}



#pragma mark - RunLoop结构
/**
 struct __CFRunLoop {
     pthread_t _pthread;
     CFMutableSetRef _commonModes;      // 存放着标记为commonMode的那些mode
     CFMutableSetRef _commonModeItems;  // 当某个mode被标记为commonMode后,其中的item就会被copy到这里面来
     CFRunLoopModeRef _currentMode;
     CFMutableSetRef _modes;
 };
 
 // 存放着当前mode下可以执行的sources0,sources1,observer,timers
 typedef struct __CFRunLoopMode *CFRunLoopModeRef;
 struct __CFRunLoopMode {
     CFStringRef _name;
     CFMutableSetRef _sources0;         // 处理触摸事件/performSelector:onThread:
     CFMutableSetRef _sources1;         // 基于Port的线程间通信/系统事件捕捉
     CFMutableArrayRef _observers;      // 用于监听RunLoop状态/UI刷新(BeforeWaiting)/AutoreleasePool(BeforeWaiting)
     CFMutableArrayRef _timers;         // NSTimer/performSelector:withObject:afterDelay:
 };
 */

#pragma mark - RunLoop介绍
/**
 0. 参考:
    - CFRunLoopRef.c
    - CF_EXPORT CFRunLoopRef _CFRunLoopGet0(pthread_t t)
 1. 每条线程都有唯一一个与之对应的RunLoop对象
 2. RunLoop保存在一个全局的Dictionary中,线程作为key,Runloop作为value
    - CFDictionarySetValue(dict, pthreadPointer(pthread_main_thread_np()), mainLoop);
 3. 线程刚创建时没有RunLoop对象,RunLoop会在第一次获取它时创建
    if (!loop) {
    CFRunLoopRef newLoop = __CFRunLoopCreate(t);
        __CFLock(&loopsLock);
    loop = (CFRunLoopRef)CFDictionaryGetValue(__CFRunLoops, pthreadPointer(t));
    if (!loop) {
        CFDictionarySetValue(__CFRunLoops, pthreadPointer(t), newLoop);
        loop = newLoop;
    }
 4. RunLoop会在线程结束时销毁
 5. 主线程的RunLoop在创建时会自动获取,子线程默认没有RunLoop
 
 */

#endif /* RunLoopSummary_h */
