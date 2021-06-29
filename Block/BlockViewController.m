//
//  BlockViewController.m
//  test
//
//  Created by 张森 on 2021/3/17.
//

#import "BlockViewController.h"

//struct __BlockViewController__viewDidLoad_block_desc_0 {
//    size_t reserved;
//    size_t Block_size;
//};
//
//struct __block_impl {
//    void *isa;
//    int Flags;
//    int Reserved;
//    void *FuncPtr;
//};
//
//struct __BlockViewController__viewDidLoad_block_impl_0 {
//    struct __block_impl impl;
//    struct __BlockViewController__viewDidLoad_block_desc_0* Desc;
//    int age;
//};

@interface BlockViewController ()

@end

int age = 10;

@implementation BlockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
#pragma mark - block类型
    
    /**
     程序区域(text区):存放编译后的代码
     ↓
     数据区域(data区):存放全局变量,GlobalBlock
     ↓
     堆区:存放自己alloc init的对象,需要程序员自己释放,MallocBlock
     ↓
     栈区:存放局部变量,不需要自己释放,系统会自动回收,StackBlock
     
     内存地址由小变大
     */
    
    static int height = 20;
    void (^block)(void) = ^{
        NSLog(@"block -- age : %d, height : %d", age, height);
    };
    block();
    // 没有访问auto变量,为GlobalBlock(全局变量和static变量都不是auto变量),存储在全局数据区
    // __NSGlobalBlock__
    NSLog(@"block - %@", [block class]);
    // NSBlock
    NSLog(@"block - %@", [[block class] superclass]);
    // NSObject
    NSLog(@"block - %@", [[[block class] superclass] superclass]);
    
    
    int weight = 20;
    void (^block1)(void) = ^{
        NSLog(@"block1 -- weitht : %d", weight);
    };
    block1();
    // 访问了auto变量,为StackBlock(需要去Build Settings -> Automatic Reference Counting -> 关掉ARC, 否则为__NSMallocBlock__),存储在栈上
    // 如果在外部定义一个方法,方法内有StackBlock,则,调用完方法后,Block内的变量会被释放掉,导致内容混乱
    /**
     void test() {
        int age = 10;
        void (^block)(void) = ^{
            NSLog(@"block -- age : %d", age);
        }
     }
     
     test(); // 调用完后,block内捕获的变量将会被释放
     */
    
    // __NSStackBlock__
    NSLog(@"block1 - %@", [block1 class]);
    // NSBlock
    NSLog(@"block1 - %@", [[block1 class] superclass]);
    // NSObject
    NSLog(@"block1 - %@", [[[block1 class] superclass] superclass]);
    
    
    int name = 20;
    void (^block2)(void) = [^{
        NSLog(@"block2 -- name : %d", name);
    } copy];
    block2();
    // StackBlock调用copy之后,会升级为MeallocBlock,拷贝到堆上
    // GlobalBlock调用copy之后,还是GlobalBlock
    // __NSMeallocBlock__
    NSLog(@"block1 - %@", [block2 class]);
    // NSBlock
    NSLog(@"block1 - %@", [[block2 class] superclass]);
    // NSObject
    NSLog(@"block1 - %@", [[[block2 class] superclass] superclass]);
    
    
#pragma mark - block结构
    /**
     struct __BlockViewController__viewDidLoad_block_impl_0 {
        struct __block_impl impl;
        struct __BlockViewController__viewDidLoad_block_desc_0* Desc;
        // auto变量会捕获到block内部,是值传递
        int age;
        // static变量会捕获到block内部,是指针传递
        int *height;
     
        // 注意入参的age和height,一个是值传递,height是指针类型
        __BlockViewController__viewDidLoad_block_impl_0(void *fp, struct __BlockViewController__viewDidLoad_block_desc_0 *desc, int _age, int *_height, int flags=0) : age(_age), height(_height) {
            impl.isa = &_NSConcreteStackBlock;
            impl.Flags = flags;
            impl.FuncPtr = fp;
            Desc = desc;
        }
     };
        
     static struct __BlockViewController__viewDidLoad_block_desc_0 {
        size_t reserved;
        size_t Block_size;
     }
     
     struct __block_impl {
        void *isa;
        int Flags;
        int Reserved;
        // 指向执行方法的指针
        void *FuncPtr;
     };
     */
    
    /**
     // block的声明
     void (*myBlock)(void) = ((void (*)())&__BlockViewController__viewDidLoad_block_impl_0((void *)__BlockViewController__viewDidLoad_block_func_0, &__BlockViewController__viewDidLoad_block_desc_0_DATA, age, &height));
     
     传递值时,age是值传递,height是指针传递
     简化后 -> void (*myBlock)(void) = &__BlockViewController__viewDidLoad_block_impl_0(
                                    __BlockViewController__viewDidLoad_block_func_0,
                                    &__BlockViewController__viewDidLoad_block_desc_0_DATA,
                                    age,
                                    &height));
     
     相当于调用了__BlockViewController__viewDidLoad_block_impl_0结构体的构造方法,把__BlockViewController__viewDidLoad_block_func_0,__BlockViewController__viewDidLoad_block_desc_0_DATA变量传进去
     
     __BlockViewController__viewDidLoad_block_func_0即block的具体执行代码
     static void __BlockViewController__viewDidLoad_block_func_0(struct __BlockViewController__viewDidLoad_block_impl_0 *__cself) {
        int age = __cself->age; // bound by copy
        int *height = __cself->height; // bound by copy

        NSLog((NSString *)&__NSConstantStringImpl__var_folders_dg_zr9ldz1d1gnch5nbbwpchfbm0000gn_T_BlockViewController_42f6cd_mi_0, age, (*height));
    }
     
     __BlockViewController__viewDidLoad_block_desc_0_DATA即__BlockViewController__viewDidLoad_block_desc_0结构体的构造方法,会把0和block的size传进去
     static struct __BlockViewController__viewDidLoad_block_desc_0 {
        size_t reserved;
        size_t Block_size;
     } __BlockViewController__viewDidLoad_block_desc_0_DATA = { 0, sizeof(struct __BlockViewController__viewDidLoad_block_impl_0)};

     
     
     // block的调用
     ((void (*)(__block_impl *))((__block_impl *)myBlock)->FuncPtr)((__block_impl *)myBlock);
     // 简化后 -> myBlock->FuncPtr(myBlock);
     // 直接调用myBlock的FuncPtr指针执行方法
     // 由于myBlock的第一个结构体为__block_impl,因此,可以把myBlock强转为__block_impl类型,直接调用FuncPtr方法
     
     */
    
    
//    auto int age = 10;
//    static int height = 10;
//
//    void (^myBlock)(void) = ^(){
//        NSLog(@"age is :%d, height is :%d", age, height);
//        /**
//        _name block内部如果使用到成员变量
//        实际上是捕获了Person对象
//        通过Person对象再访问_name
//        Person -> _name
//         */
//    };
//
//    age = 20;
//    height = 20;
//
//    myBlock();
    
    
//    struct __BlockViewController__viewDidLoad_block_impl_0 *block = (__bridge struct __BlockViewController__viewDidLoad_block_impl_0 *)myBlock;
}


@end
