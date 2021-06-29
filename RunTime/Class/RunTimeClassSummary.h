//
//  Class.h
//  test
//
//  Created by 张森 on 2021/3/23.
//

#prama mark - class的结构

struct objc_class {
    Class _Nonnull isa
    Class superclass;
    cache_t cache;                  // 方法缓存
    class_data_bits_t bits;         // 用于获取具体的类信息
    class_rw_t *data() const {      // 具体类信息
        return bits.data();
    }
};

/**
 cache步骤:
    1. void cache_t::insert(SEL sel, IMP imp, id receiver)
        往bucket中插入cache
        - 首先检查空间是否足够(fastpath下为3/4容量)
        - 空间不够的话,需要扩容mask值的容量,每次*2
            capacity = capacity ? capacity * 2 : INIT_CACHE_SIZE;
            初始空间为2
            扩容后需要重新初始化容器 reallocate(oldCapacity, capacity, true);
        - 先做一步 sel & mask,算出一个初始index
            mask_t begin = cache_hash(sel, m);
            static inline mask_t cache_hash(SEL sel, mask_t mask)
            {
                uintptr_t value = (uintptr_t)sel;
                return (mask_t)(value & mask);
            }
            如果当前位置空,则直接放入,如果不空,则cache_next,往前一个空间找
    2. 寻找cache
        - 调用cache_getImp方法
            extern "C" IMP cache_getImp(Class cls, SEL sel, IMP value_on_constant_cache_miss = nil);
            具体是调用CacheLookup方法,汇编原码
 */

struct bucket_t {
    // IMP-first is better for arm64e ptrauth and no worse for arm64.
    // SEL-first is better for armv7* and i386 and x86_64.
#if __arm64__
    explicit_atomic<uintptr_t> _imp;
    explicit_atomic<SEL> _sel;
#else
    explicit_atomic<SEL> _sel;
    explicit_atomic<uintptr_t> _imp;
#endif
};
struct cache_t {

    struct bucket_t *buckets() const;       // 散列表
    mask_t mask() const;                    // 掩码值()
    mask_t occupied() const;                // 已缓存的方法数量
};


struct class_data_bits_t {
    uintptr_t bits;
    class_rw_t* data() const {
        return (class_rw_t *)(bits & FAST_DATA_MASK);
    }
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

struct method_t {
    struct big {
        SEL name;               // 方法名 底层类似于char *, 不同类中相同的方法名,所对应的SEL是相同的
        const char *types;      // 编码,返回值类型,参数类型 @encode(SEL)
        IMP imp;                // 指向函数的指针 typedef id _Nullable (*IMP)(id _Nonnull, SEL _Nonnull, ...);
    };
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

