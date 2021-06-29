//
//  RunLoopThread.m
//  test
//
//  Created by 张森 on 2021/3/29.
//

#import "RunLoopThread.h"

@implementation RunLoopThread

- (void)dealloc {
    
    NSLog(@"%@, %s", self, _cmd);
}

@end
