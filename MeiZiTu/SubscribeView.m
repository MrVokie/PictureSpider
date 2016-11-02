//
//  SubscribeView.m
//  MeiZiTu
//
//  Created by Vokie on 16/6/6.
//  Copyright © 2016年 Vokie. All rights reserved.
//

#import "SubscribeView.h"
#import "DatabaseManager.h"
#import "MBProgressHUD+EasyUse.h"
#import <MJExtension.h>
#import "SubscribeModel.h"

@interface SubscribeView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) NSMutableArray *subArray;
@property (nonatomic, retain) SubscribeModel *editModel;  //编辑修改的Model模型
@property (nonatomic, retain) UIView *containerView;
@property (nonatomic, retain) UIView *editView;
@property (nonatomic, retain) UITextField *textField;
@property (nonatomic, retain) UITextField *siteTextField;
@property (nonatomic, retain) UIButton *doneButton;
@end

@implementation SubscribeView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT)];
        _containerView.backgroundColor = [UIColor darkGrayColor];
        _containerView.alpha = 0.7;
        [self addSubview:_containerView];
    }
    
    return _containerView;
}

- (UIView *)editView {
    if (!_editView) {
        _editView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH - 40, 250)];
        _editView.backgroundColor = UIColorMake(243, 243, 243);
        _editView.layer.cornerRadius = 5;
        _editView.layer.masksToBounds = YES;
        _editView.center = CGPointMake(APP_SCREEN_WIDTH / 2.0, APP_SCREEN_HEIGHT / 2.0 - 30);
        [self addSubview:_editView];
        
        //标题
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.text = @"编辑订阅内容";
        [_editView addSubview:titleLabel];
        titleLabel.font = [UIFont systemFontOfSize:22];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(_editView);
            make.top.equalTo(_editView).offset(25);
            make.height.mas_equalTo(30);
        }];
        
        //名称输入框
        UILabel *nameLabel = [[UILabel alloc]init];
        nameLabel.text = @"订阅名称:";
        [_editView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(_editView).offset(8);
            make.top.equalTo(titleLabel.mas_bottom).offset(25);
            make.width.mas_equalTo(85);
            make.height.mas_equalTo(35);
        }];
        self.textField = [[UITextField alloc]init];
        [_editView addSubview:self.textField];
        self.textField.backgroundColor = [UIColor whiteColor];
        self.textField.placeholder = @"请输入订阅名称";
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(nameLabel.mas_trailing);
            make.centerY.equalTo(nameLabel.mas_centerY);
            make.height.mas_equalTo(35);
            make.trailing.equalTo(_editView).offset(-8);
        }];
        
        //网址输入框
        UILabel *siteLabel = [[UILabel alloc]init];
        siteLabel.text = @"订阅网址:";
        [_editView addSubview:siteLabel];
        [siteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(_editView).offset(8);
            make.top.equalTo(nameLabel.mas_bottom).offset(20);
            make.width.mas_equalTo(85);
            make.height.mas_equalTo(35);
        }];
        self.siteTextField = [[UITextField alloc]init];
        [_editView addSubview:self.siteTextField];
        self.siteTextField.backgroundColor = [UIColor whiteColor];
        self.siteTextField.placeholder = @"请输入订阅网址";
        [self.siteTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(siteLabel.mas_trailing);
            make.centerY.equalTo(siteLabel.mas_centerY);
            make.height.mas_equalTo(35);
            make.trailing.equalTo(_editView).offset(-8);
        }];
        
        self.doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.doneButton setTitle:@"确定" forState:UIControlStateNormal];
        [self.doneButton setBackgroundColor:COLOR_THEME];
        [_editView addSubview:self.doneButton];
        [self.doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(siteLabel.mas_bottom).offset(30);
            make.bottom.leading.trailing.equalTo(_editView);
        }];
        
        [self.doneButton addTarget:self action:@selector(doneButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editView;
    
}

//编辑订阅内容后的完成回调
- (void)doneButtonClicked:(id)sender {
    
    if (!self.textField.text.length) {
        [MBProgressHUD showWithText:@"订阅名称没有填写"];
        return;
    }
    
    if (!self.siteTextField.text.length) {
        [MBProgressHUD showWithText:@"网址链接没有填写"];
        return;
    }
    
    self.editModel.name = self.textField.text;
    self.editModel.address = self.siteTextField.text;

    [self.editModel sqlUpdate];
    
    self.textField.text = @"";
    self.siteTextField.text = @"";
    
    self.subArray = [SubscribeModel mj_objectArrayWithKeyValuesArray:[[DatabaseManager sharedManager] getSubscribeData]];
    [self.subTableView reloadData];
    
    [self.containerView removeFromSuperview];
    self.containerView = nil;
    
    [self.editView removeFromSuperview];
    self.editView = nil;
}

//订阅按钮事件回调
- (IBAction)subButtonClicked:(id)sender {
    if (!self.subNameTextField.text.length) {
        [MBProgressHUD showWithText:@"订阅名称没有填写"];
        return;
    }
    
    if (!self.subTextField.text.length) {
        [MBProgressHUD showWithText:@"网址链接没有填写"];
        return;
    }
    
    SubscribeModel *model = [[SubscribeModel alloc]init];
    model.name = self.subNameTextField.text;
    model.address = self.subTextField.text;
    model.admin = @"0";
    
    self.subNameTextField.text = @"";
    self.subTextField.text = @"";
    
    [self.subTextField resignFirstResponder];
    [self.subNameTextField resignFirstResponder];
    
    [model sqlInsert];
    
    self.subArray = [SubscribeModel mj_objectArrayWithKeyValuesArray:[[DatabaseManager sharedManager] getSubscribeData]];
    
    [self.subTableView reloadData];
    
    
}
- (IBAction)closeButtonClicked:(id)sender {
    [self closeSubscribeView];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.subArray = [SubscribeModel mj_objectArrayWithKeyValuesArray:[[DatabaseManager sharedManager] getSubscribeData]];
    NSLog(@"%@", self.subArray);
    self.subTableView.delegate = self;
    self.subTableView.dataSource = self;
    self.subTableView.rowHeight = 55;
    
    [self.subTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Default_Cell"];
    self.subTableView.tableFooterView = [[UIView alloc]init];
    
    self.closeButton.layer.cornerRadius = 5;
    self.closeButton.layer.masksToBounds = YES;
    
    self.subButton.layer.cornerRadius = 5;
    self.subButton.layer.masksToBounds = YES;
    
    self.subNameTextField.layer.cornerRadius = 5;
    self.subNameTextField.layer.masksToBounds = YES;
    
    self.subTextField.layer.cornerRadius = 5;
    self.subTextField.layer.masksToBounds = YES;
}

#pragma mark - UITableView Delegate/DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.subArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Default_Cell" forIndexPath:indexPath];
    SubscribeModel *model = (SubscribeModel *)self.subArray[indexPath.row];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = model.name;
//    cell.textLabel.font = [UIFont systemFontOfSize:14];
    NSInteger admin = [model.admin integerValue];
    if (admin) {
        cell.textLabel.textColor = [UIColor lightGrayColor];
    }else{
        cell.textLabel.textColor = [UIColor darkGrayColor];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SubscribeModel *model = (SubscribeModel *)self.subArray[indexPath.row];
    if (self.chooseBlock) {
        self.chooseBlock(model.name, model.address);
    }
    [self closeSubscribeView];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    SubscribeModel *model = (SubscribeModel *)self.subArray[indexPath.row];
    NSInteger admin = [model.admin integerValue];
    
    return admin == 0; //用户自定义的可以滑动删除
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //设置删除按钮
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction *action,NSIndexPath *indexPath) {
        SubscribeModel *model = (SubscribeModel *)self.subArray[indexPath.row];
        
        [model sqlDelete];
        [self.subArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath]withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }];
    
    //设置编辑按钮
    UITableViewRowAction *collectRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"编辑" handler:^(UITableViewRowAction *action,NSIndexPath *indexPath) {
        SubscribeModel *model = (SubscribeModel *)self.subArray[indexPath.row];
        
        self.containerView.hidden = NO;
        self.editView.hidden = NO;
        
        self.textField.text = model.name;
        self.siteTextField.text = model.address;
        self.editModel = model;
        
    }];
    
    deleteRowAction.backgroundColor = UIColorMake(220, 60, 60);
    
    collectRowAction.backgroundColor = [UIColor grayColor];
    
    return  @[deleteRowAction,collectRowAction];
}

- (void)closeSubscribeView {
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        CGRect rect = CGRectMake(-APP_SCREEN_WIDTH, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT);
        self.frame = rect;
    } completion:^(BOOL finished) {
        
    }];
}

@end
