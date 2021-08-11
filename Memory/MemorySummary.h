//
//  MemorySummary.h
//  test
//
//  Created by 张森 on 2021/4/1.
//

#ifndef MemorySummary_h
#define MemorySummary_h

#pragma mark - 定时器泄漏问题
/**
 1. CADisplayLink
    - 刷新频率跟屏幕刷新频率相同,60FPS
    - 在主线程卡顿时,频率会降低
 2. NSTimer
 
 3. 两者在使用时,都会对target产生强引用,从而形成循环引用
 
 4. 解决方案
    - 使用继承自NSObject的代理对象,对target进行弱引用,再进行消息转发
    - 使用继承自NSProxy的代理对象,对target进行弱引用,再进行消息转发
 
 5. 方案对比
    - NSProxy会直接走消息转发的后两步
        - methodSignuterForSelector:
        - forwardingInvocation:
        - 相比NSObject效率会更高
 
 6. 注意点
    - 使用NSProxy进行消息转发后,所有的方法调用都会进行转发
        - NSLog(@"%d, %d", [proxy1 isKindOfClass:[self class]], [proxy2 isKindOfClass:[self class]]);
 
 7. GCD定时器不依赖runLoop,因此会比NSTimer和CADisplayLink准
    - 详见封装的定时器:MemoryTimerGCDTimer
 */

#pragma mark - 内存布局
/**
 低地址:
 
 程序区域(text区):存放编译后的代码
 ↓
 数据区域(data区):
    - 存放字符串常量   NSString *str= @"123"
    - 已初始化数据    已初始化的全局变量,静态变量
    - 未初始化数据    未初始化的全局变量,静态变量
    - GlobalBlock
 ↓
 堆区:
    - 存放自己alloc init的对象
    - 需要程序员自己释放
    - MallocBlock
    - 分配的时候从低地址往高地址分配
 ↓
 栈区:
    - 存放局部变量
    - 不需要自己释放,系统会自动回收
    - StackBlock
    - 分配的时候从高内存地址分配到低内存地址
 
 高地址
 
 数据段:
 字符串常量(从低到高分配)
 str    ->      0x10bd63fe8
 str1   ->      0x10bd64208
 已初始化的全局变量&静态变量(从低到高分配,且地址是连续的)
 a      ->      0x10bd718a0
 b      ->      0x10bd718a4
 未初始化全局变量&静态变量(地址从高到低分配,地址是连续的)
 c      ->      0x10bd718cc
 d      ->      0x10bd718c8
 
 堆段:
 自己初始化的变量(地址从低到高分配,地址不连续)
 obj1   ->      0x600003690190
 obj2   ->      0x6000036901c0
 
 栈段: 
 局部变量(函数内部从低到高分配,函数之间从高到低分配)
 e      ->      0x7ffee3ea6cc0
 f      ->      0x7ffee3ea6cc4
 */

#pragma mark - taggedPoint

/*
 1. 为了优化小内容的内存空间
    - 原有NSNumber类型,如果存int型,需要16+4=20个字节
    - 且包装成对象后,各种操作会非常繁琐
    - 将小的值直接隐藏在指针中
    - 判断是否是taggedPointer
        - ((uintptr_t)ptr & _OBJC_TAG_MASK) == _OBJC_TAG_MASK
        - define _OBJC_TAG_MASK (1UL<<63)
    - objc_msgSend能识别taggedPointer,会直接从指针中取值,不走消息转发
number1     ->      @2                  ->      0x8d8745d2f94d7f39      ->  taggedPoint
number2     ->      @0xfffffffffffff    ->      0x8a78ba2d06b281b1      ->  taggedPoint
number3     ->      @0xfffffffffffff1   ->      0x282cfd9e0             ->  object
str1        ->      @"abc"              ->      0x8d8745d2c8fc4eb0      ->  taggedPoint
str2        ->      @"abcdefghi"        ->      0x89c73492db9fdee0      ->  taggedPoint
str3        ->      @"abcdefghig"       ->      0x282cfc980             ->  object
date        ->      [NSDate date]       ->      0x9b1f126e6987ee65      ->  taggedPoint
 */


#pragma mark - iOS内存管理

