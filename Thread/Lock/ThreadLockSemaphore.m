//
//  ThreadLockSemaphore.m
//  test
//
//  Created by 张森 on 2021/3/31.
//

#import "ThreadLockSemaphore.h"
@interface ThreadLockSemaphore ()

@property (nonatomic, strong) dispatch_semaphore_t otherSem1;
@property (nonatomic, strong) dispatch_semaphore_t otherSem2;
@property (nonatomic, strong) dispatch_semaphore_t ticketSem;
@property (nonatomic, strong) dispatch_semaphore_t moneySem;

@end

@implementation ThreadLockSemaphore

- (instancetype)init
{
    self = [super init];
    if (self) {

        self.otherSem1 = dispatch_semaphore_create(1);
        self.otherSem2 = dispatch_semaphore_create(0);
        self.ticketSem = dispatch_semaphore_create(1);
        self.moneySem = dispatch_semaphore_create(1);
    }
    return self;
}

- (void)otherTest {
    
    [[[NSThread alloc] initWithTarget:self selector:@selector(printOushu) object:nil] start];
    [[[NSThread alloc] initWithTarget:self selector:@selector(printJishu) object:nil] start];
}

- (void)printOushu {

    for (NSInteger index = 0; index <= 100; index += 2) {
        
        dispatch_semaphore_wait(self.otherSem1, DISPATCH_TIME_FOREVER);
        NSLog(@"%ld", (long)index);
        dispatch_semaphore_signal(self.otherSem2);
    }
}

- (void)printJishu {

    for (NSInteger index = 1; index < 100; index += 2) {

        dispatch_semaphore_wait(self.otherSem2, DISPATCH_TIME_FOREVER);
        NSLog(@"%ld", (long)index);
        dispatch_semaphore_signal(self.otherSem1);
    }
    // 因为此循环次数比偶数少一次,因此需要多signal一次
    dispatch_semaphore_signal(self.otherSem1);
}

- (void)__saveMoney {
    
    dispatch_semaphore_wait(self.moneySem, DISPATCH_TIME_FOREVER);
    [super __saveMoney];
    dispatch_semaphore_signal(self.moneySem);
}

- (void)__withdrawMoney {
    
    dispatch_semaphore_wait(self.moneySem, DISPATCH_TIME_FOREVER);
    [super __withdrawMoney];
    dispatch_semaphore_signal(self.moneySem);
}

- (void)__sellTicket {
    
    dispatch_semaphore_wait(self.ticketSem, DISPATCH_TIME_FOREVER);
    [super __sellTicket];
    dispatch_semaphore_signal(self.ticketSem);
}

@end
