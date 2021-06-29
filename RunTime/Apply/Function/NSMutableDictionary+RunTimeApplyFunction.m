//
//  NSMutableDictionary+RunTimeApplyFunction.m
//  test
//
//  Created by 张森 on 2021/3/26.
//

#import "NSMutableDictionary+RunTimeApplyFunction.h"
#import <objc/runtime.h>

@implementation NSMutableDictionary (RunTimeApplyFunction)

+ (void)load {
    // ⚠️交换时一定要注意真实的类
    Class cls = NSClassFromString(@"__NSDictionaryM");
    Method method1 = class_getInstanceMethod(cls, @selector(setObject:forKeyedSubscript:));
    Method method2 = class_getInstanceMethod(cls, @selector(RunTimeApplyFunction_setObject:forKeyedSubscript:));
    method_exchangeImplementations(method1, method2);
}

- (void)RunTimeApplyFunction_setObject:(id)obj forKeyedSubscript:(id<NSCopying>)key {
    
    if (!key) {
        return;
    }
    [self RunTimeApplyFunction_setObject:obj forKeyedSubscript:key];
}

@end
