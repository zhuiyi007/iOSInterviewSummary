//
//  MemoryTimerGCDTimer.m
//  test
//
//  Created by 张森 on 2021/4/1.
//

#import "MemoryTimerGCDTimer.h"

@implementation MemoryTimerGCDTimer

static NSMutableDictionary *GCDTimerDict_;

+ (void)initialize
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        GCDTimerDict_ = [NSMutableDictionary dictionary];
    });
}

+ (NSString *)excuTask:(void(^)(void))task
                 begin:(NSTimeInterval)begin
              interval:(NSTimeInterval)interval
               repeats:(BOOL)repeats
                 async:(BOOL)async {
    
    dispatch_queue_t queue = async ? dispatch_get_global_queue(0, 0) : dispatch_get_main_queue();
    
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, begin * NSEC_PER_SEC), interval * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    
    NSString *name = [NSString stringWithFormat:@"%ld", [GCDTimerDict_ count]];
    // 需要有强引用才能执行
    [GCDTimerDict_ setObject:timer forKey:name];
    
    dispatch_source_set_event_handler(timer, ^{
        task();
        if (!repeats) {
            [self cancelTask:name];
        }
    });
    
    dispatch_resume(timer);
    return name;
}

+ (NSString *)excuTask:(id)target
              selector:(SEL)selector
                 begin:(NSTimeInterval)begin
              interval:(NSTimeInterval)interval
               repeats:(BOOL)repeats
                 async:(BOOL)async {
    if (!target || !selector) {
        return nil;
    }
    return [self excuTask:^{
        if ([target respondsToSelector:selector]) {
            [target performSelector:selector];
        }
    } begin:begin interval:interval repeats:repeats async:async];
}

+ (void)cancelTask:(NSString *)name {
    
    if ([name length] == 0) {
        return;;
    }
    
    dispatch_source_t timer = GCDTimerDict_[name];
    if (timer) {
        dispatch_source_cancel(timer);
        [GCDTimerDict_ removeObjectForKey:name];
    }
}

@end
