//
//  BFactory.m
//  test
//
//  Created by 张森 on 2021/1/26.
//

#import "BFactory.h"
#import "BChairProduct.h"
#import "BTableProduct.h"
@implementation BFactory

- (ChairProduct *)createChair {
    
    return [BChairProduct new];
}
- (TableProduct *)createTable {
    
    return [BTableProduct new];
}
@end
