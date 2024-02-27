//
//  SummaryEntrance.m
//  test
//
//  Created by firstzhang on 2024/2/27.
//

#import "SummaryEntrance.h"
#import "MJClassInfo.h"
#import <objc/runtime.h>
#import <malloc/malloc.h>

@interface Person : NSObject

@end

@implementation Person
- (void)personInstanceMethod {
    
}

+ (void)personClassMethod {
    
}

//- (void)summaryEntranceTest {
//    NSLog(@"- [Person summaryEntranceTest] - %@", self);
//}
//
//+ (void)summaryEntranceTest {
//    NSLog(@"+ [Person summaryEntranceTest] - %@", self);
//}

@end

@interface Student : Person

@end

@implementation Student
- (void)studentInstanceMethod {
    
}

+ (void)studentClassMethod {
    
}
@end

@interface NSObject(SummaryEntrance)

@end

@implementation NSObject(SummaryEntrance)

- (void)summaryEntranceTest {
    NSLog(@"- [NSObject summaryEntranceTest] - %@", self);
}

//+ (void)summaryEntranceTest {
//    NSLog(@"+ [NSObject summaryEntranceTest] - %@", self);
//}

@end


@implementation SummaryEntrance
+ (void)run {
    
    /// 窥探内存结构
    Student *student = [[Student alloc] init];
    Person *person = [[Person alloc] init];
    
    struct mj_objc_class *studentClass = (__bridge struct mj_objc_class*)[Student class];
    struct mj_objc_class *personClass = (__bridge struct mj_objc_class*)[Person class];
    class_rw_t *studentClassData = studentClass->data();
    class_rw_t *personClassData = personClass->data();
    
    struct mj_objc_class *studentMetaClass = (__bridge struct mj_objc_class*)object_getClass([Student class]);
    struct mj_objc_class *personMetaClass = (__bridge struct mj_objc_class*)object_getClass([Person class]);
    class_rw_t *studentMetaClassData = studentMetaClass->data();
    class_rw_t *personMetaClassData = personMetaClass->data();
    
    /// 证明NSObject的元类的superClass指针指向NSObject的类对象
    /// 以下4行打印,如果只实现了-[NSObject summaryEntranceTest]
    /// 则编译也不会报错,但是所有调用都会调用到-[NSObject summaryEntranceTest]方法中
    /// 证明类方法在找完元类对象中发现没有对应的类方法后,还会继续找类对象中是否还有对应的对象方法
    [student summaryEntranceTest];
    [Student summaryEntranceTest];
    
    [[NSObject new] summaryEntranceTest];
    [NSObject summaryEntranceTest];
    
    NSLog(@"aaa");
}
@end
