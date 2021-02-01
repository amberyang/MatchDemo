//
//  YLMatchRuleProtocol.h
//  YLMatchRuleDemo
//
//  Created by amber on 2019/3/27.
//

#import <Foundation/Foundation.h>

@protocol YLMatchRuleProtocol <NSObject>


@optional

/**
 需要进行匹配的协议，对应的 key 值
 第一个参数 NSString， 是协议名

 @return  NSArray， 所有需要比对的 key 值
 */
- (NSArray *)mrp_matchType:(Protocol *)protocol;

/**
 匹配成功后的行为
 
 @param protocol 匹配成功的协议
 @param types 匹配成功的 key 值
 @return 是否需要进行默认处理，yes，由 ruletool 进行默认关闭处理，no，则不进行处理
 */
- (BOOL)mrp_matchAction:(Protocol *)protocol type:(NSArray<NSString *> *)types;

/**
 demo 方法， 可以继承此协议，创建自己的协议名，格式必须为以下几种，参数和返回值不能变

 @return 匹配的内容值
 */
- (NSString *)demo_rule_getMatchContent;

/**
 demo 方法， 可以继承此协议，创建自己的协议名，格式必须为以下几种，参数和返回值不能变
 需要自己进行匹配

 @param value match 时 params 中的值
 @return 匹配结果
 */
- (BOOL)demo_rule_isMatchInfo:(NSString *)value;

///**
// demo 方法， 可以继承此协议，创建自己的协议名，格式必须为以下几种，参数和返回值不能变
// 需要自己进行匹配
// 
// @param params match 时的 params
// @return 匹配结果
// */
//- (BOOL)demo_rule_isMatchInfoWithParams:(NSDictionary *)params;

@end
