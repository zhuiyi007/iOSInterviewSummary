//
//  Archiecture.h
//  test
//
//  Created by 张森 on 2021/4/7.
//

#ifndef Archiecture_h
#define Archiecture_h

#pragma mark - MVC
/**
 1. Apple官方的使用 - tableview
    - model <--> controller <--> view
    - model和view之间互相不知道内部细节
    - 优点:view,model可以高度重用,也可以独立使用
    - 缺点:controller臃肿
 2. 变种
    - controller <--> view
            ↓           ↓
                model
    - 优点:对controller进行瘦身,将view内部细节封装起来,外界不知道view内部的具体实现
    - 缺点:view依赖于model,各自无法独立使用
 */
#pragma mark - MVP
/**
            controller
                ↓
 model <--> Presenter <--> view
 - 控制器拥有一个Presenter
 - Presenter作为之前controller的角色来联系model和view
 */

#pragma mark - MVVM
/**
 model <--> viewModel <--> view
 添加监听来实现自动刷新
 */

#endif /* Archiecture_h */
