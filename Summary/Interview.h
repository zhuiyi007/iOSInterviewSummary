//
//  Interview.h
//  test
//
//  Created by 张森 on 2021/4/7.
//

#ifndef Interview_h
#define Interview_h
#pragma mark - OC对象
/**
1. 面向对象
    - OC的类信息存放在哪里？
        - 实例对象的成员变量的值存放在实例对象中
        - 实例对象的信息存放在类对象中
            - 类对象中存放实例对象的成员变量,方法,协议
        - 类对象的信息存放在元类对象中
            - 元类对象中存放类对象的成员变量,方法,协议
 
    - 对象的isa指针指向哪里？superClass指向哪里
        - 实例对象的isa指针指向类对象
        - 类对象的isa指针指向元类对象
        - 元类对象的isa指向NSObject元类对象
        - 实例对象/类对象/元类对象的superClass指针指向父类
            - NSObject的元类对象的superClass指针指向NSObject的类对象
 
    - 一个NSObject对象占用多少内存？
        - 一个NSObject对象中只有一个isa指针,占用8字节(class_getInstanceSize)
        - 但是在arm64架构下,内存会进行16字节对齐,因此一个NSObject对象占用16字节(malloc_size)
        - class_getInstanceSize返回的是结构体内存对齐后的占用字节数,对齐规则为结构体中最大内存结构的字节倍数
        - malloc_size返回的是iOS系统对齐后的占用字节数,对齐规则为16的倍数
        - 例如:
            struct Student_IMPL {
                Class isa;      // 8字节
                int _no;        // 4字节
                int _age;       // 4字节
                int _height;    // 4字节
            }
            未对齐时,占用字节为20字节
            class_getInstanceSize方法会进行8字节对齐,最终返回24字节
            malloc_size方法会进行16字节对齐,最终返回32字节
 
2. KVO
    - iOS用什么方式实现对一个对象的KVO？(KVO的本质是什么？)
        - KVO的本质是会生成一个新的对象作为监听对象的子类(NSKVONotifying_XXX)
            - 为了不暴露新生成的类,系统会重写class方法,返回父类
                - 通过object_getClass方法可以获得
            - 子类中实现了setAge, dealloc, class, _isKVOA方法
            - 因此,如果手动创建了NSKVONotifying_XXX类,KVO将失效
        - 重写对象的setter方法,setter方法调用_NSSetXXXValueAndNotify
            - _NSSetXXXValueAndNotify方法内部会调用super的setter,并在前后增加willChangeValueForKey和didChangeValueForKey
            - didChangeValueForKey内部会默认触发监听器
 
    - 如何手动触发KVO？
        - 修改成员变量的值
        - 手动触发[XXX willChangeValueForKey:@"XXX"] 和 [XXX didChangeValueForKey:@"XXX"]
        - 两个方法必须都调用,did中会判断是否调用过will
 
    - 直接修改成员变量会触发KVO么？
        - 不会
 
3. KVC
    - 通过KVC修改属性会触发KVO么？
        - 通过KVC修改属性,相当于调用属性的setter,会触发KVO的过程
        - 通过KVC修改成员变量,会在setValueForKey内部调用willChangeValueForKey:和didChangeValueForKey:
            - 通过打符号断点得知
 
    - KVC的赋值和取值过程是怎样的？原理是什么？
        - 赋值:
            - 会先调用setAge:/_setAge
            - 如果都没有实现,则会调用+ (BOOL)accessInstanceVariablesDirecty方法判断是否允许访问成员变量
                - 该方法默认返回YES
            - 依次访问_age/_isAge/age/isAge
        - 取值
            - 先调用getAge/age/isAge/_age方法
            - 如果都没有,则调用+(BOOL)accessInstanceVariablesDirecty方法
            - 依次访问_age/_isAge/age/isAge
 
4. Category
    - Category的使用场合是什么
        - 用来给系统的类增加一些方法
 
    - Category的实现原理
        - category结构中有保存类方法,对象方法,协议和属性
        - 在runtime阶段,对原有类和category的信息进行合并
        - attachLists方法
            - 会把category的方法放到方法列表的前面,原有类的方法会放到后面
            - 后参与编译的方法会放到最前面
        - 在查找方法时就会先查找到分类中的方法
 
    - Category和Class Extension的区别是什么？
        - class extension是在编译时就把内容合并到原有类中
            - 可以理解为class extension就是原有类的内容
        - category是在运行时进行的合并
 
    - Category中有load方法吗？load方法是什么时候调用的？load 方法能继承吗？
        - load方法与普通的方法调用不同,load方法不是通过msg_send的方式调用的
        - 因此所有类/分类的load方法都会调用
        - 会先调用类的load方法,在调用分类的load方法
        - 在调用子类的load方法前,会先调用父类的load方法
            - 会先把所有的类和分类的load方法整理到两个数组中
            - 在按照顺序分别调用
        - 同级别的load方法调用关系与编译先后顺序有关
 
    - load、initialize方法的区别什么？它们在category中的调用的顺序？以及出现继承时他们之间的调用过程？
        - load方法每个类/分类只会调用一次(直接调用的方式)
            - 每个类/分类都会分别调用
        - initialize方法是在第一次向某个类发送消息时进行调用(msg_send的方式)
            - 在发送消息时会先判断当前类是否调用过initialize方法
            - 会按照方法顺序进行查找调用
            - 先调用父类的initialize,再调用子类的
 
    - Category能否添加成员变量？如果可以，如何给Category添加成员变量？
        - 不可以添加成员变量,成员变量在class_ro_t结构体中,是在编译时就决定的,无法添加
        - 可以运用关联对象的方法看起来像添加了成员变量一样
        - 核心数据结构:
            - AssociationsManager :
                AssociationsHashMap : {
                    object : ObjcAssociationMap : {
                        key : ObjcAssociation : {
                            policy, value
                        }
                    }
                }
            - AssociationsHashMap是全局唯一的,存放所有对象的关联对象
        - 如果设置关联对象value为空,则会清除此关联对象
            - associations.erase(refs_it);
 
5. block
    - block的原理是怎样的？本质是什么？
        - 封装了函数调用及其调用环境的OC对象
 
    - __block的作用是什么？有什么使用注意点？
        - __block的作用是可以在block内部修改外部的auto变量
        - __block在ARC下会对对象进行强引用,注意使用时的内存管理情况
 
    - block的属性修饰词为什么是copy？使用block有哪些使用注意？
        - 在ARC时代,block在赋值给auto变量后会自动执行copy操作,因此用strong和copy效果一样
        - 在MRC时代,block对象不会自动执行copy操作,因此,需要手动从栈区copy到堆区
 
    - block在修改NSMutableArray，需不需要添加__block？
        - 不需要,修改array只是在使用array,并没有改变array
 */