/**
 1. 引用计数器的存储
    - 在64位中,引用计数器可以直接存在优化过的isa指针中
        - uintptr_t extra_rc          : 19
    - 获取引用计数器的流程
        - - (NSUInteger)retainCount -> _objc_rootRetainCount -> obj->rootRetainCount() -> uintptr_t rc = bits.extra_rc;
        - 如果有sideTable存储的内容,还需要加上 rc += sidetable_getExtraRC_nolock();
 
 2. dealloc释放过程
    - _objc_rootDealloc(self);
    - obj->rootDealloc();
        - 判断是否有弱指针,关联对象,C++内容,额外的引用计数器
            - if (fastpath(isa.nonpointer && !isa.weakly_referenced && !isa.has_assoc && !isa.has_cxx_dtor && !isa.has_sidetable_rc))
        - object_dispose((id)this);
        - void *objc_destructInstance(id obj)
            - void object_cxxDestruct(id obj)调用C++析构函数释放C++资源
            - void _object_remove_assocations(id object, bool deallocating) 释放关联对象
            - inline void objc_object::clearDeallocating() 释放弱指针
                - NEVER_INLINE void objc_object::clearDeallocating_slow()
                    - void weak_clear_no_lock(weak_table_t *weak_table, id referent_id)
                        - static void weak_entry_remove(weak_table_t *weak_table, weak_entry_t *entry)
                            - static void weak_compact_maybe(weak_table_t *weak_table)
                            .......
 
 3. weak指针的原理
    - struct SideTable {
        spinlock_t slock;
        RefcountMap refcnts;
        weak_table_t weak_table;
    };
 
    - struct weak_table_t {
        weak_entry_t *weak_entries;
        size_t    num_entries;
        uintptr_t mask;
        uintptr_t max_hash_displacement;
    };
 */

#pragma mark - autorelease
/**
 struct __AtAutoreleasePool {
     
     __AtAutoreleasePool() { // 构造函数
         
         atautoreleasepoolobj = objc_autoreleasePoolPush();
     }
     ~__AtAutoreleasePool() { // 析构函数
         
         objc_autoreleasePoolPop(atautoreleasepoolobj);
     }
     void * atautoreleasepoolobj;
 };
 
 {
     __AtAutoreleasePool __autoreleasepool;
     MemoryAutoreleasePerson *person = ((MemoryAutoreleasePerson *(*)(id, SEL))(void *)objc_msgSend)((id)((MemoryAutoreleasePerson *(*)(id, SEL))(void *)objc_msgSend)((id)objc_getClass("MemoryAutoreleasePerson"), sel_registerName("alloc")), sel_registerName("init"));
 }
 
 @autoreleasepool {
     
     MemoryAutoreleasePerson *person = [[MemoryAutoreleasePerson alloc] init];
 }
 演变为:
 {
    atautoreleasepoolobj = objc_autoreleasePoolPush();
    MemoryAutoreleasePerson *person = [[MemoryAutoreleasePerson alloc] init];
    objc_autoreleasePoolPop(atautoreleasepoolobj);
 }
 */

#pragma mark - autoreleasePoolPage

