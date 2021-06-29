//
//  RunTimeSuperStudent.m
//  test
//
//  Created by 张森 on 2021/3/24.
//

#import "RunTimeSuperStudent.h"

@implementation RunTimeSuperStudent

- (void)run {
    
    [super run];
    NSLog(@"%@, %s", self, _cmd);
}

/*
- (instancetype)init
{
    self = [super init];
    if (self) {
        NSLog(@"%@", [self class]);         // RunTimeSuperStudent
        NSLog(@"%@", [self superclass]);    // RunTimeSuperPerson
        
        NSLog(@"%@", [super class]);        // RunTimeSuperStudent
        NSLog(@"%@", [super superclass]);   // RunTimeSuperPerson
    }
    return self;
}
 */
@end