#pragma mark - RunTime
/**
 1. 讲一下 OC 的消息机制
    - OC消息机制分为三步
        - 消息发送
            - 先判断消息调用者是否为空,为空则直接返回
            - 去消息调用者的缓存中查找方法
            - 通过调用者的isa指针,找到对应的类对象/元类对象,查找方法
            - 调用superClass,去父类中查找方法,直到NSObject
            - 过程中查找到方法的话,会存到缓存列表中
            - 查找不到,进入动态方法解析
        - 动态方法解析
            - 若第一步没有找到方法的话,进入到第二步,进行动态方法解析
            - 首先判断是否进行过动态方法解析
            - 调用resolveInstanceMethod/resolveClassMethod方法
            - 在方法中动态添加方法
                - class_addMethod(self, 调用的sel, 添加的IMP, types(v16@0:8))
            - 标记已经进行过方法解析, 同时加入缓存列表中
            - 重走消息发送流程
        - 消息转发
            - 若动态方法解析没有返回结果, 进入消息转发阶段
            - -/+ (id)forwardingTargetForSelector:(SEL)selector;
                - 返回执行方法的target
                - 返回值不为空,则调用objc_msgSend(target, selector)
                - 返回值为空,往下走
            - -/+ (MethorSignature *)methodSignatureForSelector:(SEL)selector;
                - 返回该方法的方法签名
                - 返回值不为空,生成对应的NSInvocation,往下走
                - 返回值为空,调用doesNotRecognizedSelector;
            - -/+ (BOOL)forwardingInvocation:(NSInvocation *)invocation;
                - 在此方法中,可以做任何事情
            
 2. 消息转发机制流程
 3. 什么是Runtime？平时项目中有用过么？
    - runtime为运行时, OC是一门动态性非常强的语言,可以允许我们的一些操作在运行时才进行
    - 可以动态的添加类,为类添加方法等
    - 平时用的话会做一些方法交换,给分类添加属性,扫描一些系统类的属性,方法来进行一些操作(比如placeholder修改颜色),但是比较危险,可能升级后就不支持了
 4. 打印结果分别是什么？
 @interface Student : Person
 @end
 @implementation Student
 - (instancetype)init
 {
     self = [super init];
     if (self) {
         NSLog(@"%@", [self class]);        // Student
         NSLog(@"%@", [self superclass]);   // Person
         
         NSLog(@"%@", [super class]);       // Student
         NSLog(@"%@", [super superclass]);  // Person
                                            // super关键词是指默认从superClass的方法列表开始查找方法
                                            // class和superClass的实现都是在NSObject中
                                            // 因此,实际调用者还是self
     }
     return self;
 }
 @end
 
 @interface Person : NSObject
 @end
 @implementation Person
 - (instancetype)init
 {
     self = [super init];
     if (self) {
        NSLog(@"%@", [[NSObject class] isKindOfClass:[NSObject class]]);    // 1
        NSLog(@"%@", [[NSObject class] isMemberOfClass:[NSObject class]]);  // 0
        NSLog(@"%@", [[Person class] isKindOfClass:[Person class]]);        // 0
        NSLog(@"%@", [[Person class] isMemberOfClass:[Person class]]);      // 0
        // isMemberOfClass:
            - 实例方法: [self class] == cls
            - 类方法:  self -> ISA() == cls
        // isKindOfClass:
            - 实例方法: 循环遍历superClass: [self class] == cls
            - 类方法:   循环遍历superClass: self -> ISA() == cls
     }
     return self;
 }
 @end
 
 
 5. 以下代码能不能执行成功？如果可以，打印结果是什么？
 @interface RunTimeSuperPerson : NSObject
 @property (nonatomic, copy) NSString *age;
 @end
 @implementation RunTimeSuperPerson
 - (void)run {
     
     NSLog(@"%@, %s, %@", self, _cmd, self.age);
 }
 @end
 
 @implementation RunTimeSuperViewController

 - (void)viewDidLoad {
 
     [super viewDidLoad];
     id cls = [RunTimeSuperPerson class];
     void * obj = &cls;
     [(__bridge id)obj run];
 }
 @end
 */
