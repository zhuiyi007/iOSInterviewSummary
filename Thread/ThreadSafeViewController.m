//
//  ThreadSafeViewController.m
//  test
//
//  Created by 张森 on 2021/3/30.
//

#import "ThreadSafeViewController.h"
#import "ThreadLockOSSpinLock.h"
#import "ThreadLockUnfairLock.h"
#import "ThreadLockMutexLock.h"
#import "ThreadLockMutexLock2.h"
#import "ThreadLockMutexLockCondition.h"
#import "ThreadLockNSCondition.h"
#import "ThreadLockNSConditionLock.h"
#import "ThreadLockSerialQueue.h"
#import "ThreadLockSemaphore.h"
#import "ThreadLockSynchnorized.h"
#import "ThreadLockRWLock.h"
#import "ThreadLockBarrier.h"
@interface ThreadSafeViewController ()
@end

@implementation ThreadSafeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    ThreadLockBase *lockBase = [[ThreadLockMutexLockCondition alloc] init];
    [lockBase otherTest];
//    [lockBase ticketsTest];
//    [lockBase moneyTest];
}
@end
