//
//  ThreadLockMutexLock2.m
//  test
//
//  Created by 张森 on 2021/3/30.
//

#import "ThreadLockMutexLock2.h"
#import <pthread.h>
@interface ThreadLockMutexLock2 ()

@property (nonatomic, assign) pthread_mutex_t mutex;

@end

@implementation ThreadLockMutexLock2

- (void)__initMute:(pthread_mutex_t *)mutex {
    
    pthread_mutexattr_t attr;
    pthread_mutexattr_init(&attr);
    pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
    pthread_mutex_init(mutex, &attr);
    
    pthread_mutexattr_destroy(&attr);
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self __initMute:&_mutex];
    }
    return self;
}

- (void)otherTest {
 
    pthread_mutex_lock(&_mutex);
    NSLog(@"%s", __func__);
    static int i = 0;
    if (i < 10) {
        i ++;
        // 递归调用
        [self otherTest];
    }
    pthread_mutex_unlock(&_mutex);
}

@end
