//
//  Thread.h
//  test
//
//  Created by 张森 on 2021/3/29.
//

#ifndef Thread_h
#define Thread_h

#pragma mark - GCD基础
/**
 1. dispatch_sync和dispatch_async用来控制是否要开启新的线程
 2. 队列的类型,决定了任务的执行方式
    - 并发队列
    - 串行队列
    - 主队列(特殊的串行队列)
 
 3. 线程总结
 
                并发队列        手动创建的串行队列       主队列
            
 同步(sync)      不开新线程      不开新线程             不开新线程
                串行执行任务    串行执行任务            串行执行任务
 
 
 异步(async)     开新线程         开新线程             不开新线程
                并发执行任务      串行执行任务          串行执行任务
 
 4. 产生死锁的关键:
    - 使用sync函数,往当前串行队列中添加任务时,就会卡住当前线程,产生死锁
 
 5. 队列的地址:
 dispatch_queue_t queue1 = dispatch_get_global_queue(0, 0);
 dispatch_queue_t queue2 = dispatch_get_global_queue(0, 0);
 
 dispatch_queue_t queue3 = dispatch_queue_create("111", DISPATCH_QUEUE_SERIAL);
 dispatch_queue_t queue4 = dispatch_queue_create("111", DISPATCH_QUEUE_SERIAL);
 dispatch_queue_t queue5 = dispatch_queue_create("111", DISPATCH_QUEUE_CONCURRENT);
 dispatch_queue_t queue6 = dispatch_queue_create("111", DISPATCH_QUEUE_CONCURRENT);
 
 NSLog(@"%p - %p - %p - %p - %p - %p", queue1, queue2, queue3, queue4, queue5, queue6);
 0x109917080 - 0x109917080 - 0x60000168e600 - 0x60000168ca80 - 0x60000168e180 - 0x60000168e780
 
    - global_queue取出的地址都是相同的
    - create出来的queue地址都是不相同的,不管传的identity是否相同
    - 强烈建议identity传不同的,后面可能会有操作能用到这个identity
*/

#pragma mark - 锁
/**
 0. 自旋锁等待流程     OSSpinLock
    - 0x10a0c52ea <+27>   : callq  0x10a0c7b52     ; symbol stub for: OSSpinLockLock
    - 0x7fff6115cd46 <+11>: jne    0x7fff6115d261  ; _OSSpinLockLockSlow
    - 0x7fff6115d26f <+14>: movl   (%rdi), %eax
      0x7fff6115d28a <+41>: jmp    0x7fff6115d26f  ; <+14>
      在等待过程中会一直在这段代码之间循环
 0.1 互斥锁等待流程    os_unfair_lock, pthread_mutex_t
    - 0x10eda6be6 <+27>     : callq  0x10eda7c90    ; symbol stub for: os_unfair_lock_lock
    - 0x7fff6115a67c <+19>  : jmp    0x7fff6115b0a3 ; _os_unfair_lock_lock_slow
    - 0x7fff6115b140 <+157> : callq  0x7fff611606d4 ; symbol stub for: __ulock_wait
    - 0x7fff6112c5cc <+8>   : syscall
      调用syscall后断点消失,线程进入休眠状态
 
 1. OSSpinLock
    - 自旋锁, 等待锁的线程会处于忙等的情况, 会一直占用CPU资源, 相当于while循环
    - iOS10之后已过期
    - 目前已经不再安全,可能会出现优先级反转的问题
        - 优先级低的线程先加了锁
        - 优先级高的线程到来时发现有锁, 就会一直忙等
        - 此时CPU会一直分配资源给优先级高的线程
        - 导致低优先级的线程无法完成任务,无法解锁
 
 2. os_unfair_lock
    - 互斥锁
    - Low-Level Lock -> ll Lock -> lll
    - 低级锁,等不到锁就会去休眠
    - os_unfair_lock用于代替不安全的OSSpinLock,从iOS10开始支持
    - 从底层看,等待os_unfair_lock锁的线程会处于休眠状态,并非忙等
 
 3. pthread_mutex_t
    - pthread_mutex_t 本质是互斥锁
    - pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_NORMAL);
        - 设置属性type为Normal时,是普通锁
        - pthread_mutex_init(t, NULL); init时直接属性传NULL也是普通锁
    - pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
        - 设置属性type为Recursive时, 是递归锁
        - 递归锁允许同一线程对一把锁进行重复加锁
    - pthread_cond_t 条件锁
        - pthread_cond_init(&_condition1, NULL);        初始化条件
        - pthread_cond_wait(&_condition1, &_mutex);
            - 等待condition1条件,同时会释放_mutex锁
        - pthread_cond_signal(&_condition1);
            - 通知condition1条件开始执行
            - 会回到wait的地方开始执行
            - 同时wait会对_mutex进行加锁
        - pthread_cond_broadcast(&_condition1);         通知所有condition1的条件进行执行
 4. NSLock, NSCondition, NSConditionLock
    - 底层是对mutex的封装
    - NSLock -> pthread_mutex_t
    - NSCondition -> pthread_mutex_t & pthread_cond_t
        - 底层包含条件和锁两部分
    - NSConditionLock -> NSConditon
        - 可以对条件设置具体的值
        - 即使用同一个ConditionLock可以区分对多个条件进行加锁
    - NSCondition与NSConditionLock的区别
        - NSCondition在等待时,被别的锁唤醒后,是会回到当前线程,继续执行下面的动作
        - NSConditionLock是在当前线程动作完成后,唤醒其他线程,且不会再回来
 
 5. dispatch_semaphore_t
    - 信号量
    - 可以用来控制线程最大并发数
    - 当信号量为1时,可以用来做线程同步
    - 当信号量要释放时,如果信号量的值比初始值小,则会引发崩溃
        - 即,wait和signal要配对使用
    - 调用流程
        - dispatch_semaphore_wait ->
            _dispatch_semaphore_wait_slow ->
            _dispatch_sema4_wait ->
            semaphore_wait ->
            semaphore_wait_trap -> syscall
 
 6. @synchronized
    - 底层封装了pthread_mutex_t
    - 是递归锁
    - 传的对象就是锁,内部会根据hash算法,为对象创建锁
        - 因此,传的对象相同,生成的锁就是相同的
 */

