//
//  YLMatchObjectManager.m
//  YLMatchRuleDemo
//
//  Created by amber on 2019/4/1.
//  Copyright © 2019年 amber. All rights reserved.
//

#import "YLMatchObjectManager.h"
#import <objc/runtime.h>

@interface YLMatchObjectManager()

@property (nonatomic, strong) NSMutableDictionary<NSString *, NSHashTable *> *mapDic;

@end

@implementation YLMatchObjectManager

+ (instancetype)sharedInstance {
    static YLMatchObjectManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[YLMatchObjectManager alloc] init];
    });
    return manager;
}

- (void)addObject:(__weak id<YLMatchRuleProtocol>)object protocol:(Protocol *)protocol {
    if (!object || !protocol) {
        return;
    }
    NSHashTable *table = [self getObjectsForProtocol:protocol];
    if (!table) {
        table = [NSHashTable weakObjectsHashTable];
    }
    [table addObject:object];
    [self.mapDic setObject:table forKey:NSStringFromProtocol(protocol)];
}

/**
 添加需要被管理的对象，允许添加不同的协议
 
 @param object 支持协议的对象
 @param protocols 支持所有协议
 */
- (void)addObject:(__weak id<YLMatchRuleProtocol>)object protocols:(NSArray<Protocol *> *)protocols {
    for (Protocol *protocol in protocols) {
        [self addObject:object protocol:protocol];
    }
}

- (NSHashTable *)getObjectsForProtocol:(Protocol *)protocol {
    NSHashTable *table = [self.mapDic objectForKey:NSStringFromProtocol(protocol)];
    if (!table) {
        table = [NSHashTable weakObjectsHashTable];
    }
    unsigned int protocolCount;
    Protocol * __unsafe_unretained *superPtls = protocol_copyProtocolList(protocol, &protocolCount);
    if (protocolCount > 0) {
        for (int i=0; i< protocolCount; i++) {
            if (![@"NSObject" isEqualToString:NSStringFromProtocol(superPtls[i])]) {
                NSHashTable *superTable = [self.mapDic objectForKey:NSStringFromProtocol(superPtls[i])];
                for (id object in superTable) {
                    if (![table containsObject:object]) {
                        [table addObject:object];
                    }
                }
            }
        }
    }
    return table;
}

- (NSMutableDictionary<NSString *, NSHashTable *> *)mapDic {
    if (!_mapDic) {
        _mapDic = [[NSMutableDictionary alloc] init];
    }
    return _mapDic;
}

@end
