//
//  ViewController.m
//  Runtime动态添加方法
//
//  Created by jiangtaisheng on 2019/5/13.
//  Copyright © 2019 jiangtaisheng. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import "Person.h"
#import "Boss.h"
@interface ViewController ()

@end

@implementation ViewController

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    NSLog(@"-----------00000------------");
}
+(void)load{
    SEL  originSel= @selector(viewWillAppear:);
    SEL  newSel=@selector(newviewWillAppear:);
    Method originMethod =class_getInstanceMethod([self class],originSel);
    Method newMethod =class_getInstanceMethod([self class],newSel);
     //原来的类没有实现指定的方法，那么我们就得先做判断，把方法添加进去，然后进行替换
    if (class_addMethod([self class], originSel,method_getImplementation(newMethod), method_getTypeEncoding(originMethod))){
        NSLog(@"-----class_replaceMethod-----");
        class_replaceMethod([self class],newSel , method_getImplementation(originMethod), method_getTypeEncoding(originMethod));
    }else{
        NSLog(@"-----method_exchangeImplementations-----");
        method_exchangeImplementations(originMethod, newMethod);
    }
}

-(void)newviewWillAppear:(BOOL)animated{
    NSLog(@"------newviewWillAppear-------");
    [self newviewWillAppear:animated];
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSMutableDictionary * dict=[[NSMutableDictionary alloc]initWithCapacity:0];
////    [dict setObject:@"xxx" forKey:nil];
//    dict[@"xx"]=nil;
    
    
    NSMutableArray * array=[NSMutableArray arrayWithCapacity:0];
    [array addObject:@"222"];
//    [array addObject:nil];
//    [array objectAtIndex:20];
    NSLog(@"2222222222");
    NSArray * arr=@[@"333",@"4444"];
    NSString *str= array[4];
//
//    Person *p=[[Person alloc]init];
//    p.name=@"jts";
//
//    Boss * boss = [[Boss alloc]init];
//    [boss performSelector:@selector(eat:) withObject:@"西瓜,芝麻"];
    
    //[p isPerson:@"man"];
    //[Person testLoadResoure];

//    NSMutableDictionary * dic=[NSNull null];
//    dic[@"KC"]=@"909";
//    [dic setObject:@"ddd" forKey:@"cc"];
//    [dic objectForKey:@"qqq"];
}


@end
