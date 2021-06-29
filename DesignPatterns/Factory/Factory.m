//
//  Factory.m
//  test
//
//  Created by 张森 on 2021/1/26.
//

#import "Factory.h"

#import "Creator.h"
#import "DogCreator.h"
#import "PeopleCreator.h"

#import "Product.h"

@implementation Factory

+ (void)run {
    
//    Product *product;
//    if (Dog) {
//        // 如果用户需要狗,则创建狗
//        product = [DogCreator createProduct:0];
//    } else if (People) {
//        // 如果用户需要人,则创建人
//        product = [PeopleCreator createProduct:0];
//    } else {
//        // 用户不指定,则创建默认产品
//        product = [Creator createProduct:0];
//    }
//    
//    // 产品直接执行方法
//    [product run];
//    [product eat];
    
    Product *basicProduct = [Creator createProduct:0];
    
    Product *dogProduct = [DogCreator createProduct:0];
    
    Product *peopleProduct = [PeopleCreator createProduct:0];
    
    [basicProduct run];
    [dogProduct run];
    [peopleProduct run];
}

@end
