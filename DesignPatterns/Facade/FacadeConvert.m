//
//  FacadeConvert.m
//  test
//
//  Created by 张森 on 2021/3/3.
//

#import "FacadeConvert.h"
#import "FacadeMP4Decode.h"
#import "FacadeWMVDecode.h"

@implementation FacadeConvert

+ (FacadeVideo *)convert:(NSString *)fileName :(NSString *)format {
    
    // 加载这个视频
    FacadeVideo *video = [[FacadeVideo alloc] initWithFileName:fileName];
    
    if ([format isEqualToString:@"mp4"]) {
        video = [FacadeMP4Decode convertToMP4:video];
    } else {
        video = [FacadeWMVDecode convertToWMV:video];
    }
    return video;
}

@end
