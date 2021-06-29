//
//  RemoteController.h
//  test
//
//  Created by 张森 on 2021/2/8.
//

#import <Foundation/Foundation.h>
#import "Device.h"

NS_ASSUME_NONNULL_BEGIN

@interface RemoteController : NSObject

@property (nonatomic, strong) id<Device> device;

- (void)power;

- (NSUInteger)volumeDown;
- (NSUInteger)volumeUp;

- (NSUInteger)channelDown;
- (NSUInteger)channelUp;

@end

NS_ASSUME_NONNULL_END
