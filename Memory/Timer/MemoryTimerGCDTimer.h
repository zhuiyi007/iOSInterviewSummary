//
//  MemoryTimerGCDTimer.h
//  test
//
//  Created by 张森 on 2021/4/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MemoryTimerGCDTimer : NSObject

+ (NSString *)excuTask:(void(^)(void))task
           begin:(NSTimeInterval)begin
        interval:(NSTimeInterval)interval
         repeats:(BOOL)repeats
           async:(BOOL)async;

+ (NSString *)excuTask:(id)target
              selector:(SEL)selector
                 begin:(NSTimeInterval)begin
              interval:(NSTimeInterval)interval
               repeats:(BOOL)repeats
                 async:(BOOL)async;

+ (void)cancelTask:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
