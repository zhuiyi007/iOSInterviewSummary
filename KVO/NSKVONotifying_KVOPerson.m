//
//  NSKVONotifying_KVOPerson.m
//  test
//
//  Created by 张森 on 2021/3/16.
//

#import "NSKVONotifying_KVOPerson.h"

@implementation NSKVONotifying_KVOPerson

- (void)setAge:(double)age {
    
    [self willChangeValueForKey:@"age"];

    [super setAge:age];

    [self didChangeValueForKey:@"age"];
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
