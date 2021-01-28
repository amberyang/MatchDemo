//
//  YLMatchObjectManager.h
//  YLMatchRuleDemo
//
//  Created by amber on 2019/4/1.
//  Copyright © 2019年 amber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YLMatchRuleProtocol.h"

@interface YLMatchObjectManager : NSObject

/**
 管理注册的对象

 @return 单例
 */
+ (instancetype)sharedInstance;

/**
 添加需要被管理的对象，允许添加不同的协议

 @param object 支持协议的对象
 @param protocol 支持的协议
 */
- (void)addObject:(__weak id<YLMatchRuleProtocol>)object protocol:(Protocol *)protocol;

/**
 添加需要被管理的对象，允许添加不同的协议
 
 @param object 支持协议的对象
 @param protocols 支持所有协议
 */
- (void)addObject:(__weak id<YLMatchRuleProtocol>)object protocols:(NSArray<Protocol *> *)protocols;

/**
 获取目前注册的对象数组

 @param protocol 协议
 @return 数组
 */
- (NSHashTable *)getObjectsForProtocol:(Protocol *)protocol;

@end
