//
//  SettingViewController.m
//  MeiZiTu
//
//  Created by Vokie on 16/6/3.
//  Copyright © 2016年 Vokie. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingCell.h"
#import <SDImageCache.h>
#import "MBProgressHUD+EasyUse.h"
#import "HTTPSessionManager.h"
#import "ToggleCell.h"
#import "AppDefault.h"

@interface SettingViewController ()<UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (nonatomic, retain) NSArray *settingArray;
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"设置";
    
    [self initDataArray];
    
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    
    self.mTableView.tableFooterView = [[UIView alloc]init];
    
    self.mTableView.rowHeight = 55;
    [self.mTableView registerNib:[UINib nibWithNibName:@"SettingCell" bundle:nil] forCellReuseIdentifier:@"Setting_Cell"];
    [self.mTableView registerNib:[UINib nibWithNibName:@"ToggleCell" bundle:nil] forCellReuseIdentifier:@"Toggle_Cell"];
}

- (void)initDataArray {
    self.settingArray = nil;
    
    NSString *size = [self fileSizeWithByte:[[SDImageCache sharedImageCache]getSize]];
    
    NSString *uaString = @"手机站点";
    
    if ([AppDefault sharedManager].ua) {
        uaString = @"电脑站点";
    }
    self.settingArray = @[@{@"id":@"1021", @"name":@"无数据时自动跳过", @"value":@"0"},
                          @{@"id":@"1023", @"name":@"神隐切换", @"value":uaString},
                          @{@"id":@"1009", @"name":@"数据缓存", @"value":size},
                          @{@"id":@"1032", @"name":@"反馈", @"value":@"提提建议"},
                          @{@"id":@"1058", @"name":@"关于", @"value":@"了解更多"}];
}

- (NSString *)fileSizeWithByte:(NSInteger)size{
    if (size < 1024) {// 小于1k
        return [NSString stringWithFormat:@"%ldB",(long)size];
    }else if (size < 1024 * 1024){// 小于1m
        CGFloat convertSize = size/1024.0f;
        return [NSString stringWithFormat:@"%.1fK",convertSize];
    }else if (size < 1024 * 1024 * 1024){// 小于1G
        CGFloat convertSize = size/(1024.0f * 1024.0f);
        return [NSString stringWithFormat:@"%.1fM",convertSize];
    }else{
        CGFloat convertSize = size/(1024.0f*1024.0f*1024.0f);
        return [NSString stringWithFormat:@"%.1fG",convertSize];
    }
}

- (void)toggleEvent:(id)sender {
    UISwitch *toggleButton = sender;
    BOOL flag = toggleButton.isOn;
    [AppDefault sharedManager].autoLoadMore = flag;
    [[NSUserDefaults standardUserDefaults] setBool:flag forKey:@"autoLoadMore"];
}

#pragma mark - UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.settingArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        ToggleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Toggle_Cell" forIndexPath:indexPath];
        cell.titleTextLabel.text = self.settingArray[indexPath.row][@"name"];
        cell.toggleButton.on = [AppDefault sharedManager].autoLoadMore;
        [cell.toggleButton addTarget:self action:@selector(toggleEvent:) forControlEvents:UIControlEventValueChanged];
        return cell;
    }else{
        SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Setting_Cell" forIndexPath:indexPath];
        cell.leftLabel.text = self.settingArray[indexPath.row][@"name"];
        cell.rightLabel.text = self.settingArray[indexPath.row][@"value"];
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger rid = [self.settingArray[indexPath.row][@"id"] integerValue];
    switch (rid) {
        case 1009: {
            [MBProgressHUD showWithText:@"清理中..."];
            [[SDImageCache sharedImageCache]clearDiskOnCompletion:^{
                [MBProgressHUD showWithText:@"清理完成"];
                [self initDataArray];
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }];
            break;
            
        }case 1023: {
            UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"神隐切换" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"网页", @"手机", nil];
            [sheet showInView:self.view];
            break;
            
        }default:
            [MBProgressHUD showWithText:@"暂未开发"];
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - ActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@">>%ld", buttonIndex);
    if (buttonIndex == 0) {
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"ua"];
        [AppDefault sharedManager].ua = YES;
        [[HTTPSessionManager sharedManager] switchUserAgentToPC:YES];
        [MBProgressHUD showWithText:@"切换完成"];
    }else if (buttonIndex == 1) {
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"ua"];
        [AppDefault sharedManager].ua = NO;
        [[HTTPSessionManager sharedManager] switchUserAgentToPC:NO];
        [MBProgressHUD showWithText:@"切换完成"];
    }
    
    [self initDataArray];
    
    [self.mTableView reloadData];
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