#pragma mark - 线程同步方案性能比较
/**
 1. 性能从高到低排序
    - os_unfair_lock
        - 互斥锁
    - OSSpinLock
        - 自旋锁,iOS10之后无法再使用
    - dispatch_semaphore    * 推荐使用
    - pthread_mutex_t       * 推荐使用
    - dispatch_queue(DISPATCH_QUEUE_SERIAL)
    - NSLock
        - 对pthread_mutex_t的封装,性能稍差
    - NSCondition
        - 对pthread_mutex_t和pthread_cond_t的封装,性能稍差
    - pthread_mutex_t(recursive)
        - 递归锁,比普通的互斥锁性能稍差
    - NSRecursiveLock
        - 对pthread_mutex_t(recursive)的封装,性能稍差
    - NSConditionLock
        - 对NSCondition的封装,性能稍差
    - @synchronized
        - 对pthread_mutex_t(recursive)的封装
        - 其中包含hashmap的操作,性能最差
 
 */

#pragma mark - 自旋锁&互斥锁对比
/**
 1. 自旋锁
    - 预计线程等锁的时间比较短
    - 加锁的代码经常被调用,但竞争情况很少发生
    - CPU资源不紧张
    - 多核处理器
 2. 互斥锁
    - 预计线程等待锁的时间较长
    - 单核处理器
    - 临界区有IO操作
    - 临界区代码复杂或者循环量大
    - 临界区竞争非常激烈
 */

#pragma mark - 读写安全
/**
 0. 保证资源能够多读单写,提高效率
 1. atomic
    - atomic是对属性的setter和getter进行加锁
    - iOS中一般不用这个操作
    - setter和getter调用很频繁,加锁会非常消耗性能
    - 如果真的需要加锁,可以在外部使用setter和getter的时候进行加锁
    - 内部使用的是os_unfair_lock,互斥锁
 
 2. pthread_rwlock
    - 在读的操作时,添加pthread_rwlock_rdlock()
    - 在写的操作时,添加pthread_rwlock_wrlock()
    - 读写操作后,统一解锁pthread_rwlock_unlock()
    - 可以做到多读单写
    - _pthread_rwlock_lock_wait -> __psynch_rw_wrlock -> syscall
    - 互斥锁
 
 3. dispatch_barrier_async
    - 会对同一队列的操作进行栅栏分隔
    - 使用注意点:
        - 传入的queue必须为自定义创建的异步队列
        - 如果传入的是global_queue或者同步队列,则效果跟dispatch_async相同
 */

#endif /* Thread_h */
