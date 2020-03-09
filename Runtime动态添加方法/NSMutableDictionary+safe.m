//
//  NSMutableDictionary+safe.m
//  Runtime动态添加方法
//
//  Created by jiangtaisheng on 2019/5/13.
//  Copyright © 2019 jiangtaisheng. All rights reserved.
//

#import "NSMutableDictionary+safe.h"
#import <objc/runtime.h>
@implementation NSMutableDictionary (safe)


+(void)load{
    
    SEL originSel=@selector(setObject:forKey:);
    SEL newSel=@selector(newreSetObject:forKey:);
    Class clss=objc_getClass("__NSDictionaryM");
    Method originMethod = class_getInstanceMethod(clss,originSel);
    Method newMethod = class_getInstanceMethod(clss,newSel);

    if (class_addMethod([self class], originSel, method_getImplementation(newMethod), method_getTypeEncoding(originMethod))) { //需要被替换的方法没有方法实现，此时需要添加方法 并相互交换方法实现IMP
        NSLog(@"----------NSMutableDictionary--class_replaceMethod-------------");
        class_replaceMethod([self class], newSel, method_getImplementation(originMethod), method_getTypeEncoding(originMethod));
        
    }else{//两个方法的都有实现，此时交换两个方法的实现 IMP
        NSLog(@"------NSMutableDictionary----exchangeImplementations-------------");
        method_exchangeImplementations(originMethod, newMethod);
    }
    
    
}


-(void)newreSetObject:(id)anObject forKey:(id)aKey{
    
    if (anObject&&aKey) {
        //自己的代码
//        NSLog(@"KVC一切正常");
        [self newreSetObject:anObject forKey:aKey];
    }else{
        NSLog(@"KVC键值对不能为空");
    }
}


@end
