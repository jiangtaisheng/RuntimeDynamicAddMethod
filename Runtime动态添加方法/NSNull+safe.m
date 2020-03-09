//
//  NSNull+safe.m
//  Runtime动态添加方法
//
//  Created by jiangtaisheng on 2019/5/13.
//  Copyright © 2019 jiangtaisheng. All rights reserved.
//

#import "NSNull+safe.h"
#define pLog
#define JsonObjects @[@"",@0,@{},@[]]
@implementation NSNull (safe)

//我们进行数据解析时，经常碰到服务器会给我们返回NULL，导致crash..因为服务器返回数据中只有数字，字符串， 数组和字典四种类型，所以我们只要在NULL找不到方法实现的时候向能响应这个方法的对象进行转发就可以啦

- (id)forwardingTargetForSelector:(SEL)aSelector {
    
    for (id jsonObj in JsonObjects) {
        if ([jsonObj respondsToSelector:aSelector]) {
            NSLog(@"NULL出现啦！这个对象应该是是_%@",[jsonObj class]);
            return jsonObj;
        }
    }
    return [super forwardingTargetForSelector:aSelector];
}@end
