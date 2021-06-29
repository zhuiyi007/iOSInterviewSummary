//
//  ThreadLockSerialQueue.m
//  test
//
//  Created by 张森 on 2021/3/31.
//

#import "ThreadLockSerialQueue.h"

@interface ThreadLockSerialQueue ()

@property (nonatomic, strong) dispatch_queue_t moneyQueue;
@property (nonatomic, strong) dispatch_queue_t ticketQueue;
@property (nonatomic, strong) dispatch_queue_t otherQueue;
@property (nonatomic, strong) NSCondition *condition;

@end

@implementation ThreadLockSerialQueue

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.moneyQueue = dispatch_queue_create("moneyQueue", DISPATCH_QUEUE_SERIAL);
        self.ticketQueue = dispatch_queue_create("ticketQueue", DISPATCH_QUEUE_SERIAL);
        self.otherQueue = dispatch_queue_create("otherQueue", DISPATCH_QUEUE_SERIAL);
        
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
        dispatch_sync(self.otherQueue, ^{

            NSLog(@"%ld", index);
        });
        [self.condition signal];
        [self.condition wait];
    }
}

- (void)printJishu {

    for (NSInteger index = 1; index < 100; index += 2) {

        [self.condition wait];
        dispatch_sync(self.otherQueue, ^{

            NSLog(@"%ld", index);
        });
        [self.condition signal];
    }
}

- (void)__saveMoney {
    
    dispatch_sync(self.moneyQueue, ^{
        
        [super __saveMoney];
    });
}

- (void)__withdrawMoney {
    
    dispatch_sync(self.moneyQueue, ^{
        
        [super __withdrawMoney];
    });
}

- (void)__sellTicket {
    
    dispatch_sync(self.moneyQueue, ^{
        
        [super __sellTicket];
    });
}

@end
