//
//  Creator.m
//  test
//
//  Created by 张森 on 2021/1/26.
//

#import "Creator.h"

@implementation Creator

+ (Product *)createProduct:(NSInteger)type {
    
    return [Product new];
}
@end
