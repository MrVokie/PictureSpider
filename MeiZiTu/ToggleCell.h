//
//  ToggleCell.h
//  MeiZiTu
//
//  Created by Vokie on 2016/11/2.
//  Copyright © 2016年 Vokie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToggleCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleTextLabel;
@property (weak, nonatomic) IBOutlet UISwitch *toggleButton;
@end
