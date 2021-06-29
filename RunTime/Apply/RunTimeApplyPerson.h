//
//  RunTimeApplyPerson.h
//  test
//
//  Created by 张森 on 2021/3/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RunTimeApplyPerson : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) int age;
@property (nonatomic, assign) double height;

- (void)run;

@end

NS_ASSUME_NONNULL_END
