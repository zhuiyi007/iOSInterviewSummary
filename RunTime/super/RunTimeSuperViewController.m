//
//  RunTimeSuperViewController.m
//  test
//
//  Created by 张森 on 2021/3/24.
//

#import "RunTimeSuperViewController.h"
#import "RunTimeSuperStudent.h"
#import "RunTimeSuperPerson.h"
@interface RunTimeSuperViewController ()

@end

@implementation RunTimeSuperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    id cls = [RunTimeSuperPerson class];
    
    void * obj = &cls;
//    <RunTimeSuperPerson: 0x7ffee13b80d8>, run, <RunTimeSuperViewController: 0x7f7f79009260>
    /**
     1. 方法是否可以调用
        - 对象的结构为isa指针和成员变量
        - isa指针指向对象的类对象
        - cls也指向对象的类对象
        - 因此,cls即RunTimeSuperPerson的isa
        - 在执行[obj run]时,即从obj的isa中寻找方法列表进行调用
        - 因此,可以成功调用RunTimeSuperPerson的run方法
     2. 为什么打印self.age是RunTimeSuperViewController?
        - 局部变量存放在栈空间
        - 栈空间是从高地址往低地址存
        - 在ViewDidLoad方法中,最先声明的局部变量是self
            - [super viewDidLoad]中,第一个参数是objc_super结构体
            - 结构体中第一个变量是receiver,即self
            - 因此,在此方法中,最高地址存放的就是self
        - 随后,存放的是cls,即RunTimeSuperPerson的isa
        - 在run方法中,寻找_age成员变量时,即从类结构体中往后跳过8个字节寻找
        - 刚好寻找到了self
        - 即打印RunTimeSuperViewController
     */
    [(__bridge id)obj run];
    
    
//    [[RunTimeSuperStudent alloc] init];
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
