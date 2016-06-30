//
//  MBProgressHUD+EasyUse.m
//  MeiZiTu
//
//  Created by Vokie on 16/6/3.
//  Copyright © 2016年 Vokie. All rights reserved.
//

#import "MBProgressHUD+EasyUse.h"

@implementation MBProgressHUD (EasyUse)

+ (void)showWithText:(NSString *)text {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
    
    hud.labelText = text;
    hud.mode = MBProgressHUDModeText;
    [hud hide:YES afterDelay:2.0f];
    hud.userInteractionEnabled = NO;
}

@end