/**
 class AutoreleasePoolPage : private AutoreleasePoolPageData
 
 struct AutoreleasePoolPageData
 {
    magic_t const magic;                    0x1000
    __unsafe_unretained id *next;           0x1008      // 指向下一个能存放autorelease对象的地址
    pthread_t const thread;                 0x1010
    AutoreleasePoolPage * const parent;     0x1018
    AutoreleasePoolPage *child;             0x1020
    uint32_t const depth;                   0x1028
    uint32_t hiwat;                         0x1030
    begin();                        ->      0x1038
    ....
    end();                          ->      0x2000
 };
 1. 每个AutoreleasePoolPage对象占用4096个字节
    - 自己内部的7个成员变量占用56个字节,剩下的4040个字节存放在自动释放池内的对象地址
 2. 所有AutoreleasePoolPage对象通过双向链表的形式连接在一起
    - 通过child和parent指针连接起来
 3. objc_autoreleasePoolPush()
    - 在调用objc_autoreleasePoolPush()方法时,会将一个#define POOL_BOUNDARY nil压到page的栈顶
    - 然后再每一个对象调用autorelease方法时,往后进行入栈
    - 当一页满了之后,会新建一个page进行入栈
 4. objc_autoreleasePoolPop(POOL_BOUNDARY)
    - 在调用objc_autoreleasePoolPop()方法时,会从最后开始向对象发送release消息
    - 直到遇到POOL_BOUNDARY时,停止进行release
 
    @autoreleasepool {
        MemoryAutoreleasePerson *person1 = [[[MemoryAutoreleasePerson alloc] init] autorelease];
        MemoryAutoreleasePerson *person2 = [[[MemoryAutoreleasePerson alloc] init] autorelease];
        MemoryAutoreleasePerson *person3 = [[[MemoryAutoreleasePerson alloc] init] autorelease];
        @autoreleasepool {
            for (NSInteger index = 0; index < 600; index ++) {
                MemoryAutoreleasePerson *person = [[[MemoryAutoreleasePerson alloc] init] autorelease];
            }
            @autoreleasepool {
                MemoryAutoreleasePerson *person4 = [[[MemoryAutoreleasePerson alloc] init] autorelease];
                MemoryAutoreleasePerson *person5 = [[[MemoryAutoreleasePerson alloc] init] autorelease];
                _objc_autoreleasePoolPrint();
            }
        }
    }
 5. 打印autoreleasepool情况(MRC环境)
 
 objc[4306]: [0x10080e000]  ................  PAGE (full)  (cold)       // 第一个page,已经满了,且不是活跃的page
 objc[4306]: [0x10080e038]  ################  POOL 0x10080e038          // 第一层的BOUNDARY标志位
 objc[4306]: [0x10080e040]       0x100524f20  MemoryAutoreleasePerson
 objc[4306]: [0x10080e048]       0x100524660  MemoryAutoreleasePerson
 objc[4306]: [0x10080e050]       0x100524350  MemoryAutoreleasePerson
 objc[4306]: [0x10080e058]  ################  POOL 0x10080e058          // 第二层的BOUNDARY标志位
 objc[4306]: [0x10080e060]       0x100523d30  MemoryAutoreleasePerson
 ......                                                                 // 循环创建600个Person对象
 objc[4306]: [0x10080c000]  ................  PAGE  (hot)               // 第一页满了,创建一个新页
 objc[4306]: [0x10080c038]       0x100537810  MemoryAutoreleasePerson   // 继续存放Person对象
 ......
 objc[4306]: [0x10080c350]       0x100537e40  MemoryAutoreleasePerson   // 600个对象存完了
 objc[4306]: [0x10080c358]  ################  POOL 0x10080c358          // 第三层的BOUNDARY标志位
 objc[4306]: [0x10080c360]       0x100537e50  MemoryAutoreleasePerson
 objc[4306]: [0x10080c368]       0x100537e60  MemoryAutoreleasePerson
 
 6. 原码分析
    -   - (id)autorelease                               ->
        id _objc_rootAutorelease(id obj)                ->
        id objc_object::rootAutorelease()               ->
        id objc_object::rootAutorelease2()              ->
        AutoreleasePoolPage::autorelease((id)this);     ->
        static inline id *autoreleaseFast(id obj)       ->
        {
            AutoreleasePoolPage *page = hotPage();
            if (page && !page->full()) {
                // 有page且不满的话,直接添加对象
                return page->add(obj);
            } else if (page) {
                // 有page但是满了的话,新建page
                return autoreleaseFullPage(obj, page);
            } else {
                // 没有page,则新建page
                return autoreleaseNoPage(obj);
            }
        }
        
        id *add(id obj)                                 **
 
 7. autoreleasePool的释放时机
    - 如果有@autoreleasePool{}, 则在大括号结束后,调用pop方法
    - 自动释放池与RunLoop - autoReleasePool会在Runloop中添加监听
        - 监听kCFRunLoopEntry
            - 调用objc_autoreleasePoolPush()
        - 监听kCFRunLoopBeforeWaiting | kCFRunLoopBeforeExit
            - kCFRunLoopBeforeWaiting时,调用autoreleasePoolPop()和objc_autoreleasePoolPush()
            - kCFRunLoopBeforeExit时,调用autoreleasePoolPop()
        - MRC下,手动调用对象的autorelease方法,加入到autoreleasepool中
        - ARC下,通过类方法创建的对象为自动释放对象[UIImage imageName:],会加入到对应runLoop的autoReleasePool中
    - 在ARC中,编译器会在方法结束后统一调用一次release
 
*/

#endif /* MemorySummary_h */
