//
//  testProtocol.h
//  test
//
//  Created by 张森 on 2021/1/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol testProtocol/**<NSObject>*/
- (void)foo;
@end
@interface testProtocol : NSObject<testProtocol>

@property (weak, nonatomic) id<testProtocol> delegate;
+(void)test;

@end

NS_ASSUME_NONNULL_END
