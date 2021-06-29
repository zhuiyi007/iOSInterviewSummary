//
//  FacadeVideo.h
//  test
//
//  Created by 张森 on 2021/3/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FacadeVideo : NSObject

- (instancetype)initWithFileName:(NSString *)fileName;

- (NSString *)getVideoType;

- (void)setVideoType:(NSString *)type;
@end

NS_ASSUME_NONNULL_END
