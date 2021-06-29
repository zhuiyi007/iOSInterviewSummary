//
//  ThreadLockNSConditionLock.m
//  test
//
//  Created by 张森 on 2021/3/31.
//

#import "ThreadLockNSConditionLock.h"

@interface ThreadLockNSConditionLock()

@property (nonatomic, strong) NSConditionLock *conditionLock;

@end

@implementation ThreadLockNSConditionLock

- (instancetype)init
{
    self = [super init];
    if (self) {
                
        self.conditionLock = [[NSConditionLock alloc] initWithCondition:1];
    }
    return self;
}

- (void)otherTest {
    
    [[[NSThread alloc] initWithTarget:self selector:@selector(printJishu) object:nil] start];
    sleep(2.0f);
    [[[NSThread alloc] initWithTarget:self selector:@selector(printOushu) object:nil] start];
}

- (void)printOushu {
    
    for (NSInteger index = 0; index <= 100; index += 2) {
        [self.conditionLock lockWhenCondition:1];
        NSLog(@"%ld", (long)index);
        [self.conditionLock unlockWithCondition:2];
    }
    NSLog(@"----oushu-finished----");
}

- (void)printJishu {
    
    for (NSInteger index = 1; index < 100; index += 2) {
        [self.conditionLock lockWhenCondition:2];
        NSLog(@"%ld", (long)index);
        [self.conditionLock unlockWithCondition:1];
    }
    NSLog(@"----jishu-finished----");
}

@end
