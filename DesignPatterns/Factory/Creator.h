//
//  Creator.h
//  test
//
//  Created by 张森 on 2021/1/26.
//

#import <Foundation/Foundation.h>
#import "Product.h"

NS_ASSUME_NONNULL_BEGIN

@interface Creator : NSObject

+ (Product *)createProduct:(NSInteger)type;
@end

NS_ASSUME_NONNULL_END
