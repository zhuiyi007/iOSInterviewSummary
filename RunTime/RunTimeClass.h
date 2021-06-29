//
//  RunTimeClass.h
//  test
//
//  Created by 张森 on 2021/3/23.
//

#import <Foundation/Foundation.h>

#ifndef RunTimeClass_h
#define RunTimeClass_h




typedef uintptr_t protocol_ref_t;  // protocol_t *, but unremapped
struct protocol_list_t {
    // count is pointer-sized by accident.
    uintptr_t count;
    protocol_ref_t list[0]; // variable-size
};

// 类的只读结构体,存着编译时类的内容
struct class_ro_t {
    
    const char * name;
    method_list_t * baseMethodList;
    protocol_list_t * baseProtocols;
    const ivar_list_t * ivars;
    const uint8_t * weakIvarLayout;
    property_list_t *baseProperties;
};

// 类的可读可写结构体
struct class_rw_t {
    uint32_t flags;
    Class firstSubclass;
    Class nextSiblingClass;
    const class_ro_t *ro;
    const method_array_t methods;           // 方法列表 method_array_t -> method_list_t -> method_t
    const property_array_t properties;      // 属性列表 property_array_t -> property_list_t -> property_t
    const protocol_array_t protocols;       // 协议列表 protocol_array_t -> protocol_list_t -> protocol_ref_t
};

#define FAST_DATA_MASK          0x00007ffffffffff8UL
struct class_data_bits_t {
    uintptr_t bits;
    class_rw_t* data() const {
        return (class_rw_t *)(bits & FAST_DATA_MASK);
    }
};

// OC对象
struct runtime_object_class {
    
    Class _Nonnull isa;
}

// 类对象
struct runtime_objc_class : runtime_object_class {
    
    Class superclass;
    cache_t cache;                  // 方法缓存
    class_data_bits_t bits;         // 用于获取具体的类信息
    class_rw_t *data() const {      // 具体类信息
        return bits.data();
    }
};

#endif /* RunTimeClass_h */
