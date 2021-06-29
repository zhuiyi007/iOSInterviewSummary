//
//  ThreadViewController.m
//  test
//
//  Created by 张森 on 2021/3/29.
//

#import "ThreadViewController.h"

@interface ThreadViewController ()

@end

@implementation ThreadViewController

- (void)interview01 {
    
    // 以下代码在主队列执行
    // 是否会发生死锁?
    
    // 会发生死锁
    // 同步执行时,viewDidLoad方法和任务2在互相等待
    
    /**
    NSLog(@"执行任务1");
    dispatch_sync(dispatch_get_main_queue(), ^{
        
        NSLog(@"执行任务2");
    });
    
    NSLog(@"执行任务3");
     */
    
    
    // 不会发生死锁
    // 异步执行
    // 会先等之前的任务执行完毕
    // 再执行下一个任务
    // 输出结果:执行任务1 -> 执行任务3 -> 执行任务2
    
    /*
    NSLog(@"执行任务1");
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSLog(@"执行任务2");
    });
    
    NSLog(@"执行任务3");
    */
    
    
    // 会发生死锁
    // 打印结果:执行任务1 -> 执行任务5 -> 执行任务2
    // block0是异步的,因此,在打印完1,5之后执行,且在子线程
    // block1是同步的,会跟block0之间发生死锁
    /**
    NSLog(@"执行任务1");
    dispatch_queue_t queue = dispatch_queue_create("myQueue", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{ // block0
        
        NSLog(@"执行任务2");
        dispatch_sync(queue, ^{ // block1
            
            NSLog(@"执行任务3");
        });
        
        NSLog(@"执行任务4");
    });
    NSLog(@"执行任务5");
    */
    
    
    // 不会死锁
    // 打印顺序:执行任务1 -> 执行任务5 -> 执行任务2 -> 执行任务3 -> 执行任务4
    // block0和block1在两个不同的队列中
    // 当执行完任务2时,会去queue2中获取任务三,并同步执行
    // 执行完毕后再执行任务4
    /**
    NSLog(@"执行任务1");
    dispatch_queue_t queue = dispatch_queue_create("myQueue", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue2 = dispatch_queue_create("myQueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{ // block0
        
        NSLog(@"执行任务2 - %@", [NSThread currentThread]);
        dispatch_sync(queue2, ^{ // block1
            
            NSLog(@"执行任务3 - %@", [NSThread currentThread]);
        });
        
        NSLog(@"执行任务4 - %@", [NSThread currentThread]);
    });
    NSLog(@"执行任务5");
     */
    
    
    // 打印结果: 1 -> 3
    // performSelector: withObject: afterDelay: 底层使用的是定时器,会添加到runLoop中
    // 在子线程中,默认不会添加runLoop
    // 因此,2不会打印
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
       
        NSLog(@"1");
        [self performSelector:@selector(test) withObject:nil afterDelay:0];
        NSLog(@"3");
    });
}

- (void)test {
    NSLog(@"2");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self interview01];
    
//    dispatch_queue_t queue1 = dispatch_get_global_queue(0, 0);
//    dispatch_queue_t queue2 = dispatch_get_global_queue(0, 0);
//
//    dispatch_queue_t queue3 = dispatch_queue_create("111", DISPATCH_QUEUE_SERIAL);
//    dispatch_queue_t queue4 = dispatch_queue_create("111", DISPATCH_QUEUE_SERIAL);
//    dispatch_queue_t queue5 = dispatch_queue_create("111", DISPATCH_QUEUE_CONCURRENT);
//    dispatch_queue_t queue6 = dispatch_queue_create("111", DISPATCH_QUEUE_CONCURRENT);
//
//    NSLog(@"%p - %p - %p - %p - %p - %p", queue1, queue2, queue3, queue4, queue5, queue6);
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    NSThread *thread = [[NSThread alloc] initWithBlock:^{
        NSLog(@"1");
    }];
    [thread start];
    [self performSelector:@selector(test) onThread:thread withObject:nil waitUntilDone:YES];
}

@end
