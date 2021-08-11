//
//  SummaryViewController.m
//  test
//
//  Created by 张森 on 2021/4/14.
//

#import "SummaryViewController.h"
#import "SummaryPerson.h"

@interface SummaryViewController ()

@property (nonatomic, strong) UITextView *text;

@end

@implementation SummaryViewController

- (void)test {
    NSLog(@"2");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSThread *thread = [[NSThread alloc] initWithBlock:^{
        NSLog(@"1");
    }];
    // performSelector跟runloop有关,子线程默认不开启runloop
    [self performSelector:@selector(test) onThread:thread withObject:nil waitUntilDone:NO];
    
    [thread start];
    
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gesture)];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(100, 100, 100, 100)];
    [button setBackgroundColor:[UIColor blackColor]];
    [button addGestureRecognizer:recognizer];
    [button addTarget:self action:@selector(targetAction) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:button];
    
//    self.text = [[UITextView alloc] initWithFrame:CGRectMake(200, 200, 200, 40)];
//    [self.text setBackgroundColor:[UIColor redColor]];
//    [self.view addSubview:self.text];
//
//    UIButton *textButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [textButton setFrame:CGRectMake(100, 100, 100, 100)];
//    [textButton setBackgroundColor:[UIColor blackColor]];
//    [textButton addTarget:self action:@selector(targetAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:textButton];
    
//    SummaryPerson *p1 = [[SummaryPerson alloc] init];
//    p1.personId = @"1";
//    p1.name = @"111";
//
//    SummaryPerson *p2 = [[SummaryPerson alloc] init];
//    p2.personId = @"2";
//    p2.name = @"222";
//
//    SummaryPerson *p3 = [[SummaryPerson alloc] init];
//    p3.personId = @"3";
//    p3.name = @"333";
//
//    NSDictionary *dic = @{p1 : @"1", p2 : @"2", p3 : @"3"};
//    NSLog(@"%@", dic);
}

- (void)targetAction {
    
    NSLog(@"%s", __func__);
}

- (void)gesture {
    
    NSLog(@"%s", __func__);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
}


+ (NSString *)gaotuInterview:(NSString *)str {
    
    // 整体时间复杂度O(n)
    // 整体空间复杂度O(1)
    if (!str || ![str isKindOfClass:[NSString class]] || [str length] == 0) {
        
        return nil;
    }
    // 使用一个字典,空间复杂度O(1)
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    for (NSInteger index = 0; index < [str length]; index ++) {
        // 进行一次循环,时间复杂度O(n)
        // 循环中创建一个subString对象,空间复杂度O(1)
        NSString *subString = [str substringWithRange:NSMakeRange(index, 1)];
        [dict setValue:@([dict[subString] integerValue] + 1) forKey:subString];
    }
    
    for (NSInteger index = 0; index < [str length]; index ++) {
        // 进行一次循环,时间复杂度O(n)
        // 循环中创建一个subString对象,空间复杂度O(1)
        NSString *subString = [str substringWithRange:NSMakeRange(index, 1)];
        if ([dict[subString] integerValue] == 1) {
            
            return subString;
        }
    }
    return nil;
}

@end
