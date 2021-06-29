//
//  ViewController.m
//  test
//
//  Created by 张森 on 2021/1/5.
//

#import "ViewController.h"
//#import "testProtocol.h"
#import "testNSString.h"

@interface ViewController ()
+ (void)privateMethod;
@end
//extern  float a;
@implementation ViewController

//extern NSString *const string;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    // alloc申请内存空间
    // init并不会对内存空间做操作
    // 但是他们的指针地址是不同的
//    <NSObject: 0x600002a78490> - 0x600002a78490 - 0x7ffee98ea108
//    <NSObject: 0x600002a78490> - 0x600002a78490 - 0x7ffee98ea100
//    <NSObject: 0x600002a78490> - 0x600002a78490 - 0x7ffee98ea0f8
    // alloc 是怎么开辟内存的
    // 占内存是连续的
    // 指针占用8字节
    
    NSObject *object1 = [NSObject alloc];
    NSObject *object2 = [object1 init];
    NSObject *object3 = [object1 init];
    NSLog(@"%@ - %p - %p", object1, object1, &object1);
    NSLog(@"%@ - %p - %p", object2, object2, &object2);
    NSLog(@"%@ - %p - %p", object3, object3, &object3);
}

+ (void)privateMethod {
    
    NSLog(@"this is a private method");
}


@end
