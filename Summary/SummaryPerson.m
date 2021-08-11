//
//  SummaryPerson.m
//  test
//
//  Created by 张森 on 2021/7/9.
//

#import "SummaryPerson.h"

@implementation SummaryPerson


- (BOOL)isEqual:(id)object {
    
    if ([object isKindOfClass:[SummaryPerson class]]) {
        return [((SummaryPerson *)object).personId isEqualToString:self.personId];
    }
    return NO;
}

//- (id)copyWithZone:(NSZone *)zone {
//    return self;
//}

@end
