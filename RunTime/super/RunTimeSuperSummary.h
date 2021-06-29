//
//  RunTimeSuperSummary.h
//  test
//
//  Created by 张森 on 2021/3/24.
//

#ifndef RunTimeSuperSummary_h
#define RunTimeSuperSummary_h

#param mark - super底层实现
/**
 1. 调用[super run], 转成C++代码后:
    - objc_msgSendSuper((__rw_objc_super){self, class_getSuperclass(objc_getClass("RunTimeSuperStudent"))}, sel_registerName("run"));
    - objc_super结构体
        struct objc_super {
            __unsafe_unretained _Nonnull id receiver;
            __unsafe_unretained _Nonnull Class super_class;
        };
 2. objc_msgSendSuper实现:
    - OBJC_EXPORT id _Nullable objc_msgSendSuper(struct objc_super * _Nonnull super, SEL _Nonnull op, ...)
    - 两个参数,第一个是objc_super类型的结构体, 第二个是SEL
    - the superclass at which to start searching for the method implementation.
    - 寻找方法时会从superClass开始寻找
    - 即,当用super调用方法时,是直接从父类的方法列表中开始去寻找
    - 但是实际调用方法的,还是self
 3. 打印结果
    - NSLog(@"%@", [super class]);        // RunTimeSuperStudent
        - class方法默认都在NSObject类中实现
        - - (Class)class {
                return object_getClass(self);
            }
        - 默认返回self的类, 因此会返回Student
    - NSLog(@"%@", [super superclass]);   // RunTimeSuperPerson
        - superClass方法默认都在NSObject类中实现
        - - (Class)superclass {
                return [self class]->getSuperclass();
            }
        - 默认返回self的superClass, 因此会返回Person
 */

#param mark - isKindOfClass/isMemberOfClass
/**
 NSLog(@"%@", [[NSObject class] isKindOfClass:[NSObject class]]);   // 1
 NSLog(@"%@", [[NSObject class] isMemberOfClass:[NSObject class]]); // 0
 NSLog(@"%@", [[Person class] isKindOfClass:[Person class]]);       // 0
 NSLog(@"%@", [[Person class] isMemberOfClass:[Person class]]);     // 0
 
 - 总结:
    当对象调用时,后面的参数应该传类对象
    当类对象调用时,后面的参数应该穿元类对象
    - NSObject的Meta-Class的superClass为NSObject的类对象
 
 - 方法具体实现
 + (BOOL)isMemberOfClass:(Class)cls {
    // 类调用时,会判断当前类的元类是否等于传进来的类对象
     return self->ISA() == cls;
 }

 - (BOOL)isMemberOfClass:(Class)cls {
    // 对象调用时,会判断当前对象的类是否等于传进来的类对象
     return [self class] == cls;
 }

 + (BOOL)isKindOfClass:(Class)cls {
    // 类对象调用时,会循环查找当前类的元类是否等于传进来的类对象
     for (Class tcls = self->ISA(); tcls; tcls = tcls->getSuperclass()) {
         if (tcls == cls) return YES;
     }
     return NO;
 }

 - (BOOL)isKindOfClass:(Class)cls {
    // 对象调用时,会循环查找当前对象的类是否等于传进来的类对象
     for (Class tcls = [self class]; tcls; tcls = tcls->getSuperclass()) {
         if (tcls == cls) return YES;
     }
     return NO;
 }
 */

#endif /* RunTimeSuperSummary_h */
