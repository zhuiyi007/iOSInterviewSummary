//
//  ThreadLockBase.h
//  test
//
//  Created by 张森 on 2021/3/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ThreadLockBase : NSObject

- (void)moneyTest;
- (void)ticketsTest;
- (void)otherTest;

- (void)__saveMoney;
- (void)__withdrawMoney;
- (void)__sellTicket;

@end

NS_ASSUME_NONNULL_END
