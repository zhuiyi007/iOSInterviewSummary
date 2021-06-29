//
//  CocoaTouchViewController.m
//  test
//
//  Created by 张森 on 2021/6/15.
//

#import "CocoaTouchViewController.h"

@interface CocoaTouchView : UIView
@property (nonatomic, copy) NSString *name;
@end

@implementation CocoaTouchView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    NSLog(@"%@---hitTest----%@", self.name, view);
    return view;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    BOOL result = [super pointInside:point withEvent:event];
    NSLog(@"%@---point----%ld", self.name, result);
    return result;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    NSLog(@"%@---touches", self.name);
}

@end

@interface CocoaTouchViewController ()

@end

@implementation CocoaTouchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CocoaTouchView *viewA = [[CocoaTouchView alloc] initWithFrame:CGRectMake(50, 50, [UIScreen mainScreen].bounds.size.width - 100.0f, [UIScreen mainScreen].bounds.size.height - 100.0f)];
    [viewA setBackgroundColor:[UIColor blueColor]];
    viewA.name = @"CocoaTouchViewA";
    [self.view addSubview:viewA];
    
    CocoaTouchView *viewB = [[CocoaTouchView alloc] initWithFrame:CGRectMake(0, 50, 100, 100)];
    [viewB setBackgroundColor:[UIColor redColor]];
    viewB.name = @"CocoaTouchViewB";
    [viewA addSubview:viewB];
    
    CocoaTouchView *viewC = [[CocoaTouchView alloc] initWithFrame:CGRectMake(20, 70, 100, 100)];
    [viewC setBackgroundColor:[UIColor greenColor]];
    viewC.name = @"CocoaTouchViewC";
    [viewA addSubview:viewC];
}

@end
