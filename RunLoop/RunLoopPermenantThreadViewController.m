//
//  RunLoopPermenantThreadViewController.m
//  test
//
//  Created by 张森 on 2021/3/29.
//

#import "RunLoopPermenantThreadViewController.h"
#import "RunLoopPermenantThread.h"

@interface RunLoopPermenantThreadViewController ()
@property (strong, nonatomic) RunLoopPermenantThread *thread;
@end

@implementation RunLoopPermenantThreadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.thread = [[RunLoopPermenantThread alloc] init];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:[UIColor blackColor]];
    [button addTarget:self.thread action:@selector(stop) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(100, 100, 100, 100)];
    [self.view addSubview:button];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.thread excuteTask:^{
       
        NSLog(@"excute - %@", [NSThread currentThread]);
    }];
}

- (void)dealloc {
    NSLog(@"%@, %s", self, _cmd);
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
