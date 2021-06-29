//
//  ThreadLockSynchnorized.m
//  test
//
//  Created by 张森 on 2021/3/31.
//

#import "ThreadLockSynchnorized.h"
#import <objc/runtime.h>

@implementation ThreadLockSynchnorized

- (void)__saveMoney {
    
    @synchronized (self) {
        
        [super __saveMoney];
    }
}

- (void)__withdrawMoney {
    
    @synchronized (self) {
        
        [super __withdrawMoney];
    }
}

- (void)__sellTicket {
    
    @synchronized ([self class]) {
        
        [super __sellTicket];
    }
}

- (void)otherTest {
    
    [[[NSThread alloc] initWithBlock:^{
            
        @synchronized (object_getClass([self class])) {
            
            NSLog(@"%s, %@", __func__, [NSThread currentThread]);
            // 支持递归调用
            [self otherTest];
        }
    }] start];
}

@end
