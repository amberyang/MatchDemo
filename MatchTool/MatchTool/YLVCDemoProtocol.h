//
//  YLVCDemoProtocol.h
//  MatchTool
//
//  Created by amber on 2021/1/28.
//

#import <Foundation/Foundation.h>
#import "YLMatchRuleProtocol.h"

@protocol YLVCDemoProtocol <YLMatchRuleProtocol>

- (NSString *)getString;

- (NSNumber *)getNumber;

- (CGPoint)getValue;

- (BOOL)getBOOL;

- (NSString *)getString:(NSString *)value;

- (NSNumber *)getNumber:(NSNumber *)value;

- (NSValue *)getValue:(NSValue *)value;


- (NSString *)getString:(NSString *)value string:(NSString *)value1;

- (NSNumber *)getNumber:(NSNumber *)value number:(NSNumber *)value1;

- (NSValue *)getValue:(NSValue *)value value:(NSValue *)value1;


@end
