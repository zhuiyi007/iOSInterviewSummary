//
//  RunTimeApplyFunctionViewController.m
//  test
//
//  Created by 张森 on 2021/3/25.
//

#import "RunTimeApplyFunctionViewController.h"
#import "RunTimeApplyFunctionPerson.h"
#import "RunTimeApplyFunctionCat.h"
#import <objc/runtime.h>

@interface RunTimeApplyFunctionViewController ()

@end
#pragma mark - 方法交换
void exchangeFunc() {
    
    RunTimeApplyFunctionPerson *person = [[RunTimeApplyFunctionPerson alloc] init];
    
    Method runMethod = class_getInstanceMethod([person class], @selector(run));
    Method testMethod = class_getInstanceMethod([person class], @selector(test));
    method_exchangeImplementations(runMethod, testMethod);
    [person run];
}

#pragma mark - 方法交换应用
void exchangeFuncApply() {
    // ⚠️交换时一定要注意真实的类
    NSObject *obj = nil;
    NSMutableArray *arr = [NSMutableArray array];
    [arr addObject:@"jack"];
    // 添加空对象,会造成崩溃,hock掉insert方法可以防止崩溃
    [arr addObject:obj];
    NSLog(@"%@", arr);
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    dic[@"name"] = @"jack";
    // key为空,会造成崩溃,hock掉setObject:forKeyedSubscript:方法可以防止崩溃
    dic[obj] = @"123";
    NSLog(@"%@", dic);
}

@implementation RunTimeApplyFunctionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    exchangeFuncApply();
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
