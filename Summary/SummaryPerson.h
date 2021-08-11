//
//  SummaryPerson.h
//  test
//
//  Created by 张森 on 2021/7/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SummaryPerson : NSObject<NSCopying>

@property (nonatomic, copy) NSString *personId;
@property (nonatomic, copy) NSString *name;

@end

NS_ASSUME_NONNULL_END
