//
//  RunLoopPermenantThread.h
//  test
//
//  Created by 张森 on 2021/3/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RunLoopPermenantThread : NSObject

- (void)run;

- (void)excuteTask:(void (^)(void))task;

- (void)stop;

@end

NS_ASSUME_NONNULL_END