#pragma mark - RunLoop
/**
 1. 讲讲 RunLoop，项目中有用到吗？
    - 定时器
    - 线程保活
 
 2. runloop内部实现逻辑？
    - 通知observer runloop即将进入    -   kCFRunLoopEntry
    - 通知observer即将处理Timer       -   kCFRunLoopBeforeTimers
    - 通知observer即将处理source      -   kCFRunLoopBeforeSources
    - 处理block
    - 处理source0
        - 根据返回结果判断是否需要再处理一遍block
    - 判断是否有source1,有的话跳转到handle_msg
    - 通知observer即将进入休眠          - kCFRunLoopBeforeWaiting
    - 进入循环休眠状态,等待唤醒
    - 程序被唤醒,通知observer          - kCFRunLoopAfterWaiting
    - handle_msg:
        - 处理Timer
        - 处理GCD
        - 处理source1
    - 处理block
    - 根据返回值决定是退出runloop还是继续循环
 
 3. runloop和线程的关系？
    - runLoop与线程是一一对应的
        - runLoop是存在全局的dict中,以tread为key,runLoop为value
    - 主线程默认开启runLoop
    - 子线程需要获取runloop之后才会默认开启
    - runloop会在线程结束时销毁
 
 4. timer 与 runloop 的关系？
    - timer的实现与runloop相关
    - runLoop中负责调度timer的调用
 
 5. 程序中添加每3秒响应一次的NSTimer，当拖动tableview时timer可能无法响应要怎么解决？
    - 修改timer添加到runloop中的mode,改为NSRunLoopCommonModes
 
 6. runloop 是怎么响应用户操作的， 具体流程是什么样的？
 7. 说说runLoop的几种状态
    - NSRunLoopEntry
    - NSRunLoopBeforeTimer
    - NSRunLoopBeforeSource
    - NSRunLoopBeforeWaiting
    - NSRunLoopAfterWaiting
    - NSRunLoopExit
    - NSRunLoopAllActivities
 
 8. runloop的mode作用是什么
    - 区分不同场景下,runLoop需要做的事情
    - runLoop有两种常用的mode
        - NSRunLoopDefaultMode
            - 普通场景下的mode
        - NSRunLoopTrackingMode
            - 滑动时的mode
    - runLoop在切换mode时,需要先退出上一个mode的runloop,再进入当前的mode的runloop
 */
#pragma mark - 多线程
/**
 1. 你理解的多线程
    - 可以在同一时间内,并发执行多个任务,优化执行效率,避免主线程卡顿
 
 2. iOS的多线程方案有哪几种,你更倾向于哪一种
    - pthread
        - 通用的多线程方案,底层用C语言写的,平时几乎不用
        - 开发难度大
        - 程序员管理内存
    - NSThread
        - 使用上更加面向对象
        - 简单易用,可以直接操作线程对象
        - 偶尔使用
        - 程序员自己管理内存
    - GCD
        - 代替NSThread
        - 可以更好的利用多核
        - 自动管理内存
    - NSOperation
        - 基于GCD
        - 封装了一些简单的功能
        - 更加面向对象
 
 3. 你在项目中用过 GCD 吗
 4. GCD 的队列类型
    - 串行队列
        - DISPATCH_QUEUE_SERIAL
    - 并发队列
        - DISPATCH_QUEUE_CONCURRENT
 5. 说一下 OperationQueue 和 GCD 的区别，以及各自的优势
 6. 线程安全的处理手段有哪些
    - OSSpainLock
        - 自旋锁,iOS10之后已废弃
    - os_unfair_lock
    - pthread_mutex_t
    - NSLock
    - NSCondition
    - NSConditionLock
    - semaphore
    - synchnorized
 7. OC你了解的锁有哪些,在你回答基础上进行二次提问；
 */


#endif /* Interview_h */
