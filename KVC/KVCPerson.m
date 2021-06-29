//
//  KVCPerson.m
//  test
//
//  Created by 张森 on 2021/3/16.
//

#import "KVCPerson.h"

@implementation KVCCat

@end

@implementation KVCPerson

//// KVC先找setAge:方法
//- (void)setAge:(double)age {
//
//    NSLog(@"setAge:%f", age);
////    _age = age;
//}
//
//// KVC再找_setAge:方法
//- (void)_setAge:(double)age {
//
//    NSLog(@"_setAge:%f", age);
////    _age = age;
//}

//// 上述方法都没实现,会访问这个方法看是否允许查找成员变量赋值
//+ (BOOL)accessInstanceVariablesDirectly {
////    return NO;
//    return YES;
//}


//- (int)getAge {
//    return 11;
//}
//
//- (int)age {
//    return 12;
//}
//
//- (int)isAge {
//    return 13;
//}
//
//- (int)_age {
//    return 14;
//}

@end
