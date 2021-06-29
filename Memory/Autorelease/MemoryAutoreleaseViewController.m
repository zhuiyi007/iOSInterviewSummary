//
//  MemoryAutoreleaseViewController.m
//  test
//
//  Created by 张森 on 2021/4/6.
//

#import "MemoryAutoreleaseViewController.h"
#import "MemoryAutoreleasePerson.h"

@interface MemoryAutoreleaseViewController ()

@end

extern void _objc_autoreleasePoolPrint(void);

@implementation MemoryAutoreleaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    MemoryAutoreleasePerson *person1 = [[MemoryAutoreleasePerson alloc] init];
}

@end
