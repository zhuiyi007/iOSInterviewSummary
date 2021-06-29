//
//  main.m
//  test
//
//  Created by 张森 on 2021/1/5.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    
    
//    int a = 10;
//    int b = 20;
//    a = a + b;
//
//    return  0;
//
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
//    @autoreleasepool {
//        ^{
//            NSLog(@"hello block");
//        }();
//
//        int d = 5;
//        void (^block)(int, int) = ^(int a, int b) {
//            int c = a + b + d;
//            NSLog(@"a + b + d = %d", c);
//        };
//        block(3, 4);
//    }
//    return 0;
}
