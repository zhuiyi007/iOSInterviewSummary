//
//  RunLoopLifeCycleViewController.m
//  test
//
//  Created by 张森 on 2021/3/29.
//

#import "RunLoopLifeCycleViewController.h"
#import "RunLoopThread.h"

@interface RunLoopLifeCycleViewController ()

@property (nonatomic, strong) RunLoopThread *thread;
@property (nonatomic, assign) bool isStop;

@end

@implementation RunLoopLifeCycleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    // Do any additional setup after loading the view.
    
#pragma mark - 线程保活
    
    __weak typeof(self) weakSelf = self;
    
    // 1. 首先开启一个线程
    self.thread = [[RunLoopThread alloc] initWithBlock:^{
        NSLog(@"---- begin run ----");
        
        // 2. 在线程中获取currentRunLoop(runLoop不用初始化,获取时就会自动初始化)
            // 2.1 runLoop在初始化之后,需要添加port/timer/block,才能保证其运行
        [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];
        /**In other words,
         this method effectively begins an infinite loop that
         processes data from the run loop’s input sources and timers.
         [[NSRunLoop currentRunLoop] run];
         run方法无法停止RunLoop
         */
        // 3. 需要加一个开关来控制是否停止
        while (weakSelf && !weakSelf.isStop) {
            
            // 3.1 此方法只会运行一次,之后就会停止runLoop,因此需要一个循环来一直调用
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
        NSLog(@"---- end run ----");
    }];
    
    // 4. 开启线程
    [self.thread start];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    // 5. 在线程中执行操作
    [self performSelector:@selector(run) onThread:self.thread withObject:nil waitUntilDone:NO];
}

- (void)run {
    
    NSLog(@"%@, %@, %s", [NSThread currentThread], self, _cmd);
}

- (void)stopThread {
    
    NSLog(@"%@, %@, %s", [NSThread currentThread], self, _cmd);
    // 6.1 将循环退出
    self.isStop = YES;
    // 6.2 先停止当前线程
    CFRunLoopStop(CFRunLoopGetCurrent());
    // 6.3 清空线程,防止线程销毁后再次执行停止操作
    self.thread = nil;
}

- (void)dealloc {
    NSLog(@"%@, %s", self, _cmd);
    
    // 6. 在dealloc时销毁线程
    [self performSelector:@selector(stopThread) onThread:self.thread withObject:nil waitUntilDone:YES/*此处必须要写yes,写no的话,有可能会先释放某些资源*/];
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
