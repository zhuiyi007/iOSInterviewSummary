//
//  Builder.h
//  test
//
//  Created by 张森 on 2021/1/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Builder : NSObject

- (void)reset;

- (void)setSeat:(NSUInteger)seat;
- (void)setWindow:(NSUInteger)window;
- (void)setGPS:(NSString *)GPS;

@end

NS_ASSUME_NONNULL_END
