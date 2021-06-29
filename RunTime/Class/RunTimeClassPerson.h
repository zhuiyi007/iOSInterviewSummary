//
//  RunTimeClassPerson.h
//  test
//
//  Created by 张森 on 2021/3/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RunTimeClassPerson : NSObject

- (int)runTimeClassPersonTestFunc:(NSString *)func;

+ (NSString *)runTimeClassPersonTestClassFunc:(NSString *)func;

@end

NS_ASSUME_NONNULL_END
