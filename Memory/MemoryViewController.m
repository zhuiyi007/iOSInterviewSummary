//
//  MemoryViewController.m
//  test
//
//  Created by 张森 on 2021/4/1.
//

#import "MemoryViewController.h"
#import "MemoryTimerViewController.h"
#import "MemoryAutoreleaseViewController.h"
#import <objc/runtime.h>
#import <malloc/malloc.h>

@interface MemoryViewController ()
@property (nonatomic, strong) NSString *str;
@property (nonatomic, copy) NSMutableArray *arr;
@end

int a = 1;
int c;
@implementation MemoryViewController

- (void)memoryAddress {
    
    static int b = 2;
    static int d;
    
    NSString *str = @"123";
    NSString *str1 = @"456";
    
    NSObject *obj1 = [[NSObject alloc] init];
    NSObject *obj2 = [[NSObject alloc] init];
    
    int e = 10;
    int f = 10;
    
    NSLog(@"\nstr -> %p\nstr1 -> %p\na -> %p\nb -> %p\nc -> %p\nd -> %p\nobj1 -> %p\nobj2 -> %p\ne -> %p\nf -> %p\n",
          str, str1, &a, &b, &c, &d, obj1, obj2, &e, &f);
}

- (void)taggedPoint {
    
    NSNumber *number1 = @2;
    NSNumber *number2 = @0xfffffffffffff;
    NSNumber *number3 = @0xfffffffffffff1;
    NSNumber *number4 = [[NSNumber alloc] initWithInt:1];
    NSLog(@"%ld, %ld, %ld, %ld", class_getInstanceSize([number1 class]), class_getInstanceSize([number2 class]), class_getInstanceSize([number3 class]), class_getInstanceSize([number4 class]));
    NSLog(@"%ld, %ld, %ld, %ld", malloc_size((__bridge const void *)(number1)), malloc_size((__bridge const void *)(number2)), malloc_size((__bridge const void *)(number3)), malloc_size((__bridge const void *)(number4)));
    NSString *str1 = [NSString stringWithFormat:@"abc"];
    NSString *str2 = [NSString stringWithFormat:@"abcdefghi"];
    NSString *str3 = [NSString stringWithFormat:@"abcdefghig"];
    NSString *str4 = @"abcdefghig";
    NSLog(@"%ld, %ld, %ld, %ld", class_getInstanceSize([str1 class]), class_getInstanceSize([str2 class]), class_getInstanceSize([str3 class]), class_getInstanceSize([str4 class]));
    NSLog(@"%ld, %ld, %ld, %ld", malloc_size((__bridge const void *)(str1)), malloc_size((__bridge const void *)(str2)), malloc_size((__bridge const void *)(str3)), malloc_size((__bridge const void *)(str4)));
    
    NSDate *date = [NSDate date];
    NSLog(@"\nnumber1 -> %p\nnumber2 -> %p\nnumber3 -> %p\nnumber4 -> %p\nstr1 -> %p\nstr2 -> %p\nstr3 -> %p\nstr4 -> %p\ndate -> %p", number1, number2, number3,number4, str1, str2, str3,str4, date);
    NSLog(@"----------------------");
    
    /*
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    for (NSInteger index = 0; index < 10000; index ++) {
        
        dispatch_async(queue, ^{
            // 这段代码可能会发生崩溃
            // 因为@"abcdefghig"是一个对象
            // 在进行setter时,底层会对旧对象进行释放,并retain新对象
            // 因此会造成坏地址访问Thread 2: EXC_BAD_ACCESS (code=1, address=0xb70b45f00)
            self.str = [NSString stringWithFormat:@"abcdefghig"];
        });
    }
    
    for (NSInteger index = 0; index < 1000; index ++) {

        dispatch_async(queue, ^{
            // 这段代码不会发生崩溃
            // 因为@"abc"是一个taggedPoint
            self.str = [NSString stringWithFormat:@"abc"];
        });
    }
    NSLog(@"end");
     */
    /*
    number1     ->      @2                  ->      0x8d8745d2f94d7f39      ->  taggedPoint
    number2     ->      @0xfffffffffffff    ->      0x8a78ba2d06b281b1      ->  taggedPoint
    number3     ->      @0xfffffffffffff1   ->      0x282cfd9e0             ->  object
    str1        ->      @"abc"              ->      0x8d8745d2c8fc4eb0      ->  taggedPoint
    str2        ->      @"abcdefghi"        ->      0x89c73492db9fdee0      ->  taggedPoint
    str3        ->      @"abcdefghig"       ->      0x282cfc980             ->  object
    date        ->      [NSDate date]       ->      0x9b1f126e6987ee65      ->  taggedPoint
     */
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self taggedPoint];
//    self.arr = [NSMutableArray array];
//    [self.arr addObject:@"111"];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self taggedPoint];
//    UIViewController *vc = [[MemoryAutoreleaseViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
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
