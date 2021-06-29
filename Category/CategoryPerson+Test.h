//
//  CategoryPerson+Test.h
//  test
//
//  Created by 张森 on 2021/3/16.
//

#import "CategoryPerson.h"

NS_ASSUME_NONNULL_BEGIN

//struct _category_t {
//    const char *name;
//    struct _class_t *cls;
//    const struct _method_list_t *instance_methods;
//    const struct _method_list_t *class_methods;
//    const struct _protocol_list_t *protocols;
//    const struct _prop_list_t *properties;
//};

@interface CategoryPerson (Test)<NSObject, NSCopying>
- (void)test;
+ (void)classTest;
@property (nonatomic, copy) NSString *str;
@end

NS_ASSUME_NONNULL_END
