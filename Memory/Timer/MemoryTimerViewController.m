//
//  MemoryTimerViewController.m
//  test
//
//  Created by 张森 on 2021/4/1.
//

#import "MemoryTimerViewController.h"
#import "MemoryTimerNSObjectProxy.h"
#import "MemoryTimerNSProxyProxy.h"
#import "MemoryTimerGCDTimer.h"

@interface MemoryTimerViewController ()
@property (nonatomic, strong) CADisplayLink *linkTimer;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation MemoryTimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    
    [MemoryTimerGCDTimer excuTask:^{
        NSLog(@"1111, %@", [NSThread currentThread]);
    } begin:0 interval:1.0 repeats:YES async:YES];
    return;
    
    self.linkTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(timerTest)];
    [self.linkTimer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    MemoryTimerNSObjectProxy *proxy1 = [MemoryTimerNSObjectProxy createWithTarget:self];
    MemoryTimerNSProxyProxy *proxy2 = [MemoryTimerNSProxyProxy createWithTarget:self];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:proxy1 selector:@selector(timerTest) userInfo:nil repeats:YES];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:proxy2 selector:@selector(timerTest) userInfo:nil repeats:YES];
    
    // 0, 1
    NSLog(@"%d, %d", [proxy1 isKindOfClass:[self class]], [proxy2 isKindOfClass:[self class]]);
}

- (void)timerTest {
 
    NSLog(@"%s", __func__);
}

- (void)dealloc {
    
    NSLog(@"%s", __func__);
    [self.linkTimer invalidate];
    [self.timer invalidate];
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
