//
//  Device.h
//  test
//
//  Created by 张森 on 2021/2/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol Device <NSObject>

- (BOOL)isEnabled;
- (void)enable;
- (void)disable;

- (NSUInteger)getVolume;
- (void)setVolume:(NSUInteger)volume;

- (NSUInteger)getChannel;
- (void)setChannel:(NSUInteger)channel;
@end

NS_ASSUME_NONNULL_END
