//
//  YLMatchManager.h
//  YLMatchRuleDemo
//
//  Created by amber on 2019/4/1.
//  Copyright © 2019年 amber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YLMatchRuleProtocol.h"

@interface YLMatchManager : NSObject

/**
 执行匹配操作
 
 @param protocol 匹配的协议，用于查找此协议管理的页面
 @param params 匹配的数据
 @param actionBlock 默认的匹配处理行为
 */
+ (void)excuteMatchAction:(Protocol *)protocol
                   params:(NSDictionary<NSString *, id> *)params
            defaultAction:(void(^)(id<YLMatchRuleProtocol> object, Protocol *protocol, NSArray<NSString *> *keys))actionBlock;

/**
 添加匹配项
 
 @param method 匹配项对应的方法，遵循 “YLMatchRuleProtocol.h” 协议及扩展
 @param key 匹配的 key 值
 @param protocol 匹配协议
 */
+ (void)addMethod:(SEL)method forKey:(NSString *)key protocol:(Protocol *)protocol;

/**
 获取匹配成功的 key 值
 
 @param object 匹配的对象
 @param params 外部传入的匹配数据
 @param protocol 匹配协议
 @return 获取匹配成功的 key 值， 匹配失败返回 nil
 */
+ (NSArray<NSString *> *)matchObject:(id<YLMatchRuleProtocol>)object
                              params:(NSDictionary<NSString *, NSString *> *)params
                            protocol:(Protocol *)protocol;

/**
 添加需要被管理的对象，允许添加不同的协议
 
 @param object 支持协议的对象
 @param protocol 支持的协议
 */
+ (void)addObject:(__weak id<YLMatchRuleProtocol>)object protocol:(Protocol *)protocol;

/**
 添加需要被管理的对象，允许添加不同的协议
 
 @param object 支持协议的对象
 @param protocols 支持所有协议
 */
+ (void)addObject:(__weak id<YLMatchRuleProtocol>)object protocols:(NSArray<Protocol *> *)protocols;


@end
