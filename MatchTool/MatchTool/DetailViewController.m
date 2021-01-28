//
//  DetailViewController.m
//  MatchTool
//
//  Created by amber on 2021/1/28.
//

#import "DetailViewController.h"
#import "YLMatchManager.h"
#import "YLVCDemoProtocol.h"
#import "YLMatchRuleTool.h"
#import "YLMatchObjectManager.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = NSStringFromClass([self class]);
        
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(50, 150, CGRectGetWidth(self.view.frame)-100, 50)];
    [button setBackgroundColor:[UIColor lightGrayColor]];
    [button setTitle:@"获取 ViewController 数据" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showParams) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 250, CGRectGetWidth(self.view.frame)-100, 300)];
    [label setNumberOfLines:0];
    label.tag = 1111;
    [label setBackgroundColor:[UIColor systemBlueColor]];
    [self.view addSubview:label];
}


- (void)showParams {
    UIView *aView = [self.view viewWithTag:1111];
    if ([aView isKindOfClass:[UILabel class]]) {
        UILabel *label = (UILabel *)aView;
        //可通过其他方式获取对象，此处只是简单处理，找到第一个对象进行数据输出，实际场景需要根据自己的业务处理
        NSHashTable *table =  [[YLMatchObjectManager sharedInstance] getObjectsForProtocol:@protocol(YLVCDemoProtocol)];
        for (id object in table) {
            NSDictionary *dic = [YLMatchRuleTool getJointParams:object params:@{@"string_param":@"1",@"number_param":@(3),@"bool_param":@(YES),@"value_param":[NSValue valueWithCGRect:CGRectMake(0, 0, 100, 100)],@"string_param_1":@"2",@"number_param_1":@(4),@"value_param_1":[NSValue valueWithRange:NSMakeRange(0, 10)]} protocol:@protocol(YLVCDemoProtocol)];
            NSString *value = @"\n";
            for (NSString *key in dic.allKeys) {
                value = [value stringByAppendingString:[NSString stringWithFormat:@"%@ : %@\n\n",key, dic[key]]];
            }
            value = [value substringToIndex:value.length-1];
            [label setText:value];
            CGSize size = [label sizeThatFits:CGSizeMake(CGRectGetWidth(label.frame), CGFLOAT_MAX)];
            [label setFrame:CGRectMake(CGRectGetMinX(label.frame), CGRectGetMinY(label.frame), CGRectGetWidth(label.frame), MAX(CGRectGetHeight(label.frame), size.height))];
            break;
        }
    }
}

@end
