//
//  ThreadLockBarrier.m
//  test
//
//  Created by 张森 on 2021/4/1.
//

#import "ThreadLockBarrier.h"

@interface ThreadLockBarrier ()

@property (nonatomic, strong) dispatch_queue_t queue;

@end

@implementation ThreadLockBarrier

- (instancetype)init
{
    self = [super init];
    if (self) {

        self.queue = dispatch_queue_create("quere", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

- (void)otherTest {
    
    for (NSInteger index = 0; index < 10; index ++) {
        
        [[[NSThread alloc] initWithTarget:self selector:@selector(__read) object:nil] start];
        [[[NSThread alloc] initWithTarget:self selector:@selector(__write) object:nil] start];
    }
}

- (void)__read {

    dispatch_async(self.queue, ^{
        
        sleep(1);
        NSLog(@"%s -- %@", __func__, [NSThread currentThread]);
    });
}

- (void)__write {

    dispatch_barrier_async(self.queue, ^{
        
        sleep(1);
        NSLog(@"%s -- %@", __func__, [NSThread currentThread]);
    });
}

@end
