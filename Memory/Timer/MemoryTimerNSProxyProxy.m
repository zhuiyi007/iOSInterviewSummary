//
//  MemoryTimerNSProxyProxy.m
//  test
//
//  Created by 张森 on 2021/4/1.
//

#import "MemoryTimerNSProxyProxy.h"

@interface MemoryTimerNSProxyProxy ()

@property (nonatomic, weak) id target;

@end

@implementation MemoryTimerNSProxyProxy
+ (instancetype)createWithTarget:(id)target {
    
    MemoryTimerNSProxyProxy *proxy = [MemoryTimerNSProxyProxy alloc];
    proxy.target = target;
    return proxy;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    
    return [self.target methodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    
    [invocation invokeWithTarget:self.target];
}
@end
