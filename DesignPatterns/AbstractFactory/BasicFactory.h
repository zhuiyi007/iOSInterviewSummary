//
//  BasicFactory.h
//  test
//
//  Created by 张森 on 2021/1/26.
//

#import <Foundation/Foundation.h>
#import "ChairProduct.h"
#import "TableProduct.h"

NS_ASSUME_NONNULL_BEGIN

@interface BasicFactory : NSObject

- (ChairProduct *)createChair;
- (TableProduct *)createTable;
@end

NS_ASSUME_NONNULL_END
