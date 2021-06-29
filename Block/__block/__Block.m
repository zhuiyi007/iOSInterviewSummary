//
//  __Block.m
//  test
//
//  Created by 张森 on 2021/3/18.
//

#import "__Block.h"
#import <objc/runtime.h>
typedef void (^MyBlock)(void);

@interface __BlockPerson : NSObject

@property (nonatomic, assign) int age;

@end

@implementation __BlockPerson

- (void)dealloc {
    
    NSLog(@"%s", __func__);
}

@end

int num = 20;

@implementation __Block

+ (void)excute {
#pragma mark - __block,__weak
    /**
     1. __block在ARC环境下默认是strong强指针引用
     2. 如果要用弱指针,可以用__block __weak来修饰对象
        -   copy和dispose方法的实现会不同:
            static void __Block_byref_id_object_copy_131(void *dst, void *src) {
                _Block_object_assign(
                                (char*)dst + 40,
                                *(void * *) ((char*)src + 40),
                                131);
            }
            static void __Block_byref_id_object_dispose_131(void *src) {
                _Block_object_dispose(
                                *(void * *) ((char*)src + 40),
                                131);
            }
        -   指针地址+40
            struct __Block_byref_weakPerson_0 {
                void *__isa;    // +8
                __Block_byref_weakPerson_0 *__forwarding;   // +8
                int __flags;    // +4
                int __size;     // +4
                void (*__Block_byref_id_object_copy)(void*, void*); // +8
                void (*__Block_byref_id_object_dispose)(void*);     // +8
                // +40
                // 因此,copy方法和dispose方法实际上是对这个weakPerson进行的操作
                __BlockPerson *__weak weakPerson;
            };
     */
    
    __BlockPerson *person = [[__BlockPerson alloc] init];
    __BlockPerson *person2 = [[__BlockPerson alloc] init];
    person.age = 10;
    person2.age = 20;
    __block __weak typeof(person) weakPerson = person;
    __block __weak typeof(person) weakPerson2 = person;
    MyBlock block = ^{
        
        NSLog(@"age -> %d", weakPerson.age);
        NSLog(@"age -> %d", weakPerson2.age);
    };
    block();
    NSLog(@"----");
    
    
    
#pragma mark - forwarding指针
    /**
     1. 栈区的forwarding指针指向本身
     2. 当复制到堆后,栈区的forwarding指针指向复制到堆上的__block变量用结构体的指针
        - 堆区的forwarding指针指向本身
     */
    
    
#pragma mark - 对象类型的auto变量和__block变量
    
    /**
     1.当block在栈上时,不会对对象类型auto变量和__block变量产生强引用
        可以在MRC环境下证明
            static int height = 170;
            __block int age = 10;
            NSObject *object = [[NSObject alloc] init];
     
            MyBlock block = ^{
                
                // 数据区
                num -> 0x100008048
                height -> 0x10000804c
                // 栈区
                age -> 0x7ffeefbff4e8
                // 堆区,且retain count = 1
                object -> 0x1004584b0
     
                NSLog(@"num -> %p", &num);
                NSLog(@"height -> %p", &height);
                NSLog(@"age -> %p", &age);
                NSLog(@"object -> %p", object);
            };
            block();
     
     2.当block拷贝到堆上时,都会通过copy函数来处理他们
        static void ____Block__excute_block_copy_0(struct ____Block__excute_block_impl_0*dst, struct ____Block__excute_block_impl_0*src) {
            _Block_object_assign((void*)&dst->age,
            (void*)src->age, 8 // BLOCK_FIELD_IS_BYREF);
            _Block_object_assign((void*)&dst->object,(void*)src->object, 3 // BLOCK_FIELD_IS_OBJECT);
        }
        __block变量传 8 BLOCK_FIELD_IS_BYREF
        对象变量传 3 BLOCK_FIELD_IS_OBJECT
     3.当block从堆上移除时,都会通过dispose函数来释放他们
        static void ____Block__excute_block_dispose_0(struct ____Block__excute_block_impl_0*src) {
            _Block_object_dispose((void*)src->age, 8 //BLOCK_FIELD_IS_BYREF);
            _Block_object_dispose((void*)src->object, 3 // BLOCK_FIELD_IS_OBJECT);
        }
     */
    
//    static int height = 170;
//    __block int age = 10;
//    NSObject *object = [[NSObject alloc] init];
//
//    MyBlock block = ^{
//
//        NSLog(@"num -> %p", &num);
//        NSLog(@"height -> %p", &height);
//        NSLog(@"age -> %p", &age);
//        NSLog(@"object -> %p", object);
//    };
//    block();
    
    
    
    
#pragma mark - __block的本质
    /**
     
     被__block修饰的变量会自动转成对象被block捕获
     1. 变量声明
        __attribute__((__blocks__(byref))) __Block_byref_a_0 a = {(void*)0,(__Block_byref_a_0 *)&a, 0, sizeof(__Block_byref_a_0), 10};
        __attribute__((__blocks__(byref))) __Block_byref_obj_1 obj = {(void*)0,(__Block_byref_obj_1 *)&obj, 33554432, sizeof(__Block_byref_obj_1), __Block_byref_id_object_copy_131, __Block_byref_id_object_dispose_131, ((NSObject *(*)(id, SEL))(void *)objc_msgSend)((id)((NSObject *(*)(id, SEL))(void *)objc_msgSend)((id)objc_getClass("NSObject"), sel_registerName("alloc")), sel_registerName("init"))};
     
        简化后 ->
            __Block_byref_a_0 a = { 0,
                                    &a,
                                    0,
                                    sizeof(__Block_byref_a_0),
                                    10};
     
            __Block_byref_obj_1 obj = { 0,
                                        &obj,
                                        33554432, sizeof(__Block_byref_obj_1),
                                        __Block_byref_id_object_copy_131,
                                        __Block_byref_id_object_dispose_131,
                                        objc_msgSend(objc_msgSend)(objc_getClass("NSObject"),
                                        sel_registerName("alloc")),
                                        sel_registerName("init"))};
     
     2. 变量结构体__Block_byref_a_0, __Block_byref_obj_1
        struct __Block_byref_a_0 {
            void *__isa;                        // 0
            __Block_byref_a_0 *__forwarding;    // &a,即指向本身
            int __flags;                        // 0
            int __size;                         // sizeof(__Block_byref_a_0)
            int a;                              // 10
        };
        struct __Block_byref_obj_1 {
            void *__isa;                        // 0
            __Block_byref_obj_1 *__forwarding;  // &obj,即指向本身
            int __flags;                        // 33554432
            int __size;                         // sizeof(__Block_byref_obj_1)
            void (*__Block_byref_id_object_copy)(void*, void*); // __Block_byref_id_object_copy_131
            void (*__Block_byref_id_object_dispose)(void*);     // __Block_byref_id_object_dispose_131
            NSObject *obj;                      // [[NSObject alloc] init]
        };
     
     
     3. block结构体____Block__excute_block_impl_0
        struct ____Block__excute_block_impl_0 {
            struct __block_impl impl;
            struct ____Block__excute_block_desc_0* Desc;
            __Block_byref_a_0 *a; // by ref
            __Block_byref_obj_1 *obj; // by ref
            ____Block__excute_block_impl_0(void *fp, struct ____Block__excute_block_desc_0 *desc, __Block_byref_a_0 *_a, __Block_byref_obj_1 *_obj, int flags=0) : a(_a->__forwarding), obj(_obj->__forwarding) {
                impl.isa = &_NSConcreteStackBlock;
                impl.Flags = flags;
                impl.FuncPtr = fp;
                Desc = desc;
            }
        };
     
     4. block赋值
        MyBlock block = ((void (*)())&____Block__excute_block_impl_0((void *)____Block__excute_block_func_0, &____Block__excute_block_desc_0_DATA, (__Block_byref_a_0 *)&a, (__Block_byref_obj_1 *)&obj, 570425344));
        简化后 ->
            MyBlock block = &____Block__excute_block_impl_0(
                                ____Block__excute_block_func_0,
                                &____Block__excute_block_desc_0_DATA,
                                (__Block_byref_a_0 *)&a,
                                (__Block_byref_obj_1 *)&obj,
                                570425344));
     
     5. block执行
        static void ____Block__excute_block_func_0(struct ____Block__excute_block_impl_0 *__cself) {
            // 从block结构体中取出*a和*obj
            __Block_byref_a_0 *a = __cself->a; // bound by ref
            __Block_byref_obj_1 *obj = __cself->obj; // bound by ref
            // 从a中取出forwarding指针,通过指针访问a变量,进行值修改
            (a->__forwarding->a) = 20;
            // 从obj中取出forwarding指针,通过指针访问obj变量,进行值修改
            (obj->__forwarding->obj) = __null;
            // 目前的__forwarding暂时指向自己本身
         }
     */
    
//    __block int a = 10;
//    __block NSObject *obj = [[NSObject alloc] init];
//
//    MyBlock block = ^{
//
//        a = 20;
//        obj = nil;
//        NSLog(@"age is %d, obj is %@", a, obj);
//    };
//
//    block();
    
}
@end
