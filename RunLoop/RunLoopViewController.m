//
//  RunLoopViewController.m
//  test
//
//  Created by 张森 on 2021/3/26.
//

#import "RunLoopViewController.h"
#import "RunLoopLifeCycleViewController.h"
#import "RunLoopPermenantThreadViewController.h"

@interface RunLoopViewController ()

@end

@implementation RunLoopViewController

void observerCallBlock(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {

    switch (activity) {
        case kCFRunLoopEntry:
            NSLog(@"kCFRunLoopEntry");
            break;
        case kCFRunLoopBeforeTimers:
            NSLog(@"kCFRunLoopBeforeTimers");
            break;
        case kCFRunLoopBeforeSources:
            NSLog(@"kCFRunLoopBeforeSources");
            break;
        case kCFRunLoopBeforeWaiting:
            NSLog(@"kCFRunLoopBeforeWaiting");
            break;
        case kCFRunLoopAfterWaiting:
            NSLog(@"kCFRunLoopAfterWaiting");
            break;
        case kCFRunLoopExit:
            NSLog(@"kCFRunLoopExit");
            break;
            
        default:
            break;
    }
}

void changeMode(UIView *parentView) {
#pragma mark - block监听滚动事件
    UITextView *textview = [[UITextView alloc] init];
    [textview setFrame:CGRectMake(100, 100, 100, 100)];
    [textview setText:@"asfalsdkjflasdjfoqwieorqwjrlkasdflkjasldfjlasdjkfaksdjfaksdfjlaskjdflaskjdflasfalsdkjflasdjfoqwieorqwjrlkasdflkjasldfjlasdjkfaksdjfaksdfjlaskjdflaskjdflasfalsdkjflasdjfoqwieorqwjrlkasdflkjasldfjlasdjkfaksdjfaksdfjlaskjdflaskjdflasfalsdkjflasdjfoqwieorqwjrlkasdflkjasldfjlasdjkfaksdjfaksdfjlaskjdflaskjdflasfalsdkjflasdjfoqwieorqwjrlkasdflkjasldfjlasdjkfaksdjfaksdfjlaskjdflaskjdfl"];
    [textview setBackgroundColor:[UIColor redColor]];
    [parentView addSubview:textview];
    
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        CFRunLoopMode mode = CFRunLoopCopyCurrentMode(CFRunLoopGetMain());
        switch (activity) {
            case kCFRunLoopEntry:
                NSLog(@"kCFRunLoopEntry - %@", mode);
                break;
            case kCFRunLoopExit:
                NSLog(@"kCFRunLoopExit - %@", mode);
                break;

            default:
                break;
        }
        CFRelease(mode);
    });
    CFRunLoopAddObserver(CFRunLoopGetMain(), observer, kCFRunLoopCommonModes);
    CFRelease(observer);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
#pragma mark - 普通监听
    /*
    CFRunLoopObserverRef observer = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, observerCallBlock, NULL);
    CFRunLoopAddObserver(CFRunLoopGetMain(), observer, kCFRunLoopCommonModes);
    CFRelease(observer);
     */
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
#pragma mark - 定时器监听
    /**
    CFRunLoopObserverRef observer = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, observerCallBlock, NULL);
    CFRunLoopAddObserver(CFRunLoopGetMain(), observer, kCFRunLoopCommonModes);
    CFRelease(observer);
    
    [NSTimer scheduledTimerWithTimeInterval:5.0f repeats:NO block:^(NSTimer * _Nonnull timer) {
        NSLog(@"timer-----");
    }];
     */
    
    RunLoopPermenantThreadViewController *vc = [[RunLoopPermenantThreadViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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
