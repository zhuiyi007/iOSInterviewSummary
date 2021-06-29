//
//  ThreadLockOSSpinLock.m
//  test
//
//  Created by 张森 on 2021/3/30.
//

#import "ThreadLockOSSpinLock.h"
#import <libkern/OSSpinLockDeprecated.h>

@interface ThreadLockOSSpinLock ()

@property (nonatomic, assign) OSSpinLock ticketSpinLock;
@property (nonatomic, assign) OSSpinLock moneySpinLock;

@end

@implementation ThreadLockOSSpinLock

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.ticketSpinLock = OS_SPINLOCK_INIT;
        self.moneySpinLock = OS_SPINLOCK_INIT;
    }
    return self;
}

- (void)__saveMoney {
    
    OSSpinLockLock(&_moneySpinLock);
    
    [super __saveMoney];
    
    OSSpinLockUnlock(&_moneySpinLock);
}

- (void)__withdrawMoney {
    
    OSSpinLockLock(&_moneySpinLock);

    [super __withdrawMoney];
    
    OSSpinLockUnlock(&_moneySpinLock);
}

#pragma mark - 卖票问题
- (void)__sellTicket {
    
    // 要加同一把锁
    OSSpinLockLock(&_ticketSpinLock);
    
    [super __sellTicket];
    
    OSSpinLockUnlock(&_ticketSpinLock);
}

@end
