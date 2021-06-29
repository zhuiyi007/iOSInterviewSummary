//
//  MemoryTimerNSObjectProxy.m
//  test
//
//  Created by 张森 on 2021/4/1.
//

#import "MemoryTimerNSObjectProxy.h"

@interface MemoryTimerNSObjectProxy ()

@property (nonatomic, weak) id target;

@end

@implementation MemoryTimerNSObjectProxy

+ (instancetype)createWithTarget:(id)target {
    
    MemoryTimerNSObjectProxy *proxy = [[MemoryTimerNSObjectProxy alloc] init];
    proxy.target = target;
    return proxy;
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return self.target;
}

@end
