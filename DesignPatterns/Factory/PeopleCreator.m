//
//  PeopleCreator.m
//  test
//
//  Created by 张森 on 2021/1/26.
//

#import "PeopleCreator.h"
#import "PeopleProduct.h"

@implementation PeopleCreator

+ (Product *)createProduct:(NSInteger)type {
    
    return [PeopleProduct new];
}
@end
