//
//  BasicFactory.m
//  test
//
//  Created by 张森 on 2021/1/26.
//

#import "BasicFactory.h"

@implementation BasicFactory

- (ChairProduct *)createChair {
    
    return [ChairProduct new];
}
- (TableProduct *)createTable {
    
    return [TableProduct new];
}
@end
