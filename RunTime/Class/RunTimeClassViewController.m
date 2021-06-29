//
//  RunTimeClassViewController.m
//  test
//
//  Created by 张森 on 2021/3/23.
//

#import "RunTimeClassViewController.h"
#import "RunTimeClassPerson.h"
#import "RunTimeObjcMsgSendPerson.h"
@interface RunTimeClassViewController ()

@end

@implementation RunTimeClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    RunTimeClassPerson *person = [[RunTimeClassPerson alloc] init];
    
//    NSLog(@"%@", person);
    
    RunTimeObjcMsgSendPerson *person = [[RunTimeObjcMsgSendPerson alloc] init];
    [person testInstanceMethod];
    [RunTimeObjcMsgSendPerson testClassMethod];
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
