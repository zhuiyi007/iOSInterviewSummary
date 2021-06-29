//
//  ThreadLockRWLock.m
//  test
//
//  Created by 张森 on 2021/4/1.
//

#import "ThreadLockRWLock.h"
#import <pthread.h>

@interface ThreadLockRWLock ()

@property (nonatomic, assign) pthread_rwlock_t rwLock;

@end

@implementation ThreadLockRWLock

- (instancetype)init
{
    self = [super init];
    if (self) {

        pthread_rwlock_init(&_rwLock, NULL);
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

    pthread_rwlock_rdlock(&_rwLock);
    sleep(1);
    NSLog(@"%s -- %@", __func__, [NSThread currentThread]);
    pthread_rwlock_unlock(&_rwLock);
}

- (void)__write {

    pthread_rwlock_wrlock(&_rwLock);
    sleep(1);
    NSLog(@"%s -- %@", __func__, [NSThread currentThread]);
    pthread_rwlock_unlock(&_rwLock);
}
@end
