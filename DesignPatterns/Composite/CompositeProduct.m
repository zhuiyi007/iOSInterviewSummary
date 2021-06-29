//
//  Product.m
//  test
//
//  Created by 张森 on 2021/2/9.
//

#import "CompositeProduct.h"

@implementation CompositeProduct
{
    NSUInteger _price;
}

+ (instancetype)creatProduct:(NSUInteger)price {
    
    CompositeProduct *product = [[CompositeProduct alloc] init];
    product->_price = price;
    return product;
}

- (NSUInteger)price {

    return _price;
}
@end
