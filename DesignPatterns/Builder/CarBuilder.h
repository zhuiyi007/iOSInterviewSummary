//
//  CarBuilder.h
//  test
//
//  Created by 张森 on 2021/1/28.
//

#import "Builder.h"
#import "Car.h"

NS_ASSUME_NONNULL_BEGIN

@interface CarBuilder : Builder

- (Car *)getProduct;
@end

NS_ASSUME_NONNULL_END
