//
//  YLMatchRuleTool.m
//  YLMatchRuleDemo
//
//  Created by amber on 2019/3/27.
//

#import "YLMatchRuleTool.h"
#import <objc/runtime.h>

@interface YLMatchRuleTool()

@property (nonatomic, strong) NSMutableDictionary<NSString *, NSDictionary <NSString *,  NSString*> *> *mapDic;

@end

@implementation YLMatchRuleTool

+ (instancetype)sharedInstance {
    static YLMatchRuleTool *tool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [[YLMatchRuleTool alloc] init];
    });
    return tool;
}

- (void)addMethod:(SEL)method forKey:(NSString *)key protocol:(Protocol *)protocol {
    if (key.length == 0 || !method || !protocol) {
        return;
    }
    NSDictionary *current = self.mapDic[NSStringFromProtocol(protocol)];
    NSMutableDictionary *methods = nil;
    if (current) {
        methods = [[NSMutableDictionary alloc] initWithDictionary:current];
    } else {
        methods = [[NSMutableDictionary alloc] init];
    }
    [methods setValue:NSStringFromSelector(method) forKey:key];
    [self.mapDic setValue:methods forKey:NSStringFromProtocol(protocol)];
}

- (NSDictionary<NSString *, NSString *> *)getMatchMapTableForProtocol:(Protocol *)protocol {
    if (!protocol) {
        return nil;
    }
    return [self.mapDic objectForKey:NSStringFromProtocol(protocol)];
}

- (NSArray<NSString *> *)matchObject:(id<YLMatchRuleProtocol>)object
                              params:(NSDictionary<NSString *, id> *)params
                            protocol:(Protocol *)protocol {
    if (params.count == 0 || !object || !protocol) {
        return nil;
    }
    NSMutableArray *matchArray = [NSMutableArray array];
    if ([object respondsToSelector:@selector(mrp_matchType:)]) {
        NSArray<NSString *> *types = [object mrp_matchType:protocol];
        NSMutableDictionary *notMatchDic = [NSMutableDictionary dictionary];
        if (types.count > 0) {
            for (NSString *type in types) {
                id value = params[type];
                NSString *methodString = self.mapDic[NSStringFromProtocol(protocol)][type];
                SEL sel = NSSelectorFromString(methodString);
                if (!sel) {
                    continue;
                }
                BOOL isMatch = NO;
                Method method = class_getInstanceMethod([object class], sel);
                int argsCount = method_getNumberOfArguments(method);
                BOOL needMatch = NO;
                if (argsCount >= 2 && [object isKindOfClass:[NSObject class]]) {
                    NSMethodSignature *signature = [(NSObject *)object methodSignatureForSelector:sel];
                    if (signature) {
                        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
                        if (invocation) {
                            invocation.target = object;
                            invocation.selector = sel;
                            NSArray *keyValues = [type componentsSeparatedByString:@";"];
                            NSInteger index = 2;
                            for (NSString *key in keyValues) {
                                id paramValue = params[key];
                                [invocation setArgument:&paramValue atIndex:index];
                                index++;
                            }
                            [invocation invoke];
                            
                            const char *returnType = signature.methodReturnType;
                            id result = nil;
                            if(!strcmp(returnType, @encode(void))){
                                result = nil;
                            } else if(!strcmp(returnType, @encode(id)) ){
                                [invocation getReturnValue:&result];
                            } else {
                                void *buffer = (void *)malloc(signature.methodReturnLength);
                                [invocation getReturnValue:buffer];
                                if(!strcmp(returnType, @encode(BOOL))) {
                                    result = [NSNumber numberWithBool:*((BOOL*)buffer)];
                                } else {
                                    result = [NSValue valueWithBytes:buffer objCType:returnType];
                                }
                                free(buffer);
                            }
                            if ([result isKindOfClass:[NSString class]]) {
                                needMatch = YES;
                                NSString *current = (NSString *)result;
                                if ([value isEqualToString:current]) {
                                    isMatch = YES;
                                }
                            } else if ([result isKindOfClass:[NSNumber class]]) {
                                NSNumber *matchResult = (NSNumber *)result;
                                isMatch = [matchResult boolValue];
                            }
                        }
                    }
                }
                if (isMatch) {
                    [matchArray addObject:type];
                } else if (needMatch) {
                    [notMatchDic setValue:value forKey:type];
                }
            }
        }
        unsigned int protocolCount;
        Protocol * __unsafe_unretained *superPtls = protocol_copyProtocolList(protocol, &protocolCount);
        if (protocolCount > 0) {
            NSMutableArray *superMatchArray = [NSMutableArray array];
            for (int i=0; i< protocolCount; i++) {
                if (![@"NSObject" isEqualToString:NSStringFromProtocol(superPtls[i])]) {
                    NSArray *matchKeys = [self matchObject:object params:params protocol:superPtls[i]];
                    if (matchKeys.count > 0) {
                        //删除重复的 key 值
                        for (NSString *existKey in matchKeys) {
                            BOOL isExist = NO;
                            for (NSString *superKey in superMatchArray) {
                                if ([superKey isEqualToString:existKey]) {
                                    isExist = YES;
                                }
                            }
                            if (!isExist) {
                                [superMatchArray addObject:existKey];
                            }
                        }
                    }
                }
            }
            [matchArray addObjectsFromArray:superMatchArray];
        }
        NSLog(@"~~~~~~~~~~~~!!!!!!!:  %@",matchArray);
        return matchArray;
    }
    return nil;
}

