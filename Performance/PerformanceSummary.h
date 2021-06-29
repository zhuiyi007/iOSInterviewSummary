//
//  PerformanceSummary.h
//  test
//
//  Created by 张森 on 2021/4/6.
//

#ifndef PerformanceSummary_h
#define PerformanceSummary_h
#pragma mark - 离屏渲染

#pragma mark - CPU&GPU
/**
 1. CPU负责计算,GPU负责渲染
    - CPU -> GPU -> 帧缓存 -> 视频控制器 -> 屏幕
    - iOS采用双缓冲机制,有前帧缓存和后帧缓存
 2. 屏幕成像会先发送垂直同步信号(VSync),表示即将刷新屏幕;再逐行发送水平同步信号(HSync)来进行逐行刷新
 */

#pragma mark - 卡顿产生的原因
/**
 ---> CPU ====> GPU
 
     VSync  VSync  VSync  VSync  VSync
 -->==>|-->=> |--->==|==>   |-->==>|
 正常     正常    卡顿           正常
 
 正常屏幕渲染是60FPS,即每次刷新处理要在16ms之内
 */

#pragma mark - 卡顿优化
/**
 1. CPU
    - 尽量用轻量级组件,例如:只显示内容的话,可以考虑用CALayer代替UIView
    - 不要频繁调用UIView的属性,例如frame, bounds, transform等
    - 提前计算好布局,有需要时一次性调整对应的属性,不要多次修改属性
    - Autolayout会比frame消耗更多的CPU资源
    - 图片的size最好跟UIImageView的size保持一致
    - 控制线程的最大并发数
    - 把耗时操作放到子线程
 
 2. GPU
    - 避免短时间内大量图片的显示,尽可能将多张图片合成一张进行显示
    - GPU能处理的最大纹理尺寸是4096*4096,超过这个尺寸就会占用CPU资源处理
    - 减少视图数量和层次
    - 减少透明的视图,不透明的就设置opaque = YES
    - 尽量避免出现离屏渲染
        - 离屏渲染相关!!!
 
 3. 卡顿监测
    - 可以添加Observer到主线程的RunLoop中,监听RunLoop状态切换的耗时,已达到监控卡顿的目的
 
 */

#pragma mark - 耗电优化
/**
 1. 尽可能降低CPU/GPU功耗
 2. 少用定时器
 3. 优化I/O操作
    - 尽量不要频繁写入小数据,最好批量一次性写入
    - 读写大量重要数据时,考虑用dispatch_io,提供了基于GCD的异步操作文件I/O的API,用dispatch_io系统会优化磁盘访问
    - 数据量比较大的,建议使用数据库
 4. 网络优化
    - 减少压缩网络数据
        - XML ->JSON -> protocol buffer
    - 考虑加入缓存
    - 断点续传
    - 判断网络可用状态
    - 增加取消机制和超时时间
    - 批量传输,不要传输很小的数据包
 5. 定位相关
    - 如果只是需要确定用户位置,用CLLocationManager的requestLocation方法, 定位完成后会自动让硬件断点
    - 如果不是导航应用,尽量不要实时更新位置,定位完毕就关掉定位
    - 降低定位精度,尽量不要使用精度最高的kCLLocationAccuracyBest
    - 需要后台定位时,设置pausesLocationUpdatesAutomatically为YES,如果用户不太可能移动的时候,系统会自动暂停位置更新
    - 尽量不要使用startMonitoringSignificantLocationChanges, 优先考虑startMonitoringForRegion
 6. 硬件检测优化
    - 用户移动,摇晃,倾斜设备时,会产生动作(montion)事件,这些事件由加速计,陀螺仪,磁力计等硬件检测,在不需要检测的场合,应该及时关闭这些硬件
 */

#pragma mark - APP的启动
/**
 1. 冷启动, 热启动
 2. 添加环境变量可以打印出APP的启动时间分析
    - Edit scheme -> Run -> Arguments
    - DYLD_PRINT_STATISTICS -> 1
    - DYLD_PRINT_STATISTICS_DETAILS -> 1 打印更详细的信息
 3. 启动阶段
    - dyld  主导,将可执行文件加载到内存,顺便加载所有依赖的动态库
        - 动态链接器,可以装载MACH-O文件(可执行文件,动态库)
        - 装载APP的可执行文件,同时递归加载所有依赖的动态库
        - 装载完毕后,通知Runtime
    - runtime   负责加载成objc定义的结构
        - 调用map_images进行可执行文件内容的解析和处理
        - 在load_images中调用call_load_methods, 调用所有类和分类的+load方法
        - 进行各种OC结构的初始化(注册Objc类,初始化类对象等)
        - 调用C++静态初始化器和__attribute__((constructor))修饰的函数(此修饰符的函数会在此阶段进行调用)
        - 至此,可执行文件和动态库中所有的符号(class,protocol,selector,IMP...)都已经按格式成功加载到内存中,被runtime所管理
    - main
        - runtime结束后,dyle会调用main函数
        - 接下来就是UIApplicationMain函数,调用didFinishLaunching方法
 4. 优化
    - dyld
        - 减少动态库,合并一些动态库,定期清理不必要的动态库
        - 减少Objc类,分类的数量,减少Selector数量
        - 减少C++虚函数的数量
        - swift尽量使用struct
    - runtime
        - 用+initialize方法和dispatch_once代替__attribute__((constructor)),C++静态构造器,Objc的+load方法
    - main
        - 在不影响用户体验的前提下,尽可能将一些操作延迟,不要放在didFinishLaunching中
 */

#pragma mark - 安装包瘦身
/**
 1. 安装包主要由可执行文件,资源组成
 2. 资源
    - 采取无损压缩
    - 去掉没有用到的资源 https://github.com/tinymind/LSUnusedResources
 3. 可执行文件
    - 编译器优化
        - Strip Linked Product
        - Make Strings Read-Only
        - Symbols Hidden by Default
        - 设置为YES
    - 去掉异常支持
        - Enable C++ Exceptions
        - Enable Objective-C Exceptions
        - 设置为NO
        - Other C Flags 添加-fno-exceptions
    - 利用AppCode检测未使用的代码https://www.jetbrains.com/objc/
        - 菜单栏 -> Code -> Inspect Code
    - 利用LLVM插件检测出重复代码,未被调用的代码
    - 生成LinkMap文件,查看可执行文件的具体组成
        - Write Link Man File -> Yes
        - 第三方工具:https://github.com/huanxsd/LinkMap

 
 */

#endif /* PerformanceSummary_h */
