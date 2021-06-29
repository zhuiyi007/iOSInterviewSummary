//
//  BlockCycle.m
//  test
//
//  Created by 张森 on 2021/3/22.
//

#import "BlockCycle.h"

typedef void (^PersonBlock)(void);

@interface BlockCyclePerson : NSObject

// 在ARC下
// strong和copy效果相同
// strong指针引用时会自动copy到堆
@property (nonatomic, copy) PersonBlock block;

@property (nonatomic, assign) int age;

@end

@implementation BlockCyclePerson

- (void)dealloc {
    
    NSLog(@"%s", __func__);
}

@end

@implementation BlockCycle

+ (void)excute {
    
#pragma mark - block循环引用问题
    /**
     1.当block内部引用self时,会产生循环引用
        -   person是强引用的auto变量
            block内部会产生一个强指针
            指向person
            BlockCyclePerson *__strong person
     
     2.解除循环引用的方案:
        -   block内部的强指针变为__weak/__unsafe_unretain/__block
            __weak : 当对象释放后,会自动置为nil
            __unsafe_unretain : 当对象释放后,不会置为nil,再次访问的话会出现问题
            __block : 在ARC下也可以解决循环引用,但是需要在block最后置为nil,且需要调用一次block
                __block typeof(person) blockPerson = person;
                person.block = ^{
                    NSLog(@"age is :%d", blockPerson.age);
                    blockPerson = nil;
                };
                person.block();
        -   MRC下,可以用__block/__unsafe_unretain
            __block : 在ARC下对对象进行强引用,在MRC下是弱引用
     
     */
    BlockCyclePerson *person = [[BlockCyclePerson alloc] init];
    person.age = 10.0f;
    __block typeof(person) blockPerson = person;
    person.block = ^{
        NSLog(@"age is :%d", blockPerson.age);
        blockPerson = nil;
    };
    person.block();
    NSLog(@"-----");
}

@end
