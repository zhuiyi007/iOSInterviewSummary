//
//  CategoryViewController.m
//  test
//
//  Created by 张森 on 2021/3/16.
//

#import "CategoryViewController.h"
#import "CategoryPerson.h"
#import "CategoryPerson+Test.h"
#import <objc/runtime.h>
#import "CategoryStudent.h"


@interface CategoryViewController ()

@end

@implementation CategoryViewController

void printMethodOfClass(Class cls) {
    
    unsigned int count;
    Method *methodList = class_copyMethodList(cls, &count);
    
    NSMutableString *methodNames = [NSMutableString string];
    for (NSInteger index = 0; index < count; index ++) {
        Method method = methodList[index];
        NSString *methodName = NSStringFromSelector(method_getName(method));
        [methodNames appendFormat:@"%@, ", methodName];
    }
    free(methodList);
    NSLog(@"%@ - %@", cls, methodNames);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
#pragma mark - category基础
    // 3-4-1-2 -> 3-3-4-2
    // memmove
    // 会判断挪动的方向
    // 3-4-1-2 -> 3-3-4-2
    
    // memcpy
    // 从小地址开始一个个拷贝
    // 3-4-1-2 -> 3-3-1-2 -> 3-3-1-2
    
    
    
    // 编译之后的底层结构是:
    //struct _category_t {
    //    const char *name;
    //    struct _class_t *cls;
    // 实例方法
    //    const struct _method_list_t *instance_methods;
    // 类方法
    //    const struct _method_list_t *class_methods;
    // 协议
    //    const struct _protocol_list_t *protocols;
    // 属性
    //    const struct _prop_list_t *properties;
    //};
    // 在运行时会将category的数据合并到类信息中(类对象,元类对象)
    
    // 重点方法:void attachLists(List* const * addedLists, uint32_t addedCount)
    
//    CategoryPerson *person = [[CategoryPerson alloc] init];
//    [person run];
//    [person test];
    
    
#pragma mark - +load / +initlized
    
    
#pragma mark - load方法调用顺序
    // 所有类的load方法的调用顺序如何决定?
        // - 先调用类的load方法
            // - 按照编译先后顺序调用,先编译先调用
            // - 调用子类load方法之前先调用父类
        // - 再调用分类的load方法
            // - 按编译顺序调用,先编译先调用
    
//    void load_images(const char *path __unused, const struct mach_header *mh)
//    void prepare_load_methods(const headerType *mhdr)
        // classref_t const *classlist = _getObjc2NonlazyClassList(mhdr, &count);
    // schedule_class_load方法中有个递归,会优先把父类的cls先加载
        // schedule_class_load(cls->getSuperclass());
    // 因此父类的load方法优先加载
    // 没有继承关系的类之间,load方法加载顺序跟编译顺序有关
//    void add_class_to_loadable_list(Class cls)
    // 再加载分类的load方法
//    void add_category_to_loadable_list(Category cat)
        // category_t * const *categorylist = _getObjc2NonlazyCategoryList(mhdr, &count);
    // 分类之间的load方法加载顺序只跟编译顺序有关
    
    
#pragma mark - load方法调用原理
    // 所有类和分类的load 方法都会调用
//    CategoryPerson - load
//    CategoryStudent - load
//    CategoryStudent+load2 - load
//    CategoryPerson+load1 - load
//    CategoryStudent+load1 - load
//    CategoryPerson+load2 - load
    // 重点方法
//    static void call_class_loads(void)
    // 以下两个结构体分别存着原来的类和分类中的load方法
//    struct loadable_class {
//        Class cls;  // may be nil
//        IMP method;
//    };
//
//    struct loadable_category {
//        Category cat;  // may be nil
//        IMP method;
//    };
    
//    void call_load_methods(void)
    // 会先调用下面的方法,先调用原来类的load方法
    // 在调用时,会直接取出原来类的load方法地址,直接调用
//    call_class_loads();
    // 然后调用分类中的load方法
    // 在调用时也是直接取出分类中的load方法地址,直接调用
    // 调用顺序跟编译顺序相同
//    call_category_loads();
    
//    CategoryPerson - load, test, load, test, load, test,
//    printMethodOfClass(object_getClass([person class]));
    // 其他方法是通过objc_msgsend方法调用,就会被分类覆盖
//    [CategoryPerson test];
    
#pragma mark - initialize方法
    /**
     在类第一次接受消息时调用
     先调用父类的initialize,再调用子类的initialize
        CategoryPerson - initialize
        CategoryStudent+initialize2 - initialize
     分类中的调用顺序参考objc_msgsend
     
     调用方法时会通过isa查找方法列表:
     Method class_getInstanceMethod(Class cls, SEL sel)
     IMP lookUpImpOrForward(id inst, SEL sel, Class cls, int behavior)
     static Class realizeAndInitializeIfNeeded_locked(id inst, Class cls, bool initialize)
     static Class initializeAndLeaveLocked(Class cls, id obj, mutex_t& lock)
     static Class initializeAndMaybeRelock(Class cls, id inst,mutex_t& lock, bool leaveLocked)
     void initializeNonMetaClass(Class cls)
        递归调用父类的 void initializeNonMetaClass(Class cls)
     void callInitialize(Class cls)
     ((void(*)(Class, SEL))objc_msgSend)(cls, @selector(initialize));
     
     */
    [CategoryStudent alloc];
    
#pragma mark - +load / +initlized 区别
    /**
     - 调用方式的区别
     initialize是通过objc_msgSend调用的:
        如果子类没有实现initialize,会调用父类的initialize,因此,当子类没有实现initialize方法时,父类的initialize会调用多次,但其实每个类只会初始化一次
            if (自己没有初始化) {
                if (父类没有初始化) {
                    objc_msgSend([Person class], @selector(initialize));
                }
                objc_msgSend([Student class], @selector(initialize));
            }
     load是通过查找IMP指针直接调用的方式
     
     - 调用时刻
     load是runtime加载类,分类时调用,只会调用一次
     initialize是类第一次接受消息的时候调用,每一个类只会initialize一次,但是父类的initialize方法可能会调用多次
     
     - 调用顺序
     load会先调用类的load,按照编译顺序先后决定;其次调用分类的load,分类的load根据编译顺序先后决定
     initialize先初始化父类,再初始化子类(可能调用的是父类的initialize)
     */
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
