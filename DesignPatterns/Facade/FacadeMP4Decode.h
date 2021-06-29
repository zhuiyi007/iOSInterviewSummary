//
//  FacadeMP4Decode.h
//  test
//
//  Created by 张森 on 2021/3/3.
//

#import <Foundation/Foundation.h>
#import "FacadeVideo.h"
NS_ASSUME_NONNULL_BEGIN

@interface FacadeMP4Decode : NSObject

+ (FacadeVideo *)convertToMP4:(FacadeVideo *)video;
@end

NS_ASSUME_NONNULL_END
