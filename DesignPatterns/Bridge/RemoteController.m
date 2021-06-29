//
//  RemoteController.m
//  test
//
//  Created by 张森 on 2021/2/8.
//

#import "RemoteController.h"

@implementation RemoteController

- (void)power {
    
    if (self.device.isEnabled) {
        
        [self.device disable];
    } else {
        
        [self.device enable];
    }
}

- (NSUInteger)volumeDown {
    
    [self.device setVolume:[self.device getVolume] - 1];
    return [self.device getVolume];
}
- (NSUInteger)volumeUp {
    
    [self.device setVolume:[self.device getVolume] + 1];
    return [self.device getVolume];
}

- (NSUInteger)channelDown {
    
    [self.device setChannel:[self.device getChannel] - 1];
    return [self.device getChannel];
}
- (NSUInteger)channelUp {
    
    [self.device setChannel:[self.device getChannel] - 1];
    return [self.device getChannel];
}


@end
