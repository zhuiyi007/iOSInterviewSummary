//
//  NSKVONotifying_KVOPerson.m
//  test
//
//  Created by 张森 on 2021/3/16.
//

#import "NSKVONotifying_KVOPerson.h"

@implementation NSKVONotifying_KVOPerson

- (void)setAge:(double)age {
    /// 添加过监听属性的伪代码实现
    _NSSetIntValueAndNotify();
}

_NSSetIntValueAndNotify() {
    /// 添加过监听属性的伪代码实现
    [self willChangeValueForKey:@"age"];

    [super setAge:age];

    [self didChangeValueForKey:@"age"];
}

- (void)didChangeValueForKey:(NSString *)value {
    /// didChangeValueForKey的伪代码实现
    [self observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context];
}

- (void)dealloc {
    
    // 收尾方法
}

- (Class)class {
    
    return [KVOPerson class];
}

- (BOOL)_isKVOA {
    
    return YES;
}

@end
