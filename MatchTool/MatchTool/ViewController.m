//
//  ViewController.m
//  MatchTool
//
//  Created by amber on 2021/1/27.
//

#import "ViewController.h"
#import "YLMatchManager.h"
#import "YLVCDemoProtocol.h"
#import "YLMatchRuleTool.h"
#import "DetailViewController.h"

@interface ViewController ()<YLVCDemoProtocol>

@end

@implementation ViewController

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [YLMatchManager addMethod:@selector(getString) forKey:@"string_no_param" protocol:@protocol(YLVCDemoProtocol)];
        [YLMatchManager addMethod:@selector(getNumber) forKey:@"number_no_param" protocol:@protocol(YLVCDemoProtocol)];
        [YLMatchManager addMethod:@selector(getBOOL) forKey:@"bool_no_param" protocol:@protocol(YLVCDemoProtocol)];
        [YLMatchManager addMethod:@selector(getValue) forKey:@"value_no_param" protocol:@protocol(YLVCDemoProtocol)];
        [YLMatchManager addMethod:@selector(getString:) forKey:@"string_param" protocol:@protocol(YLVCDemoProtocol)];
        [YLMatchManager addMethod:@selector(getNumber:) forKey:@"number_param" protocol:@protocol(YLVCDemoProtocol)];
        [YLMatchManager addMethod:@selector(getValue:) forKey:@"value_param" protocol:@protocol(YLVCDemoProtocol)];
        [YLMatchManager addMethod:@selector(getString:string:) forKey:@"string_param;string_param_1" protocol:@protocol(YLVCDemoProtocol)];
        [YLMatchManager addMethod:@selector(getNumber:number:) forKey:@"number_param;number_param_1" protocol:@protocol(YLVCDemoProtocol)];
        [YLMatchManager addMethod:@selector(getValue:value:) forKey:@"value_param:value_param_1" protocol:@protocol(YLVCDemoProtocol)];
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [YLMatchManager addObject:self protocol:@protocol(YLVCDemoProtocol)];
    
    self.navigationItem.title = NSStringFromClass([self class]);
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, 150, 200, 50)];
    [button setBackgroundColor:[UIColor lightGrayColor]];
    [button setTitle:@"进入下一页面" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showDetail) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)showDetail {
    DetailViewController *detail = [DetailViewController new];
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark ----- protocol

- (NSArray *)mrp_matchType:(Protocol *)protocol {
    if ([NSStringFromProtocol(protocol) isEqualToString:@"YLVCDemoProtocol"]) {
        return @[@"string_no_param",@"number_no_param",@"bool_no_param",
                 @"string_param",@"number_param",
                 @"string_param;string_param_1",@"number_param;number_param_1"];
    }
    return nil;
}

/**
 匹配成功后的行为
 
 @param protocol 匹配成功的协议
 @param types 匹配成功的 key 值
 @return 是否需要进行默认处理，yes，由 ruletool 进行默认关闭处理，no，则不进行处理
 */
- (BOOL)mrp_matchAction:(Protocol *)protocol type:(NSArray<NSString *> *)types {
    return NO;
}

- (NSString *)getString {
    return [NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)];
}

- (NSString *)getString:(NSString *)value {
    return [NSString stringWithFormat:@"%@_%@",NSStringFromSelector(_cmd),value];
}

- (NSString *)getString:(NSString *)value string:(NSString *)value1 {
    return [NSString stringWithFormat:@"%@_%@_%@",NSStringFromSelector(_cmd),value,value1];
}

- (NSNumber *)getNumber {
    return @(2);
}

- (NSNumber *)getNumber:(NSNumber *)number {
    return number;
}

- (NSNumber *)getNumber:(NSNumber *)number number:(NSNumber *)value1 {
    return @(number.integerValue + value1.integerValue);
}

- (BOOL)getBOOL {
    return 0;
}

- (CGPoint)getValue {
    return CGPointMake(1, 1);
}

- (NSValue *)getValue:(NSValue *)value {
    return value;
}

- (NSValue *)getValue:(NSValue *)value value:(NSValue *)value1 {
    return value1;
}

@end
