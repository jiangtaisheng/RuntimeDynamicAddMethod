//
//  NSMutableArray+safe.m
//  Runtime动态添加方法
//
//  Created by jiangtaisheng on 2019/5/14.
//  Copyright © 2019 jiangtaisheng. All rights reserved.
//

#import "NSMutableArray+safe.h"
#import <objc/runtime.h>
@implementation NSMutableArray (safe)
-(id)newObjectAtIndex:(NSUInteger)idx{
    NSLog(@"----------------------\n");
    if (idx >=self.count) {
        NSLog(@"数组越狱了");
        return nil;
    }
    return [self newObjectAtIndex:idx];
}

-(void)newaddObject:(id)object{
    if (object) {
        NSLog(@"可以添加成功\n");
        [self newaddObject:object];
    }else{
        NSLog(@"NSMutableArray 不能添加nil");
    }
}

+(void)reObjectAtIndex{
    SEL originIndexSel=@selector(objectAtIndex:);
    SEL newIndexSel=@selector(newObjectAtIndex:);
    
    Class clss=objc_getClass("__NSArrayM") ;
    Method originMethod = class_getInstanceMethod(clss,originIndexSel);
    Method newMethod = class_getInstanceMethod(clss,newIndexSel);
    
    if (class_addMethod(clss, originIndexSel, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))) { //需要被替换的方法没有方法实现，此时需要添加方法 并相互交换方法实现IMP
        NSLog(@"----------NSMutableArray-class_replaceMethod-------------");
        class_replaceMethod(clss, newIndexSel, method_getImplementation(originMethod), method_getTypeEncoding(originMethod));
    }else{//两个方法的都有实现，此时交换两个方法的实现 IMP
        NSLog(@"------NSMutableArray----exchangeImplementations-------------");
        method_exchangeImplementations(originMethod, newMethod);
    }
    
}

+(void)reAddObject{
  
    SEL originaddSel=@selector(addObject:);
    SEL newaddSel=@selector(newaddObject:);
    
    Class clss=objc_getClass("__NSArrayM");
    Method originMethod = class_getInstanceMethod(clss,originaddSel);
    Method newMethod = class_getInstanceMethod(clss,newaddSel);
    
    if (class_addMethod([self class], originaddSel, method_getImplementation(newMethod), method_getTypeEncoding(originMethod))) { //需要被替换的方法没有方法实现，此时需要添加方法 并相互交换方法实现IMP
        NSLog(@"----------NSMutableArray--class_replaceMethod-------------");
        class_replaceMethod([self class], newaddSel, method_getImplementation(originMethod), method_getTypeEncoding(originMethod));
        
    }else{//两个方法的都有实现，此时交换两个方法的实现 IMP
        NSLog(@"------NSMutableArray----exchangeImplementations-------------");
        method_exchangeImplementations(originMethod, newMethod);
    }
}

//+(void)load{
//
//    [self reObjectAtIndex];
//    [self reAddObject];
//
//}





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


//+ (void)load{
//
//    
////        @autoreleasepool {
////            [objc_getClass("__NSArray0") swizzleMethod:@selector(objectAtIndex:) swizzledSelector:@selector(emptyObjectIndex:)];
////            [objc_getClass("__NSArrayI") swizzleMethod:@selector(objectAtIndex:) swizzledSelector:@selector(arrObjectIndex:)];
////            [objc_getClass("__NSArrayM") swizzleMethod:@selector(objectAtIndex:) swizzledSelector:@selector(mutableObjectIndex:)];
////            [objc_getClass("__NSArrayM") swizzleMethod:@selector(insertObject:atIndex:) swizzledSelector:@selector(mutableInsertObject:atIndex:)];
////        }
//    
//}

- (id)emptyObjectIndex:(NSInteger)index{
    return nil;
}

- (id)arrObjectIndex:(NSInteger)index{
    if (index >= self.count || index < 0) {
        return nil;
    }
    return [self arrObjectIndex:index];
}

- (id)mutableObjectIndex:(NSInteger)index{
    if (index >= self.count || index < 0) {
        return nil;
    }
    return [self mutableObjectIndex:index];
}

- (void)mutableInsertObject:(id)object atIndex:(NSUInteger)index{
    if (object) {
        [self mutableInsertObject:object atIndex:index];
    }
}

@end
