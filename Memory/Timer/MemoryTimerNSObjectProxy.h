//
//  MemoryTimerNSObjectProxy.h
//  test
//
//  Created by 张森 on 2021/4/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MemoryTimerNSObjectProxy : NSObject

+ (instancetype)createWithTarget:(id)target;

@end

NS_ASSUME_NONNULL_END
