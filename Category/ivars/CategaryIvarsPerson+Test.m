//
//  CategaryIvarsPerson+Test.m
//  test
//
//  Created by 张森 on 2021/3/17.
//

#import "CategaryIvarsPerson+Test.h"
#import <objc/runtime.h>

@implementation CategaryIvarsPerson (Test)

#pragma mark - 方案3:关联对象
/**
typedef OBJC_ENUM(uintptr_t, objc_AssociationPolicy) {
    OBJC_ASSOCIATION_ASSIGN = 0,            // assign
    OBJC_ASSOCIATION_RETAIN_NONATOMIC = 1,  // strong, nonatomic
    OBJC_ASSOCIATION_COPY_NONATOMIC = 3,    // copy, nonatomic
    OBJC_ASSOCIATION_RETAIN = 01401,        // strong, atomic
    OBJC_ASSOCIATION_COPY = 01403           // copy, atomic
*/

// 这样定义会占用8个字节
//static const void *CategaryIvarsPersonName = &CategaryIvarsPersonName;
// 这样定义只占用1个字节
static const char CategaryIvarsPersonName;

- (void)setName:(NSString *)name {
    
    objc_setAssociatedObject(self, &CategaryIvarsPersonName/**@"name",@selector(name) 这样也可以*/, name, OBJC_ASSOCIATION_COPY_NONATOMIC);
}


- (NSString *)name {
    
    return objc_getAssociatedObject(self, &CategaryIvarsPersonName/**@"name",@selector(name)/_cmd 这样也可以*/);
}

#pragma mark - 方案2:使用全局字典来存
/**
 缺点,无法释放全局字典
 线程安全问题
 */

#pragma mark - 方案1:使用全局变量
// 缺点,所有对象公用一个变量
//int weight_;
//- (int)weight {
//    return weight_;
//}
//
//- (void)setWeight:(int)weight {
//    weight_ = weight;
//}

@end
