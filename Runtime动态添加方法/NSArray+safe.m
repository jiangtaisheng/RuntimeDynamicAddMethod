//
//  NSArray+safe.m
//  Runtime动态添加方法
//
//  Created by jiangtaisheng on 2019/5/14.
//  Copyright © 2019 jiangtaisheng. All rights reserved.
//

#import "NSArray+safe.h"
#import <objc/runtime.h>
@implementation NSArray (safe)


+(void)swizzleMethod:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector{
    Class class = [self class];

    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);

    BOOL didAddMethod = class_addMethod(class,
                                        originalSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));

    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}


+ (void)load{
    @autoreleasepool {
        [objc_getClass("__NSArray0") swizzleMethod:@selector(objectAtIndex:) swizzledSelector:@selector(emptyObjectIndex:)];
        [objc_getClass("__NSArrayI") swizzleMethod:@selector(objectAtIndex:) swizzledSelector:@selector(arrObjectIndex:)];
        [objc_getClass("__NSArrayI") swizzleMethod:@selector(objectAtIndexedSubscript:) swizzledSelector:@selector(sxy_objectAtIndexedSubscript:)];
        [objc_getClass("__NSArrayM") swizzleMethod:@selector(objectAtIndex:) swizzledSelector:@selector(mutableObjectIndex:)];
        [objc_getClass("__NSArrayM") swizzleMethod:@selector(insertObject:atIndex:) swizzledSelector:@selector(mutableInsertObject:atIndex:)];
    }

}

- (id)emptyObjectIndex:(NSInteger)index{
    NSLog(@"数组越界000");
    return nil;
}

- (id)arrObjectIndex:(NSInteger)index{
    if (index >= self.count || index < 0) {
        NSLog(@"数组越界111");
        return nil;
    }
    return [self arrObjectIndex:index];
}

- (id)mutableObjectIndex:(NSInteger)index{
    if (index >= self.count || index < 0) {
        NSLog(@"数组越界222");
        return nil;
    }
    return [self mutableObjectIndex:index];
}

- (void)mutableInsertObject:(id)object atIndex:(NSUInteger)index{
    if (object) {
        [self mutableInsertObject:object atIndex:index];
    }
}

-(id)sxy_objectAtIndexedSubscript:(NSInteger)index{
    
    if (index >= self.count || index < 0) {
        NSLog(@"数组越界6666");
        return nil;
    }
    return [self sxy_objectAtIndexedSubscript:index];
}
//
//+ (void)load
//{
//    //使用单例模式
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        //方法的selector用于表示运行时方法的名字。
//        //Objective-C在编译时，会依据每一个方法的名字、参数序列，生成一个唯一的整型标识(Int类型的地址)，这个标识就是SEL
//        SEL newSel = @selector(newObjectAtIndex:);
//        SEL originalSel = @selector(objectAtIndex:);
//        //使用runtime方法拿到实例中的方法
//        Class cls= [objc_getClass("__NSArrayI") class];
//        Method newMethod = class_getInstanceMethod(cls, newSel);
//        Method originalMethod = class_getInstanceMethod(cls, originalSel);
//
//        if (class_addMethod(cls, originalSel, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))) { //需要被替换的方法没有方法实现，此时需要添加方法 并相互交换方法实现IMP
//            NSLog(@"----------NSMutableArray-class_replaceMethod-------------");
//            class_replaceMethod([self class], newSel, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
//        }else{
//        //交换方法
//            method_exchangeImplementations(originalMethod, newMethod);
//
//        }
//    });
//}
//- (id)newObjectAtIndex:(NSUInteger)index{
//    if (index > self.count-1) {
//        NSAssert(NO, @"index beyond the boundary");
//        return nil;
//    }else{
//        return [self newObjectAtIndex:index];
//    }
//}
//
@end
