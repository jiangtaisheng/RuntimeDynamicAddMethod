//
//  Boss.m
//  Runtime动态添加方法
//
//  Created by jiangtaisheng on 2019/5/13.
//  Copyright © 2019 jiangtaisheng. All rights reserved.
//

#import "Boss.h"
#import <objc/runtime.h>
@implementation Boss



-(void)isPerson:(NSString *)str{
    NSLog(@"这是我Boss------%@",str);
}


//bool eat (id self ,SEL _cmd ,id thing){
//    NSLog(@"我吃了--%@\n",thing);
//    return true;
//}

-(BOOL)eat:(NSString *)thing{
    
    NSLog(@"我吃了--%@\n",thing);
    return true;
}

+(BOOL)resolveInstanceMethod:(SEL)sel{
    if ([NSStringFromSelector(sel) isEqualToString:@"eat:"]) {
        Method method = class_getInstanceMethod([self class], sel);
        class_addMethod(self,sel,method_getImplementation(method),"v@:");
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}

@end
