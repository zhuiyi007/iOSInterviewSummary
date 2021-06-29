//
//  RunTimeApplyFunctionSummary.h
//  test
//
//  Created by 张森 on 2021/3/26.
//

#ifndef RunTimeApplyFunctionSummary_h
#define RunTimeApplyFunctionSummary_h

#pragma mark - 方法交换的本质
/**
 1. method_exchangeImplementations(runMethod, testMethod);
    void method_exchangeImplementations(Method m1, Method m2)
    {
        if (!m1  ||  !m2) return;

        IMP imp1 = m1->imp(false);
        IMP imp2 = m2->imp(false);
        // 交换方法实现
        m1->setImp(imp2);
        m2->setImp(imp1);
 
        // 清除相关的缓存
        flushCaches(nil, __func__, [sel1, sel2, imp1, imp2](Class c){
            return c->cache.shouldFlush(sel1, imp1) || c->cache.shouldFlush(sel2, imp2);
        });
 2. 方法交换的应用
    - 监控全局按钮的点击事件,可以做自动埋点
    - 数组字典添加数据判空
        - NSMutableArray的真实类型是__NSArrayM
        - NSMutableString/NSMutableDictionary都是类簇,真实类型都不同__NSStringM/__NSDictionaryM
 }
 */

#endif /* RunTimeApplyFunctionSummary_h */
