//
//  CategaryIvarsPerson+Test.h
//  test
//
//  Created by 张森 on 2021/3/17.
//

#import "CategaryIvarsPerson.h"

NS_ASSUME_NONNULL_BEGIN

@interface CategaryIvarsPerson (Test)

@property (nonatomic, copy) NSString *name;

//@property (nonatomic, assign) int weight;
// 只会生成setter,getter的声明:
//- (int)weight;
//- (void)setWeight:(int)weight;

@end

NS_ASSUME_NONNULL_END
