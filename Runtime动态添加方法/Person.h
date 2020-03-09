//
//  Person.h
//  Runtime动态添加方法
//
//  Created by jiangtaisheng on 2019/5/13.
//  Copyright © 2019 jiangtaisheng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject
@property(nonatomic,copy)NSString * name;
-(void)isPerson:(NSString *)sex;
+(void)testLoadResoure;

@end

NS_ASSUME_NONNULL_END
