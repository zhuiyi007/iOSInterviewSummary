//
//  CategoryIvarsViewController.m
//  test
//
//  Created by 张森 on 2021/3/17.
//

#import "CategoryIvarsViewController.h"
#import "CategaryIvarsPerson+Test.h"
#import <objc/runtime.h>

@interface CategoryIvarsViewController ()

@end

@implementation CategoryIvarsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CategaryIvarsPerson *person = [[CategaryIvarsPerson alloc] init];
    person.age = 10;
    person.name = @"111";
    
    CategaryIvarsPerson *person1 = [[CategaryIvarsPerson alloc] init];
    person1.age = 20;
    person1.name = @"222";
    
    NSLog(@"age = %d, name = %@", person.age, person.name);
    NSLog(@"age = %d, name = %@", person1.age, person1.name);
    
#pragma mark - 分类添加Ivars
    // 核心类
        // AssociationsManager ->
        // AssociationsHashMap <DisguisedPtr<objc_object> /**存放的内容是关联对象的object*/, ObjectAssociationMap> ->
        // ObjectAssociationMap <const void * /**存放的内容是关联对象的key*/, ObjcAssociation> ->
        // ObjcAssociation ->
        // class ObjcAssociation {
        //      uintptr_t _policy;  /**策略*/
        //      id _value;          /**具体的value*/
        // }

    // 核心方法
        // void objc_setAssociatedObject(id object, const void *key, id value, objc_AssociationPolicy policy)
            // void _object_set_associative_reference(id object, const void *key, id value, uintptr_t policy)

        // id objc_getAssociatedObject(id object, const void *key)
            // id _object_get_associative_reference(id object, const void *key)

    // 总结
        // 关联对象并不是存储在被关联对象本身的内存中
        // 关联对象存储在全局统一的一个AssociationsHashMap中
        // 设置关联对象值为nil,则会移除当前关联对象
            // associations.erase(refs_it);
    
    
    // 以下内容会产生坏地址访问崩溃
    // 原因是OBJC_ASSOCIATION_ASSIGN策略并不会对value进行引用
    // 出了作用域后,tempPerson释放,但是
    // 在作用域外ObjcAssociation结构体的value并没有释放,访问时就会产生坏地址
//    {
//
//        CategaryIvarsPerson *tempPerson = [[CategaryIvarsPerson alloc] init];
//        objc_setAssociatedObject(person, @"temp", tempPerson, OBJC_ASSOCIATION_ASSIGN);
//    }
//    NSLog(@"%@", objc_getAssociatedObject(person, @"temp"));
}

@end
