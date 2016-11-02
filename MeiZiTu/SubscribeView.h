//
//  SubscribeView.h
//  MeiZiTu
//
//  Created by Vokie on 16/6/6.
//  Copyright © 2016年 Vokie. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ChooseBlock)(NSString *name, NSString *addr);

@interface SubscribeView : UIView
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@property (weak, nonatomic) IBOutlet UITextField *subNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *subTextField;

@property (weak, nonatomic) IBOutlet UIButton *subButton;

@property (weak, nonatomic) IBOutlet UITableView *subTableView;

@property (nonatomic, copy) ChooseBlock chooseBlock;
@end
