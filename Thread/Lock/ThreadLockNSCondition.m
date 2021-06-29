//
//  ThreadLockNSLockCondition.m
//  test
//
//  Created by 张森 on 2021/3/30.
//

#import "ThreadLockNSCondition.h"

@interface ThreadLockNSCondition()

@property (nonatomic, strong) NSCondition *condition;

@end

@implementation ThreadLockNSCondition

- (instancetype)init
{
    self = [super init];
    if (self) {
                
        self.condition = [[NSCondition alloc] init];
    }
    return self;
}

- (void)otherTest {
    
    [[[NSThread alloc] initWithTarget:self selector:@selector(printOushu) object:nil] start];
    [[[NSThread alloc] initWithTarget:self selector:@selector(printJishu) object:nil] start];
}

- (void)printOushu {
    
    for (NSInteger index = 0; index <= 100; index += 2) {
        
        NSLog(@"%ld", (long)index);
        [self.condition signal];
        if (index == 100) {
            NSLog(@"1111");
            break;
        }
        [self.condition wait];
    }
    NSLog(@"----oushu--finished----");
}

- (void)printJishu {
    
    for (NSInteger index = 1; index < 100; index += 2) {
        
        [self.condition wait];
        NSLog(@"%ld", (long)index);
        [self.condition signal];
    }
    NSLog(@"----jishu--finished----");
    [self.condition unlock];
}

@end
