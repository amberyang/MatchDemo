//
//  YLMatchActionManager.m
//  YLMatchRuleDemo
//
//  Created by amber on 2019/4/1.
//  Copyright © 2019年 amber. All rights reserved.
//

#import "YLMatchManager.h"
#import "YLMatchObjectManager.h"
#import "YLMatchRuleTool.h"

@implementation YLMatchManager

+ (void)excuteMatchAction:(Protocol *)protocol
                   params:(NSDictionary<NSString *, NSString *> *)params
            defaultAction:(void(^)(id<YLMatchRuleProtocol> object, Protocol *protocol, NSArray<NSString *> *keys))actionBlock {
    NSHashTable *table = [[YLMatchObjectManager sharedInstance] getObjectsForProtocol:protocol];
    for (id<YLMatchRuleProtocol> object in table) {
        NSArray<NSString *> *keys = [[YLMatchRuleTool sharedInstance] matchObject:object params:params protocol:protocol];
        if (keys.count > 0) {
            if ([object respondsToSelector:@selector(mrp_matchAction:type:)]) {
                //                dispatch_async(dispatch_get_main_queue(), ^{
                BOOL isExcute = [object mrp_matchAction:protocol type:keys];
                if (isExcute) {
                    if (actionBlock) {
                        actionBlock(object, protocol, keys);
                    }
                }
                //                });
            }
        }
    }
}

+ (void)addMethod:(SEL)method forKey:(NSString *)key protocol:(Protocol *)protocol {
    [[YLMatchRuleTool sharedInstance] addMethod:method forKey:key protocol:protocol];
}

+ (NSArray<NSString *> *)matchObject:(id<YLMatchRuleProtocol>)object
                              params:(NSDictionary<NSString *, id> *)params
                            protocol:(Protocol *)protocol {
    return [[YLMatchRuleTool sharedInstance] matchObject:object params:params protocol:protocol];
}

+ (void)addObject:(__weak id<YLMatchRuleProtocol>)object protocol:(Protocol *)protocol {
    [[YLMatchObjectManager sharedInstance] addObject:object protocol:protocol];
}

+ (void)addObject:(__weak id<YLMatchRuleProtocol>)object protocols:(NSArray<Protocol *> *)protocols {
    [[YLMatchObjectManager sharedInstance] addObject:object protocols:protocols];
}


@end
