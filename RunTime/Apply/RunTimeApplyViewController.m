//
//  RunTimeApplyViewController.m
//  test
//
//  Created by 张森 on 2021/3/25.
//

#import "RunTimeApplyViewController.h"
#import "RunTimeApplyPerson.h"
#import "RunTimeApplyCat.h"
#import <objc/runtime.h>

@interface RunTimeApplyViewController ()

@end

@implementation RunTimeApplyViewController

#pragma mark - 修改,判断类相关的操作
void modifyClass() {
    RunTimeApplyPerson *person = [[RunTimeApplyPerson alloc] init];
    
    [person run];
    
    // 动态修改一个类的isa指针
    object_setClass(person, [RunTimeApplyCat class]);
    [person run];
    
    // 判断一个对象是否是类对象
    // 0, 1, 1
    NSLog(@"%d, %d, %d", object_isClass(person), object_isClass([person class]), object_isClass(object_getClass([person class])));
    // 判断一个类对象是否是元类对象
    // 0, 0, 1
    NSLog(@"%d, %d, %d", class_isMetaClass(person), class_isMetaClass([person class]), class_isMetaClass(object_getClass([person class])));
}

#pragma mark - 创建类相关的操作
void RunTimeApplyDogRun(id self, SEL _cmd) {
    
    NSLog(@"%@, %s", self, _cmd);
}

void createClass() {
    
    // 添加类
    Class RunTimeApplyDog = objc_allocateClassPair([NSObject class], "RunTimeApplyDog", 0);
    // 添加成员变量(只能在register之前注册)
    // ivars是在只读列表中class_ro_t
    class_addIvar(RunTimeApplyDog, "_age", 4, 1, @encode(int));
    class_addIvar(RunTimeApplyDog, "_weight", 4, 1, "i");
    // 添加方法
    class_addMethod(RunTimeApplyDog, @selector(run), (IMP)RunTimeApplyDogRun, "v@:");
    objc_registerClassPair(RunTimeApplyDog);
    
    id dog = [[RunTimeApplyDog alloc] init];
    [dog run];
    
    // 不使用时需要释放
    objc_disposeClassPair(RunTimeApplyDog);
    
}

#pragma mark - 成员变量相关的操作
void ivars() {
    
    RunTimeApplyPerson *person = [[RunTimeApplyPerson alloc] init];
    // 获取成员变量的ivar
    Ivar ivar = class_getInstanceVariable([person class], "_name");
    // 为ivar设置值
    object_setIvar(person, ivar, @"123");
    // 获取ivar的值
    NSLog(@"RunTimeApplyPerson -> %s : %@, %s", ivar_getName(ivar),  object_getIvar(person, ivar), ivar_getTypeEncoding(ivar));
    
    // 获取成员变量列表
    // 可以获取系统私有类的成员变量列表来进行一些操作
    //  - 例如,可以直接设置testField的placeholder
    //  - JSON转模型
    NSLog(@"-----------");
    unsigned int count;
    Ivar *ivars = class_copyIvarList([person class], &count);
    for (NSInteger index = 0; index < count; index ++) {
        
        Ivar ivar1 = ivars[index];
        NSLog(@"RunTimeApplyPerson -> %s : %@, %s", ivar_getName(ivar1),  object_getIvar(person, ivar1), ivar_getTypeEncoding(ivar1));
    }
    free(ivars);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    ivars();
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
