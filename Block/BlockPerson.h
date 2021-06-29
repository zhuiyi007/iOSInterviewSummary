//
//  BlockPerson.h
//  test
//
//  Created by 张森 on 2021/3/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^PersonBlock)(void);

@interface BlockPerson : NSObject

@property (nonatomic, copy) PersonBlock block;

@property (nonatomic, assign) int age;

@end

NS_ASSUME_NONNULL_END
