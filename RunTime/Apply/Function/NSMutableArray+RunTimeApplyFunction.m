//
//  NSMutableArray+RunTimeApplyFunction.m
//  test
//
//  Created by 张森 on 2021/3/26.
//

#import "NSMutableArray+RunTimeApplyFunction.h"
#import <objc/runtime.h>
@implementation NSMutableArray (RunTimeApplyFunction)

+ (void)load {
    // ⚠️交换时一定要注意真实的类
    Class cls = NSClassFromString(@"__NSArrayM");
    Method method1 = class_getInstanceMethod(cls, @selector(insertObject:atIndex:));
    Method method2 = class_getInstanceMethod(cls, @selector(RunTimeApplyFunction_insertObject:atIndex:));
    method_exchangeImplementations(method1, method2);
}

- (void)RunTimeApplyFunction_insertObject:(id)anObject atIndex:(NSUInteger)index {
    
    if (!anObject) {
        return;
    }
    [self RunTimeApplyFunction_insertObject:anObject atIndex:index];
}

@end
