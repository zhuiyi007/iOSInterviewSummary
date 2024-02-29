//
//  KVOViewController.m
//  test
//
//  Created by 张森 on 2021/3/16.
//

#import "KVOViewController.h"
#import "KVOPerson.h"
#import <objc/runtime.h>
@interface KVOViewController ()

@property (nonatomic, strong) KVOPerson *person1;
@property (nonatomic, strong) KVOPerson *person2;

@end

@implementation KVOViewController

- (void)printMethodOfClass:(Class)cls {
    
    unsigned int count;
    Method *methodList = class_copyMethodList(cls, &count);
    
    NSMutableString *methodNames = [NSMutableString string];
    for (NSInteger index = 0; index < count; index ++) {
        Method method = methodList[index];
        NSString *methodName = NSStringFromSelector(method_getName(method));
        [methodNames appendFormat:@"%@, ", methodName];
    }
    free(methodList);
    NSLog(@"%@ - %@", cls, methodNames);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.person1 = [[KVOPerson alloc] init];
    self.person1.age = 11;
    [self.person1 addObserver:self forKeyPath:@"age" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    self.person2 = [[KVOPerson alloc] init];
    self.person2.age = 22;
    
    // 类对象 - NSKVONotifying_KVOPerson - 0x6000020401b0 - KVOPerson - 0x10cbd7258
    NSLog(@"类对象 - %@ - %p - %@ - %p",
          object_getClass(self.person1),
          object_getClass(self.person1),
          object_getClass(self.person2),
          object_getClass(self.person2));
    
    // 类对象 - KVOPerson - 0x10cbd7258 - KVOPerson - 0x10cbd7258
    // 系统不希望对外暴露NSKVONotifying_KVOPerson这个类
    NSLog(@"类对象 - %@ - %p - %@ - %p",
          [self.person1 class],
          [self.person1 class],
          [self.person2 class],
          [self.person2 class]);
    
    NSLog(@"元类对象 - %@ - %p - %@ - %p",
          object_getClass(object_getClass(self.person1)),
          object_getClass(object_getClass(self.person1)),
          object_getClass(object_getClass(self.person2)),
          object_getClass(object_getClass(self.person2)));
    
    NSLog(@"类对象 - %@ - %p - %@ - %p",
          [self.person1 class],
          [self.person1 class],
          [self.person2 class],
          [self.person2 class]);
    
//    p (IMP)0x7fff207bc2b7
//    (IMP) $1 = 0x00007fff207bc2b7 (Foundation`_NSSetIntValueAndNotify)
//    (IMP) $0 = 0x00007fff207bc039 (Foundation`_NSSetDoubleValueAndNotify)
//    po [self.person1 methodForSelector:@selector(setAge:)] (Foundation`_NSSetDoubleValueAndNotify)
    NSLog(@"%p", [self.person1 methodForSelector:@selector(setAge:)]);
    
//    NSKVONotifying_KVOPerson - setAge:, class, dealloc, _isKVOA,
    [self printMethodOfClass:object_getClass(self.person1)];
//    KVOPerson - setAge:, age,
    [self printMethodOfClass:object_getClass(self.person2)];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    // (Class) $0 = 0x000060000292c2d0 NSKVONotifying_KVOPerson
    self.person1.age = 111;
    
    // (__unsafe_unretained Class) $1 = 0x0000000100a5b1e8 KVOPerson
//    self.person2.age = 222;
    
    
    // 手动触发KVO的监听
    // 必须两个方法同时调用,did内部会判断是否调用过will
//    [self.person1 willChangeValueForKey:@"age"];
//    [self.person1 didChangeValueForKey:@"age"];
    
    // 修改成员变量不会触发KVO
    self.person1->_age = 2;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    NSLog(@"%@ - 对象的 - %@ - 属性发生了变化 - %@", object, keyPath, change);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
