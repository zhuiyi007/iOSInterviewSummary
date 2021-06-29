//
//  RunTimeISAPerson.h
//  test
//
//  Created by 张森 on 2021/3/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RunTimeISAPerson : NSObject

- (void)setTall:(BOOL)tall;
- (void)setRich:(BOOL)rich;
- (void)setCool:(BOOL)cool;

- (BOOL)isTall;
- (BOOL)isRich;
- (BOOL)isCool;

@end

NS_ASSUME_NONNULL_END
