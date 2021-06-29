//
//  RunLoopPermenantThread.m
//  test
//
//  Created by 张森 on 2021/3/29.
//

#import "RunLoopPermenantThread.h"
#import "RunLoopThread.h"

@interface RunLoopPermenantThread ()

@property (strong, nonatomic) RunLoopThread *thread;
@property (assign, nonatomic) bool isStop;

@end

@implementation RunLoopPermenantThread

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isStop = NO;
        __weak typeof(self) weakSelf = self;
        self.thread = [[RunLoopThread alloc] initWithBlock:^{
            /**
            // NSRunLoop实现
             [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
             
             while (weakSelf && !weakSelf.isStop) {
                [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];
             }
            */
            
            // C语言实现
            // 创建context,结构体先把数据清空,否则可能会有垃圾数据
            CFRunLoopSourceContext context = {0};
            // 创建source
            CFRunLoopSourceRef ref = CFRunLoopSourceCreate(kCFAllocatorDefault, 0, &context);
            // 往runloop中添加source
            CFRunLoopAddSource(CFRunLoopGetCurrent(), ref, kCFRunLoopDefaultMode);
            CFRelease(ref);
            // 运行runloop
                // 第三个参数,如果传ture,则执行一次后就会退出
                // 传false,则runloop执行完后不会退出
            CFRunLoopRunInMode(kCFRunLoopDefaultMode, 1.0e10, false);
            
        }];
        [self run];
    }
    return self;
}

- (void)run {
    
    if (!self.thread) {
        
        return;
    }
    [self.thread start];
}

- (void)excuteTask:(void (^)(void))task {
    
    if (!self.thread || !task) {
        
        return;
    }
    [self performSelector:@selector(__excuteTask:) onThread:self.thread withObject:task waitUntilDone:NO];
}

- (void)stop {
    
    if (!self.thread) {
        return;
    }
    [self performSelector:@selector(__stop) onThread:self.thread withObject:nil waitUntilDone:YES];
}

- (void)dealloc {
    
    [self stop];
    NSLog(@"%@, %s", self, _cmd);
}

#pragma mark - private
- (void)__excuteTask:(void (^)(void))task {
    
    task();
}

- (void)__stop {
    
    self.isStop = YES;
    CFRunLoopStop(CFRunLoopGetCurrent());
    self.thread = nil;
}
@end
