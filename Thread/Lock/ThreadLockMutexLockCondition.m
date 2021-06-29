//
//  ThreadLockMutexLockCondition.m
//  test
//
//  Created by 张森 on 2021/3/30.
//

#import "ThreadLockMutexLockCondition.h"
#import <pthread.h>

@interface ThreadLockMutexLockCondition ()

@property (nonatomic, assign) pthread_mutex_t mutex;
@property (nonatomic, assign) pthread_cond_t condition1;

@end

@implementation ThreadLockMutexLockCondition

- (instancetype)init
{
    self = [super init];
    if (self) {
        pthread_mutexattr_t attr;
        pthread_mutexattr_init(&attr);
        pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_NORMAL);
        pthread_mutex_init(&_mutex, &attr);
        
        pthread_cond_init(&_condition1, NULL);
        
        pthread_mutexattr_destroy(&attr);
    }
    return self;
}

- (void)otherTest {
    
    [[[NSThread alloc] initWithTarget:self selector:@selector(printJishu) object:nil] start];
    [[[NSThread alloc] initWithTarget:self selector:@selector(printOushu) object:nil] start];
}

//int number = 0;
//- (void)printOushu {
//
//    do {
//        if (number % 2 == 1) {
//            pthread_cond_signal(&_condition1);
//            pthread_cond_wait(&_condition1, &_mutex);
//        }
//        NSLog(@"%d", number);
//        number ++;
//    } while (number <= 100);
//    NSLog(@"oushu--finish");
//}
//
//- (void)printJishu {
//
//    do {
//        if (number % 2 == 0) {
//            pthread_cond_signal(&_condition1);
//            pthread_cond_wait(&_condition1, &_mutex);
//        }
//        NSLog(@"%d", number);
//        number ++;
//    } while (number < 100);
//    pthread_cond_signal(&_condition1);
//    pthread_mutex_unlock(&_mutex);
//    NSLog(@"jishu--finish");
//}


- (void)printOushu {

    for (NSInteger index = 0; index <= 100; index += 2) {

        NSLog(@"%ld", (long)index);
        pthread_cond_signal(&_condition1);
        if (index == 100) {
            break;
        }
        pthread_cond_wait(&_condition1, &_mutex);
    }
    NSLog(@"----oushu-finished----");
}

- (void)printJishu {

    for (NSInteger index = 1; index < 100; index += 2) {

        pthread_cond_wait(&_condition1, &_mutex);
        NSLog(@"%ld", (long)index);
        pthread_cond_signal(&_condition1);
    }
    NSLog(@"----jishu-finished----");
    pthread_mutex_unlock(&_mutex);
}

- (void)dealloc {
    
    pthread_cond_destroy(&_condition1);
    pthread_mutex_destroy(&_mutex);
}

@end
