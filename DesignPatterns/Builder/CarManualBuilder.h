//
//  CarManualBuilder.h
//  test
//
//  Created by 张森 on 2021/1/28.
//

#import "Builder.h"
#import "Manual.h"

NS_ASSUME_NONNULL_BEGIN

@interface CarManualBuilder : Builder

- (Manual *)getProduct;
@end

NS_ASSUME_NONNULL_END
