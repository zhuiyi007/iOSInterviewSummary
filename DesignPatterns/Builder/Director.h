//
//  Director.h
//  test
//
//  Created by 张森 on 2021/1/28.
//

#import <Foundation/Foundation.h>
#import "Builder.h"

NS_ASSUME_NONNULL_BEGIN

@interface Director : NSObject

- (void)getSUVCar:(Builder *)build;
- (void)getSportCar:(Builder *)build;

- (void)getSUVCarManual:(Builder *)build;
- (void)getSportCarManual:(Builder *)build;
@end

NS_ASSUME_NONNULL_END
