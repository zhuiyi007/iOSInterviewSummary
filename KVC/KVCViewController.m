//
//  KVCViewController.m
//  test
//
//  Created by 张森 on 2021/3/16.
//

#import "KVCViewController.h"
#import "KVCPerson.h"
@interface KVCViewController ()

@end

@implementation KVCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    KVCPerson *person = [[KVCPerson alloc] init];
    // KVC的修改是可以触发KVO的,不管有没有属性,有没有调用set方法,即:KVC访问成员变量_age/_isAge/age/isAge时也会调用KVO方法
    [person addObserver:self forKeyPath:@"age" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    person->_age = 10;
    person->_isAge = 11;
    person->age = 12;
    person->isAge = 13;
    [person setValue:@(20) forKey:@"age"];
#pragma mark - KVC赋值过程
    /**寻找setAge:方法
     寻找_setAge:方法
     访问+ (BOOL)accessInstanceVariablesDirectly看是否允许访问成员变量(默认返回值为yes)
     KVC按照此顺序查找成员变量_age/_isAge/age/isAge
     修改成员变量时,先调用willchange,再修改,再调用didchange,所以可以触发KVO**/
    //    [person setValue:@10.0 forKey:@"age"];
    //    NSLog(@"%f", person->age);
    
    person.cat = [[KVCCat alloc] init];
    // keypath可以给复杂对象赋值
    [person setValue:@20.0 forKeyPath:@"cat.weight"];
    NSLog(@"%f", person.cat.weight);
    
#pragma mark - KVC取值过程
    // 先后调用getAge/age/isAge/_age这些方法来取值
    // 如果都没有实现,则调用+ (BOOL)accessInstanceVariablesDirectly看是否允许访问成员变量(默认返回值为yes)
    // 先后访问_age/_isAge/age/isAge成员变量来返回值
    NSLog(@"%@", [person valueForKey:@"age"]);
    [person willChangeValueForKey:@"age"];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    NSLog(@"%@ - 对象的 - %@ - 属性发生了变化 - %@", object, keyPath, change);
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
