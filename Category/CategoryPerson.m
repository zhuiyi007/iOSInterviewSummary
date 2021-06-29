//
//  CategoryPerson.m
//  test
//
//  Created by 张森 on 2021/3/16.
//

#import "CategoryPerson.h"

@implementation CategoryPerson
- (void)run {
    NSLog(@"run");
}
+ (void)test {
    NSLog(@"CategoryPerson - Test");
}

+(void)load {
    NSLog(@"CategoryPerson - load");
}

+(void)initialize {
    NSLog(@"CategoryPerson - initialize");
}
@end
