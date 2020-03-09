//
//  Person.m
//  Runtime动态添加方法
//
//  Created by jiangtaisheng on 2019/5/13.
//  Copyright © 2019 jiangtaisheng. All rights reserved.
//

#import "Person.h"
#import <objc/runtime.h>
#import "Boss.h"
@implementation Person

+(void)replaceClassTest{
    NSLog(@"该类的此类方法没实现");
}

-(void)replaceInstanceClassTest{
    NSLog(@"该类的此实例方法没实现");
}

//消息转发机制

//1.当向调用一个方法，但没有实现时，消息会通过上面两个方法寻找是否能找到实现
//+(BOOL)resolveInstanceMethod:(SEL)sel{
//
//    SEL  addSel= @selector(replaceInstanceClassTest);
//    Method addMethod =class_getInstanceMethod([self class], addSel);
//    class_addMethod([self class], sel, method_getImplementation(addMethod),"v@:");
//    return YES;
//}
//+(BOOL)resolveClassMethod:(SEL)sel{
//    SEL  addSel= @selector(replaceClassTest);
//    Method addMethod =class_getClassMethod(self,addSel);
//    class_addMethod(object_getClass(self), sel, method_getImplementation(addMethod),"v@:");
//    return YES;
//}

//2.找的是一个能响应该方法的对象
//-(id)forwardingTargetForSelector:(SEL)aSelector
//{
//    return [[Boss alloc]init];
//}

//3.- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector 会进行这一步，生成方法签名,如果方法签名为nil直接调用doesNotRecognizeSelector:返回异常，如果正常生成方法签名，则进行最后一步 - (void)forwardInvocation:(NSInvocation *)anInvocation

//-(NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
//    if ([NSStringFromSelector(aSelector) isEqualToString:@"isPerson:"]) {
//
//        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
//    }
//    return [super methodSignatureForSelector:aSelector];
//}


//4.如果在这一步也不处理，只要你实现forwardInvocation :方法就不会抛出异常，消息被过滤掉，也就是并不会走doesNotRecognizeSelector:方法
//
//-(void)forwardInvocation:(NSInvocation *)anInvocation{
//    [anInvocation invokeWithTarget:[[Boss alloc]init]];
//}





@end
