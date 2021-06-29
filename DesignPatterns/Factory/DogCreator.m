//
//  DogCreator.m
//  test
//
//  Created by 张森 on 2021/1/26.
//

#import "DogCreator.h"
#import "DogProduct.h"

@implementation DogCreator

+ (Product *)createProduct:(NSInteger)type {
    
    return [DogProduct new];
}
@end
