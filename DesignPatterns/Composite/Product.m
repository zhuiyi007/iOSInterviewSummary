//
//  Product.m
//  test
//
//  Created by 张森 on 2021/2/9.
//

#import "CompositeProduct.h"

@implementation CompositeProduct
{
    float _price;
}

+ (instancetype)creatProduct:(float)price {
    
    CompositeProduct *product = [[CompositeProduct alloc] init];
    product->_price = price;
    return product;
}

- (float)price {

    return _price;
}
@end
