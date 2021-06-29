//
//  SummaryViewController.m
//  test
//
//  Created by 张森 on 2021/4/14.
//

#import "SummaryViewController.h"

@interface SummaryViewController ()

@property (nonatomic, strong) UITextView *text;

@end

@implementation SummaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gesture)];
//
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button setFrame:CGRectMake(100, 100, 100, 100)];
//    [button setBackgroundColor:[UIColor blackColor]];
//    [button addGestureRecognizer:recognizer];
//    [button addTarget:self action:@selector(targetAction) forControlEvents:UIControlEventTouchUpInside];
//
//    [self.view addSubview:button];
    
//    self.text = [[UITextView alloc] initWithFrame:CGRectMake(200, 200, 200, 40)];
//    [self.text setBackgroundColor:[UIColor redColor]];
//    [self.view addSubview:self.text];
//
//    UIButton *textButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [textButton setFrame:CGRectMake(100, 100, 100, 100)];
//    [textButton setBackgroundColor:[UIColor blackColor]];
//    [textButton addTarget:self action:@selector(gaotuInterview:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:textButton];
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
