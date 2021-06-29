//
//  FacadeMP4Decode.m
//  test
//
//  Created by 张森 on 2021/3/3.
//

#import "FacadeMP4Decode.h"

@implementation FacadeMP4Decode

+ (FacadeVideo *)convertToMP4:(FacadeVideo *)video {
    
    [video setVideoType:@"mp4"];
    return video;
}
@end
