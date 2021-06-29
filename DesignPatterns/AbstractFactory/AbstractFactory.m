//
//  AbstractFactory.m
//  test
//
//  Created by 张森 on 2021/1/26.
//

#import "AbstractFactory.h"
#import "BasicFactory.h"
#import "AFactory.h"
#import "BFactory.h"

#import "ChairProduct.h"
#import "TableProduct.h"

@implementation AbstractFactory

+ (void)run:(NSInteger)type {
    
    BasicFactory *factory;
    if (type == 0) {
        
        factory = [AFactory new];
    } else if (type == 1) {
        
        factory = [BFactory new];
    } else {
        
        factory = [BasicFactory new];
    }
    ChairProduct *chair = [factory createChair];
    TableProduct *table = [factory createTable];
    [chair seat];
    [table putSomething];
    
//    ChairProduct *chair = [ChairFactory createChair:2];
//    TableProduct *table = [TableFactory createTable:2];
//    [chair seat];
//    [table putSomething];
}
@end
