//
//  FacadeVideo.m
//  test
//
//  Created by 张森 on 2021/3/3.
//

#import "FacadeVideo.h"

@implementation FacadeVideo {
    
    NSString *_type;
}

- (instancetype)initWithFileName:(NSString *)fileName {
    
    self = [super init];
    if (self) {
        if ([fileName containsString:@"mp4"]) {
            
            _type = @"mp4";
        } else {
            
            _type = @"wmv";
        }
    }
    return self;
}

- (NSString *)getVideoType {
    
    return _type;
}

- (void)setVideoType:(NSString *)type {
    
    _type = type;
}

@end
