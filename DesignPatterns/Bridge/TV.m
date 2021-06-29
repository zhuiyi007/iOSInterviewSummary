//
//  TV.m
//  test
//
//  Created by 张森 on 2021/2/8.
//

#import "TV.h"

@implementation TV
{
    BOOL _isEnable;
    NSUInteger _volume;
    NSUInteger _channel;
}

- (BOOL)isEnabled {
    
    NSLog(@"%@, enable=%d, volume=%ld, channel=%ld", [self class], _isEnable, _volume, _channel);
    return _isEnable;
}
- (void)enable {
    
    if (_isEnable) {
        
        return;
    }
    _isEnable = YES;
    _volume = 0;
    _channel = 0;
    NSLog(@"%@, enable=%d, volume=%ld, channel=%ld", [self class], _isEnable, _volume, _channel);
}
- (void)disable {
    
    if (!_isEnable) {
        
        return;
    }
    _isEnable = NO;
    _volume = 0;
    _channel = 0;
    NSLog(@"%@, enable=%d, volume=%ld, channel=%ld", [self class], _isEnable, _volume, _channel);
}

- (NSUInteger)getVolume {
    
    NSLog(@"%@, enable=%d, volume=%ld, channel=%ld", [self class], _isEnable, _volume, _channel);
    return _volume;
}
- (void)setVolume:(NSUInteger)volume {
    
    _volume = volume;
    NSLog(@"%@, enable=%d, volume=%ld, channel=%ld", [self class], _isEnable, _volume, _channel);
}

- (NSUInteger)getChannel {
    
    NSLog(@"%@, enable=%d, volume=%ld, channel=%ld", [self class], _isEnable, _volume, _channel);
    return _channel;
}
- (void)setChannel:(NSUInteger)channel {
    
    _channel = channel;
    NSLog(@"%@, enable=%d, volume=%ld, channel=%ld", [self class], _isEnable, _volume, _channel);
}

@end
