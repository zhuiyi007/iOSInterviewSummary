//
//  testClass.m
//  test
//
//  Created by 张森 on 2021/1/5.
//

#import "testClass.h"

@implementation testClass

- (BOOL)isRepeat:(NSArray <NSNumber *>*)array {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (NSNumber *num in array) {
        
        if (dic[[num stringValue]]) {
            return YES;
        }
        [dic setValue:num forKey:[num stringValue]];
    }
    return NO;
}


- (BOOL)isSame:(NSString *)str1 str2:(NSString *)str2 {
    
    
    
    NSString *longString = [str1 length] > [str2 length] ? str1 : str2;
    NSString *shortStr = [str1 length] < [str2 length] ? str1 : str2;
    
    NSInteger start = 0;
    NSInteger end = [shortStr length] - 1;
    NSString *subStr;
    while (end < [longString length]) {
        
        subStr = [longString substringWithRange:NSMakeRange(start, end - start)];
        if ([subStr isEqualToString:shortStr]) {
            
            return YES;
        }
        start ++;
        end ++;
    }
    return NO;
}


// 输出0-100个数,两个线程交替输出,一个线程输出奇数,一个输出偶数

+ (void)printNum {
    
    dispatch_semaphore_t sem1 = dispatch_semaphore_create(1);
    dispatch_semaphore_t sem2 = dispatch_semaphore_create(0);
    
    dispatch_queue_t queue1 = dispatch_queue_create("queue1", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t queue2 = dispatch_queue_create("queue2", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue1, ^{
        // 输出偶数
        int i = 0;
        do {
            dispatch_semaphore_wait(sem1, DISPATCH_TIME_FOREVER);
            NSLog(@"%d", i);
            i = i + 2;
            dispatch_semaphore_signal(sem2);
        } while (i <= 100);
        dispatch_semaphore_signal(sem1);
        dispatch_semaphore_signal(sem2);
    });
    
    dispatch_async(queue2, ^{
        
        // 输出奇数
        int i = 1;
        do {
            dispatch_semaphore_wait(sem2, DISPATCH_TIME_FOREVER);
            NSLog(@"%d", i);
            i = i + 2;
            dispatch_semaphore_signal(sem1);
        } while (i < 100);
    });
}


@end