+ (NSDictionary<NSString *, id> *)getJointParams:(id)object
                                          params:(NSDictionary<NSString *, id> *)params
                                        protocol:(Protocol *)protocol {
    if (!object || !protocol) {
        return nil;
    }
    NSDictionary *method_params = [[YLMatchRuleTool sharedInstance] getMatchMapTableForProtocol:protocol];
    if (method_params.count == 0) {
        return nil;
    }
    NSMutableDictionary *jointParams = [NSMutableDictionary dictionary];
    for (NSString *key in method_params.allKeys) {
        if ([object respondsToSelector:NSSelectorFromString(method_params[key])]) {
            id result = [[self class] getParamWithObject:object methodKey:key  method:method_params[key] params:params];
            [jointParams setValue:[result copy] forKey:key];
        }
    }
    return jointParams;
}

+ (id)getParamWithObject:(id)object
               methodKey:(NSString *)methodKey
                  method:(NSString *)methodString
                  params:(NSDictionary<NSString *, id> *)params {
    if (!object || methodString.length == 0) {
        return nil;
    }
    SEL sel = NSSelectorFromString(methodString);
    if (!sel) {
        return nil;
    }
    id __unsafe_unretained result = nil;
    NSMethodSignature *signature = [(NSObject *)object methodSignatureForSelector:sel];
    if (signature) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        if (invocation) {
            invocation.target = object;
            invocation.selector = sel;
            NSArray *keyValues = [methodKey componentsSeparatedByString:@";"];
            if (signature.numberOfArguments > 2) {
                NSInteger index = 2;
                for (NSString *key in keyValues) {
                    id paramValue = params[key];
                    [invocation setArgument:&paramValue atIndex:index];
                    index++;
                }
            }
            
            [invocation retainArguments];
            [invocation invoke];
            
            const char *returnType = signature.methodReturnType;
            if(!strcmp(returnType, @encode(void))){
                result = nil;
            } else if(!strcmp(returnType, @encode(id)) ){
                [invocation getReturnValue:&result];
            } else {
                void *buffer = (void *)malloc(signature.methodReturnLength);
                [invocation getReturnValue:buffer];
                if(!strcmp(returnType, @encode(BOOL))) {
                    result = [NSNumber numberWithBool:*((BOOL*)buffer)];
                } else if(!strcmp(returnType, @encode(id)) ){
                    [invocation getReturnValue:&result];
                } else {
                    result = [NSValue valueWithBytes:buffer objCType:returnType];
                }
                free(buffer);
            }
        }
    }
    return result;
}

- (NSMutableDictionary<NSString *, NSDictionary <NSString *,  NSString*> *> *)mapDic {
    if (!_mapDic) {
        _mapDic = [[NSMutableDictionary alloc] init];
    }
    return _mapDic;
}
@end
