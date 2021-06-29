//
//  CompositeProduct.h
//  test
//
//  Created by 张森 on 2021/2/9.
//

#import <Foundation/Foundation.h>
#import "Composite.h"

NS_ASSUME_NONNULL_BEGIN

@interface CompositeProduct : NSObject<Composite>
+ (instancetype)creatProduct:(NSUInteger)price;
@end

NS_ASSUME_NONNULL_END
