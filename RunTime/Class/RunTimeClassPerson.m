//
//  RunTimeClassPerson.m
//  test
//
//  Created by 张森 on 2021/3/23.
//

#import "RunTimeClassPerson.h"

@implementation RunTimeClassPerson
- (int)runTimeClassPersonTestFunc:(NSString *)func {
    
    NSLog(@"%s", __func__);
    return 0;
}

+ (NSString *)runTimeClassPersonTestClassFunc:(NSString *)func {
    
    NSLog(@"%s", __func__);
    return @"0";
}
@end
