//
//  RunTimeISAPerson.m
//  test
//
//  Created by 张森 on 2021/3/22.
//

#import "RunTimeISAPerson.h"
// 方案三:共用体
#define TallMask (1<<0)
#define RichMask (1<<1)
#define CoolMask (1<<2)
@implementation RunTimeISAPerson
{
    // 共用体
    // 相当于结构体,但是结构体中的所有元素公用一份内存地址
    // 即bits为char类型,占用一个字节,8位
    // struct与char公用这8位
    // 在使用时,只使用bits
    // 因此,struct不额外占用内存,同时也会增加代码可读性
    union {
        char bits;
        struct {
            char tall : 1; // 代表只占一位
            char rich : 1; // 且会按照先后顺序从低位往高位排列
            char cool : 1;
            // 0x0000 0000
            // 0x0000 0trc
        };
    }_tallRichCool;
}

- (void)setTall:(BOOL)tall {
    
    if (tall) {
        
        _tallRichCool.bits |= TallMask;
    } else {
        
        _tallRichCool.bits &= ~TallMask;
    }
}
- (void)setRich:(BOOL)rich {
    
    if (rich) {
        
        _tallRichCool.bits |= RichMask;
    } else {
        
        _tallRichCool.bits &= ~RichMask;
    }
}
- (void)setCool:(BOOL)cool {
    
    if (cool) {
        
        _tallRichCool.bits |= CoolMask;
    } else {
        
        _tallRichCool.bits &= ~CoolMask;
    }
}

- (BOOL)isTall {
    
    return !!(_tallRichCool.bits & TallMask);
}
- (BOOL)isRich {
    
    return !!(_tallRichCool.bits & RichMask);
}
- (BOOL)isCool {
    
    return !!(_tallRichCool.bits & CoolMask);
}

@end


/**
 // 方案二:位域
@implementation RunTimeISAPerson
{
    struct {
        char tall : 1; // 代表只占一位
        char rich : 1; // 且会按照先后顺序从低位往高位排列
        char cool : 1;
        // 0x0000 0000
        // 0x0000 0trc
    } _tallRichCool;
}

- (void)setTall:(BOOL)tall {
    
    _tallRichCool.tall = tall;
}
- (void)setRich:(BOOL)rich {
    
    _tallRichCool.rich = rich;
}
- (void)setCool:(BOOL)cool {
    
    _tallRichCool.cool = cool;
}

- (BOOL)isTall {
    
    return _tallRichCool.tall;
}
- (BOOL)isRich {
    
    return _tallRichCool.rich;
}
- (BOOL)isCool {
    
    return _tallRichCool.cool;
}

@end
*/


/**
// 方案一:位运算
#define TallMask (1<<0)
#define RichMask (1<<1)
#define CoolMask (1<<2)

@implementation RunTimeISAPerson
{
    char _tallRichCool;
}

- (void)setTall:(BOOL)tall {
    
    if (tall) {
        
        _tallRichCool |= TallMask;
    } else {
        
        _tallRichCool &= ~TallMask;
    }
}
- (void)setRich:(BOOL)rich {
    
    if (rich) {
        
        _tallRichCool |= RichMask;
    } else {
        
        _tallRichCool &= ~RichMask;
    }
}
- (void)setCool:(BOOL)cool {
    
    if (cool) {
        
        _tallRichCool |= CoolMask;
    } else {
        
        _tallRichCool &= ~CoolMask;
    }
}

- (BOOL)isTall {
    
    return !!(_tallRichCool & TallMask);
}
- (BOOL)isRich {
    
    return !!(_tallRichCool & RichMask);
}
- (BOOL)isCool {
    
    return !!(_tallRichCool & CoolMask);
}

@end
 */

