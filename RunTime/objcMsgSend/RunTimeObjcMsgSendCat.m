//
//  RunTimeObjcMsgSendCat.m
//  test
//
//  Created by 张森 on 2021/3/24.
//

#import "RunTimeObjcMsgSendCat.h"

@implementation RunTimeObjcMsgSendCat

- (void)testInstanceMethod {
    NSLog(@"%@, %s", self, (char *)_cmd);
}
+ (void)testClassMethod {
    NSLog(@"%@, %s", self, (char *)_cmd);
}

- (void)testCatInstanceMethod {
    NSLog(@"%@, %s", self, (char *)_cmd);
}
+ (void)testCatClassMethod {
    NSLog(@"%@, %s", self, (char *)_cmd);
}

@end
