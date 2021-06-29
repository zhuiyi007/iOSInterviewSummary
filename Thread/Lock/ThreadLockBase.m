//
//  ThreadLockBase.m
//  test
//
//  Created by 张森 on 2021/3/30.
//

#import "ThreadLockBase.h"

@implementation ThreadLockBase
{
    int ticketCount;
    int money;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        ticketCount = 15;
        money = 100;
    }
    return self;
}

#pragma mark - 存取钱问题
- (void)moneyTest {
    
    dispatch_async(dispatch_queue_create("111", DISPATCH_QUEUE_CONCURRENT), ^{
       
        for (NSInteger index = 0; index < 5; index ++) {
            [self __withdrawMoney];
        }
    });
    
    dispatch_async(dispatch_queue_create("111", DISPATCH_QUEUE_CONCURRENT), ^{
       
        for (NSInteger index = 0; index < 5; index ++) {
            [self __saveMoney];
        }
    });
}

- (void)__saveMoney {
    
    int oldMoney = money;
    sleep(0.5);
    oldMoney += 50;
    money = oldMoney;
    NSLog(@"存50元,还剩%d ---- %@", money, [NSThread currentThread]);
}

- (void)__withdrawMoney {
    
    int oldMoney = money;
    sleep(0.5);
    oldMoney -= 20;
    money = oldMoney;
    NSLog(@"取20元,还剩%d ---- %@", money, [NSThread currentThread]);
}

#pragma mark - 卖票问题
- (void)__sellTicket {
    
    int oldCount = ticketCount;
    sleep(0.5);
//    sleep(600);
    oldCount--;
    ticketCount = oldCount;
    NSLog(@"ticket: %d ---- %@", ticketCount, [NSThread currentThread]);
}

- (void)ticketsTest {

    
    /**
     // 探寻锁的本质的代码
     */
//    for (NSInteger index = 0; index < 10; index ++) {
//        [[[NSThread alloc] initWithTarget:self selector:@selector(__sellTicket) object:nil] start];
//    }
//    return;;
    
    dispatch_async(dispatch_queue_create("111", DISPATCH_QUEUE_CONCURRENT), ^{
       
        for (NSInteger index = 0; index < 5; index ++) {
            [self __sellTicket];
        }
    });
    
    dispatch_async(dispatch_queue_create("111", DISPATCH_QUEUE_CONCURRENT), ^{
       
        for (NSInteger index = 0; index < 5; index ++) {
            [self __sellTicket];
        }
    });
    
    dispatch_async(dispatch_queue_create("111", DISPATCH_QUEUE_CONCURRENT), ^{
       
        for (NSInteger index = 0; index < 5; index ++) {
            [self __sellTicket];
        }
    });
    
}

- (void)otherTest {}

@end
