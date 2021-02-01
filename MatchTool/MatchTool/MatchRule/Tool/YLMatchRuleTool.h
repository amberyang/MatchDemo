//
//  YLMatchRuleTool.h
//  YLMatchRuleDemo
//
//  Created by amber on 2019/3/27.
//

#import <UIKit/UIKit.h>
#import "YLMatchRuleProtocol.h"

@interface YLMatchRuleTool : NSObject

/**
 规则设置和匹配
 
 @return 单例
 */
+ (instancetype)sharedInstance;

/**
 添加匹配项
 
 @param method 匹配项对应的方法，遵循 “DCMatchRuleProtocol.h” 协议及扩展
 @param key 匹配的 key 值
 @param protocol 匹配协议
 */
- (void)addMethod:(SEL)method forKey:(NSString *)key protocol:(Protocol *)protocol;


/**
 获取协议配置的 key 和 method 的对应关系
 
 @param protocol 协议
 @return 字典
 */
- (NSDictionary<NSString *, NSString *> *)getMatchMapTableForProtocol:(Protocol *)protocol;

/**
 获取匹配成功的 key 值
 
 @param object 匹配的对象
 @param params 外部传入的匹配数据
 @param protocol 匹配协议
 @return 获取匹配成功的 key 值， 匹配失败返回 nil
 */
- (NSArray<NSString *> *)matchObject:(id<YLMatchRuleProtocol>)object
                              params:(NSDictionary<NSString *, id> *)params
                            protocol:(Protocol *)protocol;


/**
 获取协议对象所有 string 返回值的 key 和 value
 
 @param object  执行对象
 @param methodKey 方法key
 @param methodString 方法名
 @param params  方法参数
 @return 执行对象实现的协议对象的 string 返回值的 key 和 value
 */
+ (id)getParamWithObject:(id)object
               methodKey:(NSString *)methodKey
                  method:(NSString *)methodString
                  params:(NSDictionary<NSString *, id> *)params;


/**
 获取方法名对应的返回值
 
 @param object 被执行的对象
 @param params  方法参数
 @param protocol 协议对象
 @return 返回值
 */
+ (NSDictionary<NSString *, id> *)getJointParams:(id)object
                                          params:(NSDictionary<NSString *, id> *)params
                                        protocol:(Protocol *)protocol;

@end
