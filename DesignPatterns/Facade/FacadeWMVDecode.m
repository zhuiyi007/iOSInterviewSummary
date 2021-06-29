//
//  FacadeWMVDecode.m
//  test
//
//  Created by 张森 on 2021/3/3.
//

#import "FacadeWMVDecode.h"

@implementation FacadeWMVDecode


+ (FacadeVideo *)convertToWMV:(FacadeVideo *)video {
    
    [video setVideoType:@"wmv"];
    return video;
}
@end
