//
//  BlockARCViewController.m
//  test
//
//  Created by 张森 on 2021/3/18.
//

#import "BlockARCViewController.h"
#import "BlockPerson.h"
#import "__block/__Block.h"
#import "BlockCycle.h"

typedef void (^MyBlock)(void);

@interface BlockARCViewController ()

@end

@implementation BlockARCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [__Block excute];
    
    
#pragma mark - ARC环境block捕获auto对象变量的原理
    
    /**
     
     捕获对象与捕获普通变量的实现区别:
     1.声明:会多传一个flag
        &__BlockARCViewController__viewDidLoad_block_impl_0(__BlockARCViewController__viewDidLoad_block_func_0, &__BlockARCViewController__viewDidLoad_block_desc_0_DATA, person, 570425344);
     
     2.__BlockARCViewController__viewDidLoad_block_impl_0结构体会对变量进行相对应的strong和weak引用
        struct __BlockARCViewController__viewDidLoad_block_impl_0 {
            struct __block_impl impl;
            struct __BlockARCViewController__viewDidLoad_block_desc_0* Desc;
            BlockPerson *__strong //(__weak) person;
            __BlockARCViewController__viewDidLoad_block_impl_0(void *fp, struct __BlockARCViewController__viewDidLoad_block_desc_0 *desc, BlockPerson *__strong _person, int flags=0) : person(_person) {
                impl.isa = &_NSConcreteStackBlock;
                impl.Flags = flags;
                impl.FuncPtr = fp;
                Desc = desc;
       }
     };
     
     3.__BlockARCViewController__viewDidLoad_block_desc_0结构体会增加一个copy函数指针和dispose函数指针,当block从栈区copy到堆区时调用copy函数,当block释放时调用dispose函数释放变量
        static struct __BlockARCViewController__viewDidLoad_block_desc_0 {
            size_t reserved;
            size_t Block_size;
            void (*copy)(struct __BlockARCViewController__viewDidLoad_block_impl_0*, struct __BlockARCViewController__viewDidLoad_block_impl_0*);
            void (*dispose)(struct __BlockARCViewController__viewDidLoad_block_impl_0*);
     } __BlockARCViewController__viewDidLoad_block_desc_0_DATA = { 0, sizeof(struct __BlockARCViewController__viewDidLoad_block_impl_0), __BlockARCViewController__viewDidLoad_block_copy_0, __BlockARCViewController__viewDidLoad_block_dispose_0};
     
     4.__BlockARCViewController__viewDidLoad_block_copy_0函数指针
        static void __BlockARCViewController__viewDidLoad_block_copy_0(struct __BlockARCViewController__viewDidLoad_block_impl_0*dst, struct __BlockARCViewController__viewDidLoad_block_impl_0*src) {_Block_object_assign((void*)&dst->person, (void*)src->person, 3);}
     
     5.__BlockARCViewController__viewDidLoad_block_dispose_0函数指针
        static void __BlockARCViewController__viewDidLoad_block_dispose_0(struct __BlockARCViewController__viewDidLoad_block_impl_0*src) {_Block_object_dispose((void*)src->person, 3);}
     
     */
    
    
    
//    MyBlock block;
//    {
//        BlockPerson *person = [[BlockPerson alloc] init];
//        person.age = 10;
        
#warning ----存疑
        /**
         1.当一个block为stackblock时,不会对引用的对象进行强引用
         
         2021-03-18 18:22:24.027383+0800 test[17559:3482763] BlockPerson - dealloc
         
         2021-03-18 18:22:24.027194+0800 test[17559:3482763] ---- finish ----
         ^{
            NSLog(@"---- person.age : %d", person.age);
         };
         */
        
        /**
         2.当一个block有强指针引用,及赋值给block变量后,就会对内部的对象进行强引用
         
         2021-03-18 18:22:24.027194+0800 test[17559:3482763] ---- finish ----
         2021-03-18 18:22:24.027383+0800 test[17559:3482763] BlockPerson - dealloc
         
         
         block = ^{
            NSLog(@"---- person.age : %d", person.age);
         };
         */
        
        /**
         3.当内部的对象变为弱指针引用时,block也会对其变成弱引用
         
         2021-03-18 18:22:24.027383+0800 test[17559:3482763] BlockPerson - dealloc
         2021-03-18 18:22:24.027194+0800 test[17559:3482763] ---- finish ----
         
         __weak BlockPerson *weakPerson = person;
         block = ^{
            NSLog(@"---- person.age : %d", weakPerson.age);
         };
         
         */
        
//    }
//    block();
//    NSLog(@"---- finish ----");
    
#pragma mark - ARC对block copy的时机
    /**
     在ARC环境下,编译器会自动将栈上的Block复制到堆上:
     1.block作为函数返回值时
        MyBlock test(){
            
            int a = 10;
            return ^{
                NSLog(@"---- a : %d", a);
            };
        }
     2.将block赋值给__strong指针时
        int a = 10;
        MyBlock block = ^{
            NSLog(@"----%d", a);
        };
     3.block作为cocoa API中方法名含有usingblock的方法参数时
        NSArray *arr;
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
     
        }];
     4.block作为GCD API的方法参数时
        dispatch_after(1.0, dispatch_get_global_queue(1, 1), ^{
         
        });
     */
}

@end
