//
//  VDSCOrderConfirmServices.h
//  iPadDragon
//
//  Created by vdsc on 4/4/13.
//  Copyright (c) 2013 VDSC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VDSCOrderConfirmServices : UIView<UITableViewDataSource, UITableViewDelegate>

@property (retain, nonatomic) IBOutlet UITableView *tabOrdersConfirmList;
@property (retain, nonatomic) IBOutlet UIView *otpView;
- (IBAction)btn_confirm_touch:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *btn_confirm;
@property (retain, nonatomic) IBOutlet UIView *view_confirm;

- (void)registerForKeyboardNotifications;
-(void)unregisterForKeyboardNotifications;
@end
