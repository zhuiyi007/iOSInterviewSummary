//
//  KVCPerson.h
//  test
//
//  Created by 张森 on 2021/3/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KVCCat : NSObject

@property (nonatomic, assign) double weight;
@end

@interface KVCPerson : NSObject
{
    @public
    // KVC按照此顺序查找成员变量
    int _age;
    int _isAge;
    int age;
    int isAge;
}
//@property (nonatomic, assign) double age;
@property (nonatomic, strong) KVCCat *cat;
@end

NS_ASSUME_NONNULL_END
