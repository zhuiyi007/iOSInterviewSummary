//
//  RunTimeObjcMsgSendPerson.m
//  test
//
//  Created by 张森 on 2021/3/23.
//

#import "RunTimeObjcMsgSendPerson.h"
#import <objc/runtime.h>
#import "RunTimeObjcMsgSendCat.h"

@implementation RunTimeObjcMsgSendPerson

void c_otherClassMethod (id self, SEL _cmd) {
    
    NSLog(@"%@, %s", self, _cmd);
}

- (void)otherInstanceMethod {
    NSLog(@"%s", (char *)_cmd);
}
+ (void)otherClassMethod {
    NSLog(@"%s", (char *)_cmd);
}

#pragma mark - 动态方法解析阶段
/*
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    
    if ([NSStringFromSelector(sel) isEqualToString:@"testInstanceMethod"]) {
        
        Method method = class_getInstanceMethod(self, @selector(otherInstanceMethod));
        class_addMethod(self, sel, method_getImplementation(method), method_getTypeEncoding(method));
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}

+ (BOOL)resolveClassMethod:(SEL)sel {
    
    if (sel == @selector(testClassMethod)) {
        
        class_addMethod(object_getClass(self), sel, (IMP)c_otherClassMethod, "v16@0:8");
        return YES;
    }
    return [super resolveClassMethod:sel];
}
*/
#pragma mark - 消息转发阶段
/*
- (id)forwardingTargetForSelector:(SEL)aSelector {
    
    if (aSelector == @selector(testInstanceMethod)) {
        return [[RunTimeObjcMsgSendCat alloc] init];
    }
    return [super forwardingTargetForSelector:aSelector];
}

+ (id)forwardingTargetForSelector:(SEL)aSelector {
    
    if (aSelector == @selector(testClassMethod)) {
        return [RunTimeObjcMsgSendCat class];
    }
    return [super forwardingTargetForSelector:aSelector];
}
 */

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    
    if (aSelector == @selector(testInstanceMethod)) {
        
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
    }
    return [super methodSignatureForSelector:aSelector];
}

+ (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    
    if (aSelector == @selector(testClassMethod)) {
        
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
    }
    return [super methodSignatureForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    NSLog(@"%@, %s", self, _cmd);
}

+ (void)forwardInvocation:(NSInvocation *)anInvocation {
    NSLog(@"%@, %s", self, _cmd);
}
@end
