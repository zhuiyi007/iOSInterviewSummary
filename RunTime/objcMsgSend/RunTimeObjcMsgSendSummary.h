//
//  RunTimeObjcMsgSendSummary.h
//  test
//
//  Created by 张森 on 2021/3/23.
//

#ifndef RunTimeObjcMsgSendSummary_h
#define RunTimeObjcMsgSendSummary_h

#param mark - objc_msgSend流程

/**
 1. 消息发送
    - 先判断receiver是否为空,为空直接return
    - 由isa指针查找到对应的类/元类 -> 父类查找相应的缓存方法去调用
    - 缓存中找不到,去class_rw_t中查找方法
    - 一旦查找到方法,则调用方法,并缓存到receiver的cache中
    - 查找不到方法,则执行动态方法解析
 2. 动态方法解析
    - 判断是否曾经动态解析过,如果动态解析过,直接进行消息转发,否则往下走
    - 会调用resolveInstanceMethod/resolveClassMethod 动态添加方法
    - 标记为已经动态解析过
    - 重新走消息发送机制
 3. 消息转发
    - 调用forwardingTargetForSelector:返回执行消息的对象
        - 返回值不为空,执行objc_msg_Send(返回值, SEL)
        - 返回值为空,往下走
    - 调用methodSignatureForSelector:获取消息签名
        - 返回值不为空,调用forwardInvocation:方法,拿到NSInvocation后可以做任何事
        - 返回值为空,调用doesNotRecognizeSelector:方法
    - 此步骤中的所有方法均有对象方法和类方法两个版本
    
 */

#param mark - objc_msgSend实现

/**
 1. ENTRY _objc_msgSend
    - objc_msgSend的入口
 2. 在arm64系统下会执行 LNilOrTagged
 
 3. LGetIsaDone
    - 会执行找到的IMP,或者未命中缓存
 
 4. CacheLookup NORMAL, _objc_msgSend, __objc_msgSend_uncached
    - 命中缓存,执行CacheHit -> TailCallCachedImp
    - 未命中缓存,执行__objc_msgSend_uncached -> MethodTableLookup -> lookUpImpOrForward
 
 5. lookUpImpOrForward
    - 会先判断当前类有无初始化,若没有,先走初始化逻辑
    - 会先找一遍当前类的缓存,若有,则直接跳done_unlock,返回imp
    - 当前类缓存找不到
        static method_t * getMethodNoSuper_nolock(Class cls, SEL sel)
        ALWAYS_INLINE static method_t * search_method_list_inline(const method_list_t *mlist, SEL sel)
        - 寻找方法列表
        ALWAYS_INLINE static method_t * findMethodInSortedMethodList(SEL key, const method_list_t *list)
        - 如果是有序的,则调用有序方法列表(二分查找)
        ALWAYS_INLINE static method_t * findMethodInUnsortedMethodList(SEL key, const method_list_t *list)
        - 如果是无序的,则调用无序方法列表(顺序查找)
    - curClass = curClass->getSuperclass(), 准备查找父类
    - 先查找父类的cache
    - 循环上述步骤
 
 6. 如果父类都没有找到方法,则进入动态方法解析
    - static NEVER_INLINE IMP resolveMethod_locked(id inst, SEL sel, Class cls, int behavior)
        - static void resolveInstanceMethod(id inst, SEL sel, Class cls)
            - 处理对象方法
            - 会调用当前对象的 + (BOOL)resolveInstanceMethod;方法
        - static void resolveClassMethod(id inst, SEL sel, Class cls)
            - 处理类方法
            - 会调用当前类的 + (BOOL)resolveClassMethod;方法
    - 详情见RunTimeObjcMsgSendPerson类
    - [RunTimeObjcMsgSendPerson testInstanceMethod]: unrecognized selector sent to instance 0x6000032b4000
    - 动态添加方法会增加到cache中
        flushCaches(cls, __func__, [](Class c){
            return !c->cache.isConstantOptimizedCache();
        });
    - 动态添加完成后,调用
        static IMP _lookUpImpTryCache(id inst, SEL sel, Class cls, int behavior)
        - 重新走一遍消息发送流程
 */
    ENTRY _objc_msgSend
    UNWIND _objc_msgSend, NoFrame
    // 寄存器,存放消息接收者 receiver
    cmp    p0, #0            // nil check and tagged pointer check
#if SUPPORT_TAGGED_POINTERS
    b.le    LNilOrTagged        //  (MSB tagged pointer looks negative)
#else
    b.eq    LReturnZero
#endif
    ldr    p13, [x0]        // p13 = isa
    GetClassFromIsa_p16 p13, 1, x0    // p16 = class
LGetIsaDone:
    // calls imp or objc_msgSend_uncached
    CacheLookup NORMAL, _objc_msgSend, __objc_msgSend_uncached

#if SUPPORT_TAGGED_POINTERS
LNilOrTagged:
    b.eq    LReturnZero        // nil check
    GetTaggedClass
    b    LGetIsaDone
    // SUPPORT_TAGGED_POINTERS
#endif

LReturnZero:
    // x0 is already zero
    mov    x1, #0
    movi    d0, #0
    movi    d1, #0
    movi    d2, #0
    movi    d3, #0
    ret

END_ENTRY _objc_msgSend

#endif /* RunTimeObjcMsgSendSummary_h */
