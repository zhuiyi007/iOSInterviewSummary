//
//  CompositeBox.m
//  test
//
//  Created by 张森 on 2021/2/9.
//

#import "CompositeBox.h"

@implementation CompositeBox
{
    NSMutableArray <id<Composite>>*_productArray;
    NSUInteger _price;
}

+ (instancetype)creatBox {
    
    CompositeBox *box = [[CompositeBox alloc] init];
    box->_productArray = [NSMutableArray array];
    box->_price = 1;
    return box;
}

- (void)add:(id<Composite>)product {
    
    [_productArray addObject:product];
}

- (void)remove:(id<Composite>)product {
    
    [_productArray removeObject:product];
}

- (NSUInteger)price {

    NSUInteger price = _price;
    for (id<Composite> product in _productArray) {
        
        price += [product price];
    }
    return price;
}
@end
