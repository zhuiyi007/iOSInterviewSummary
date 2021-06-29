//
//  ThreadLockMutexLock.m
//  test
//
//  Created by 张森 on 2021/3/30.
//

#import "ThreadLockMutexLock.h"
#import <pthread.h>

@interface ThreadLockMutexLock ()

@property (nonatomic, assign) pthread_mutex_t ticketMutexLock;
@property (nonatomic, assign) pthread_mutex_t moneyMutexLock;

@end

@implementation ThreadLockMutexLock

- (void)__initMutexLock:(pthread_mutex_t *)t {
//    pthread_mutexattr_t attr;
//    pthread_mutexattr_init(&attr);
//    pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_NORMAL);
//    pthread_mutex_init(t, &attr);
//    pthread_mutexattr_destroy(&attr);
    
    pthread_mutex_init(t, NULL);
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self __initMutexLock:&_ticketMutexLock];
        [self __initMutexLock:&_moneyMutexLock];
    }
    return self;
}

- (void)__saveMoney {
    
    pthread_mutex_lock(&_moneyMutexLock);
    [super __saveMoney];
    pthread_mutex_unlock(&_moneyMutexLock);
}

- (void)__withdrawMoney {
    
    pthread_mutex_lock(&_moneyMutexLock);
    [super __withdrawMoney];
    pthread_mutex_unlock(&_moneyMutexLock);
}

- (void)__sellTicket {
    
    pthread_mutex_lock(&_ticketMutexLock);
    [super __sellTicket];
    pthread_mutex_unlock(&_ticketMutexLock);
}

- (void)dealloc {
    
    pthread_mutex_destroy(&_ticketMutexLock);
    pthread_mutex_destroy(&_moneyMutexLock);
}

@end
