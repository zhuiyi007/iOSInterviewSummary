//
//  RunTimeApplyFunctionPerson.m
//  test
//
//  Created by 张森 on 2021/3/26.
//

#import "RunTimeApplyFunctionPerson.h"

@implementation RunTimeApplyFunctionPerson
- (void)run {
    NSLog(@"++++%@, %s", self, _cmd);
}

- (void)test {
    NSLog(@"----%@, %s", self, _cmd);
}
@end
