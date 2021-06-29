//
//  RunTimeISAViewController.m
//  test
//
//  Created by 张森 on 2021/3/22.
//

#import "RunTimeISAViewController.h"
#import "RunTimeISAPerson.h"
#import <objc/runtime.h>

@interface RunTimeISAViewController ()

@end

@implementation RunTimeISAViewController

#pragma mark - ISA指针
/**
 
 1. isa在arm64之后采用共用体的形式存储
 2. 简化后的isa共用体
 union isa_t {
    uintptr_t bits;
    Class cls;
    struct {
#     define ISA_MASK        0x0000000ffffffff8ULL
#     define ISA_MAGIC_MASK  0x000003f000000001ULL
#     define ISA_MAGIC_VALUE 0x000001a000000001ULL
        // 0 代表普通的指针,存储着class,meta-class对象的内存地址
        // 1 代表优化过,使用位域存储更多的信息
        uintptr_t nonpointer        : 1;
        // 是否有设置过关联对象,如果没有,释放时会更快
        uintptr_t has_assoc         : 1;
        // 是否有C++的析构函数(.cxx_desturct)如果没有,释放时会更快
        uintptr_t has_cxx_dtor      : 1;
        // 存储Class,meta-Class对象的内存地址信息
        // 由掩码可以推断出,类和元类的地址值最后三位一定是0
        uintptr_t shiftcls          : 33;
        // 用于在调试时分辨对象是否未完成初始化
        uintptr_t magic             : 6;
        // 是否有被弱引用指向过,如果没有,释放时会更快
        uintptr_t weakly_referenced : 1;
        // 未使用,之前是deallocating,现在为isDeallocating和setDeallocating
        uintptr_t unused            : 1;
        // 引用计数器是否过大无法存储在isa中
        // 如果为1,那么引用计数器会存储在一个叫SideTable的类的属性中
        uintptr_t has_sidetable_rc  : 1;
        // 里面存储的值是引用计数器
        uintptr_t extra_rc          : 19
    };
    bool isDeallocating() {
        return extra_rc == 0 && has_sidetable_rc == 0;
    }
    void setDeallocating() {
        extra_rc = 0;
        has_sidetable_rc = 0;
    }
};
*/

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    RunTimeISAPerson *person = [[RunTimeISAPerson alloc] init];
    objc_setAssociatedObject(person, @"age", @(10), OBJC_ASSOCIATION_ASSIGN);
    __weak typeof(person) weakPerson = person;
    
//    (Class) $1 = 0x000025a100e3ce1b RunTimeISAPerson
    
    // 0000 0000 0000 0000 0010 0101 1010 0001 0000 0000 1110 0011 1100 1110 0001 1011
    // |  extra_rc引用计数器   |
    // 0000 0000 0000 0000 0010 0101 1010 0001 0000 0000 1110 0011 1100 1110 0001 1011
    //                        | 0 has_sidetable_rc 引用计数器不过大
    // 0000 0000 0000 0000 0010 0101 1010 0001 0000 0000 1110 0011 1100 1110 0001 1011
    //                           | 1 weakly_referenced 有被弱指针引用过
    // 0000 0000 0000 0000 0010 0101 1010 0001 0000 0000 1110 0011 1100 1110 0001 1011
    //                            |011010|  magic value = 0x1a 代表已经完成初始化
    // 0000 0000 0000 0000 0010 0101 1010 0001 0000 0000 1110 0011 1100 1110 0001 1011
    //                                    | shiftcls 类和元类的地址 33位             |
    // 0000 0000 0000 0000 0010 0101 1010 0001 0000 0000 1110 0011 1100 1110 0001 1011
    //                                     0 has_cxx_dtor  无C++析构函数             |
    // 0000 0000 0000 0000 0010 0101 1010 0001 0000 0000 1110 0011 1100 1110 0001 1011
    //                                                         1 has_assoc 有关联对象 |
    // 0000 0000 0000 0000 0010 0101 1010 0001 0000 0000 1110 0011 1100 1110 0001 1011
    //                                             1 nonpointer 非指针类型,已经进行过优化 |
    
    [person setTall:YES];
    [person setRich:NO];
    [person setCool:YES];
    
    NSLog(@"tall : %d, rich : %d, cool : %d", person.isTall, person.isRich, person.isCool);
    
}

@end
