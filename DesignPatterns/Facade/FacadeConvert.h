//
//  FacadeConvert.h
//  test
//
//  Created by 张森 on 2021/3/3.
//

#import <Foundation/Foundation.h>
#import "FacadeVideo.h"
NS_ASSUME_NONNULL_BEGIN

@interface FacadeConvert : NSObject

+ (FacadeVideo *)convert:(NSString *)fileName :(NSString *)format;

@end

NS_ASSUME_NONNULL_END
