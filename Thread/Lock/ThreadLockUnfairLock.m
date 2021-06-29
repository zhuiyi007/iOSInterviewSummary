//
//  ThreadLockUnfairLock.m
//  test
//
//  Created by 张森 on 2021/3/30.
//

#import "ThreadLockUnfairLock.h"
#import <os/lock.h>

@interface ThreadLockUnfairLock ()

@property (nonatomic, assign) os_unfair_lock ticketUnfairLock;
@property (nonatomic, assign) os_unfair_lock moneyUnfairLock;

@end

@implementation ThreadLockUnfairLock

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.ticketUnfairLock = OS_UNFAIR_LOCK_INIT;
        self.moneyUnfairLock = OS_UNFAIR_LOCK_INIT;
    }
    return self;
}

- (void)__saveMoney {
    
    os_unfair_lock_lock(&_moneyUnfairLock);
    [super __saveMoney];
    os_unfair_lock_unlock(&_moneyUnfairLock);
}

- (void)__withdrawMoney {
    os_unfair_lock_lock(&_moneyUnfairLock);
    [super __withdrawMoney];
    os_unfair_lock_unlock(&_moneyUnfairLock);
}

- (void)__sellTicket {
    os_unfair_lock_lock(&_ticketUnfairLock);
    [super __sellTicket];
    os_unfair_lock_unlock(&_ticketUnfairLock);
}

@end
