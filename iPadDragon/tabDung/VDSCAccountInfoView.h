//
//  VDSCAccountInfoView.h
//  iPadDragon
//
//  Created by vdsc on 1/5/13.
//  Copyright (c) 2013 VDSC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VDSCAccountInfoView : UIView<UITextFieldDelegate>
@property (retain, nonatomic) IBOutlet UIView *marketInfo;
@property (retain, nonatomic) IBOutlet UILabel *f_name;
@property (retain, nonatomic) IBOutlet UILabel *f_clientid;
@property (retain, nonatomic) IBOutlet UILabel *f_idcard;
@property (retain, nonatomic) IBOutlet UILabel *f_isueDate;
@property (retain, nonatomic) IBOutlet UILabel *f_address;
@property (retain, nonatomic) IBOutlet UIButton *btn_email;
@property (retain, nonatomic) IBOutlet UIButton *btn_phone;
@property (retain, nonatomic) IBOutlet UILabel *f_broker_idNumber;
@property (retain, nonatomic) IBOutlet UILabel *f_broker_openDate;
@property (retain, nonatomic) IBOutlet UILabel *f_broker_Name;
@property (retain, nonatomic) IBOutlet UILabel *f_broker_phone;
@property (retain, nonatomic) IBOutlet UILabel *f_broker_cellPhone;
@property (retain, nonatomic) IBOutlet UILabel *f_broker_email;
@property (retain, nonatomic) IBOutlet UILabel *f_callCenter;
@property (retain, nonatomic) IBOutlet UILabel *f_idragon;
@property (retain, nonatomic) IBOutlet UILabel *f_idragonNumber;
@property (retain, nonatomic) IBOutlet UILabel *f_margin;
@property (retain, nonatomic) IBOutlet UIButton *btn_SMS;
@property (retain, nonatomic) IBOutlet UIButton *btn_onlineTrangfer;
- (IBAction)btn_onlineTranfer_touch:(id)sender;
- (IBAction)btn_sms_touch:(id)sender;
- (IBAction)btn_accountChange:(id)sender;
@property (strong, nonatomic) UIPopoverController *popover_sms;
@property (strong, nonatomic) UIPopoverController *popover_changeInfo;
@property (retain, nonatomic) IBOutlet UITextField *txt_currPass;
@property (retain, nonatomic) IBOutlet UITextField *txt_newPass;
@property (retain, nonatomic) IBOutlet UITextField *txt_newPass_again;
@property (retain, nonatomic) IBOutlet UITextField *activeField;
- (IBAction)btn_updatePass_touch:(id)sender;
- (IBAction)btn_chuTK_touch:(id)sender;
- (IBAction)btn_nguoiUQ_touch:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *btn_agent;
- (IBAction)btn_agent_touch:(id)sender;
-(void)setData2Controls:(NSArray*)agent;
@property (retain, nonatomic) IBOutlet UILabel *f_agent_content;
@property (retain, nonatomic) IBOutlet UILabel *f_agent_cardId;
@property (retain, nonatomic) IBOutlet UILabel *f_agent_issueDate;
@property (retain, nonatomic) IBOutlet UILabel *f_agent_address;
@property (retain, nonatomic) IBOutlet UILabel *f_agent_email;
@property (retain, nonatomic) IBOutlet UILabel *f_agent_phone;
@property (retain, nonatomic) IBOutlet UIButton *btn_tkUQ;

@property (strong, nonatomic) NSMutableArray *array_agent;
@property (retain, nonatomic) IBOutlet UIView *view_agent;
@property (retain, nonatomic) IBOutlet UILabel *f_hearderColor;
@property (retain, nonatomic) IBOutlet UIButton *btn_chuTK;
@property (strong, nonatomic) id delegate;

- (void)registerForKeyboardNotifications;
-(void)unregisterForKeyboardNotifications;
-(void) loadClientInfo;
@end
