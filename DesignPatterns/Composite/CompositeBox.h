//
//  CompositeBox.h
//  test
//
//  Created by 张森 on 2021/2/9.
//

#import <Foundation/Foundation.h>
#import "Composite.h"

NS_ASSUME_NONNULL_BEGIN

@interface CompositeBox : NSObject<Composite>

+ (instancetype)creatBox;

- (void)add:(id<Composite>)product;
- (void)remove:(id<Composite>)product;
@end

NS_ASSUME_NONNULL_END
