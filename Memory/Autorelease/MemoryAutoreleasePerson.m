//
//  MemoryAutoreleasePerson.m
//  test
//
//  Created by 张森 on 2021/4/6.
//

#import "MemoryAutoreleasePerson.h"

@implementation MemoryAutoreleasePerson
- (void)dealloc
{
    NSLog(@"%s", __func__);
}
@end
