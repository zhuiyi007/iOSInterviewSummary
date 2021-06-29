//
//  AFactory.m
//  test
//
//  Created by 张森 on 2021/1/26.
//

#import "AFactory.h"
#import "AChairProduct.h"
#import "ATableProduct.h"
@implementation AFactory

- (ChairProduct *)createChair {
    
    return [AChairProduct new];
}
- (TableProduct *)createTable {
    
    return [ATableProduct new];
}
@end
