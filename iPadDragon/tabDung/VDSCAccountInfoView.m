//
//  VDSCAccountInfoView.m
//  iPadDragon
//
//  Created by vdsc on 1/5/13.
//  Copyright (c) 2013 VDSC. All rights reserved.
//

#import "VDSCAccountInfoView.h"
#import "VDSCCommonUtils.h"
#import "VDSCOnlineCashTransferViewController.h"
#import "VDSCSMSRegisterViewController.h"
#import "VDSCChangeAccountInfoViewController.h"
#import "VDSCMarketIndexView.h"
#import "VDSCPush2DateListViewController.h"
#import "VDSCMainViewController.h"

@implementation VDSCAccountInfoView
{
    VDSCCommonUtils *utils;
    VDSCSMSRegisterViewController *popoverView_sms;
    UIPopoverController *popoverController;
    
}
@synthesize popover_sms;
@synthesize popover_changeInfo;
@synthesize activeField;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void) awakeFromNib
{
    [super awakeFromNib];
    
    utils = [[VDSCCommonUtils alloc] init];
    
    ((VDSCMainViewController*)self.delegate).activeView = self;
    [self performSelectorInBackground:@selector(loadClientInfo) withObject:nil];
    //[self loadClientInfo];
    [self registerForKeyboardNotifications];
    self.txt_currPass.delegate=self;
    self.txt_newPass.delegate=self;
    self.txt_newPass_again.delegate = self;
    
    VDSCMarketIndexView *marketIndex = [[[NSBundle mainBundle] loadNibNamed:@"VDSCMarketIndexView" owner:self options:nil] objectAtIndex:0];
    marketIndex.delegate = self;
    [self.marketInfo addSubview:marketIndex];
    [self.view_agent setHidden:YES];
}

- (IBAction)btn_agent_touch:(id)sender {
    @try{
    if(![self.array_agent isEqual:[NSNull null]] && self.array_agent.count>0){
    VDSCPush2DateListViewController *popover_Vew = [[self.superview.window.rootViewController storyboard] instantiateViewControllerWithIdentifier:@"Push2DateList"];
    popover_Vew.delegate = self;
    popover_Vew.array_agent = self.array_agent;
    UIPopoverController *popover = [[[UIPopoverController alloc] initWithContentViewController:popover_Vew] autorelease];
    CGRect rect=((UIButton*)sender).frame;
    rect.origin.y = rect.origin.y+90;
    [popover presentPopoverFromRect:rect inView:self permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    }
    }
    @catch (NSException *ex) {
        NSLog(@"Uncaught exception: %@", ex.description);NSLog(@"Stack trace: %@", [ex callStackSymbols]);
    }
}
-(void)setData2Controls:(NSArray*)agent
{
    [self.btn_agent setTitle:[agent objectAtIndex:0] forState:UIControlStateNormal];
    self.f_agent_content.text=[agent objectAtIndex:7];
    self.f_agent_cardId.text=[[agent objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.f_agent_issueDate.text=[agent objectAtIndex:2];
    self.f_agent_address.text=[agent objectAtIndex:3];
    self.f_agent_email.text=[agent objectAtIndex:9];
    self.f_agent_phone.text=[agent objectAtIndex:4];
}

-(void) loadClientInfo
{
    @try{
    NSArray *arr = [[NSArray alloc] initWithObjects:@"KW_CLIENTSECRET",utils.clientInfo.secret, @"KW_CLIENTID", utils.clientInfo.clientID, nil];
    NSString *post = [utils postValueBuilder:arr];
    
    NSString *url = [[NSUserDefaults standardUserDefaults] stringForKey:@"clientInfo"];
    NSDictionary *allDataDictionary = [utils getDataFromUrl:url method:@"POST" postData:post];
    NSArray *personal = [allDataDictionary objectForKey:@"personal"];
    utils.clientInfo.idCard = [personal objectAtIndex:2];
    utils.clientInfo.isuseDate = [personal objectAtIndex:3];
    utils.clientInfo.address = [personal objectAtIndex:4];
    utils.clientInfo.email = [personal objectAtIndex:8];
    utils.clientInfo.phone = [personal objectAtIndex:6];
    utils.clientInfo.OTPNumber = [personal objectAtIndex:5];
    
    self.f_clientid.text = [NSString stringWithFormat:@"033%@", utils.clientInfo.clientID];
    self.f_name.text = utils.clientInfo.clientName;
    self.f_idcard.text = utils.clientInfo.idCard;
    self.f_isueDate.text = utils.clientInfo.isuseDate;
    self.f_address.text = utils.clientInfo.address;
    [self.btn_email setTitle: utils.clientInfo.email forState:UIControlStateNormal];
    [self.btn_phone setTitle: utils.clientInfo.phone forState:UIControlStateNormal];
    
    NSArray *broker = [allDataDictionary objectForKey:@"broker"];
    self.f_broker_idNumber.text = [broker objectAtIndex:0];
    self.f_broker_openDate.text = [broker objectAtIndex:1];
    self.f_broker_Name.text = [broker objectAtIndex:2];
    self.f_broker_cellPhone.text = [broker objectAtIndex:3];
    self.f_broker_phone.text = [broker objectAtIndex:4];
    self.f_broker_email.text = [broker objectAtIndex:5];
    [self.btn_SMS setTitle:[personal objectAtIndex:10] forState:UIControlStateNormal];
    if([[personal objectAtIndex:10] isEqual:@""])
       [self.btn_SMS setTitle:@"Chưa đăng ký" forState:UIControlStateNormal];
    
    if([[personal objectAtIndex:9] boolValue])
    {
        self.f_callCenter.text = @"Đã đăng ký";
    }
    else{
        self.f_callCenter.text = @"";
    }
    
    self.f_idragonNumber.text = utils.clientInfo.OTPNumber;
    if(![self.f_idragonNumber.text isEqualToString:@""])
        self.f_idragon.text=@"Đã đăng ký";
    else
        self.f_idragon.text=@"";
    
    if([utils.clientInfo.accountType isEqualToString:@"M"])
        self.f_margin.text = @"Đã đăng ký";
    else
        self.f_margin.text = @"";
    
    NSDictionary *tranfer = [allDataDictionary objectForKey:@"transfer"];
    if(![tranfer isEqual:[NSNull null]])
    {
        [self.btn_onlineTrangfer setTitle:@"Đã đăng ký" forState:UIControlStateNormal];
    }
    else{[self.btn_onlineTrangfer setTitle:@"" forState:UIControlStateNormal];}
    
    NSArray *agent = [allDataDictionary objectForKey:@"agent"];
    self.array_agent = [[[NSMutableArray alloc] init] autorelease];
    if(![agent isEqual:[NSNull null]])
    {
        for(NSArray *array in agent)
            [self.array_agent addObject:array];
    }
        [arr release];
    }
    @catch (NSException *ex) {
        NSLog(@"Uncaught exception: %@", ex.description);NSLog(@"Stack trace: %@", [ex callStackSymbols]);
    }
}
    


- (void)dealloc {
    [_marketInfo release];
    if(popoverController!=nil)
       [popoverController release];
    [utils release];
    if(popover_sms !=nil)
    [popover_sms release];
    [_f_name release];
    [_f_clientid release];
    [_f_idcard release];
    [_f_isueDate release];
    [_f_address release];
    [_btn_email release];
    [_btn_phone release];
    [_f_broker_idNumber release];
    [_f_broker_openDate release];
    [_f_broker_Name release];
    [_f_broker_phone release];
    [_f_broker_cellPhone release];
    [_f_broker_email release];
    [_f_callCenter release];
    [_f_idragon release];
    [_f_idragonNumber release];
    [_f_margin release];
    [_btn_SMS release];
    [_btn_onlineTrangfer release];
    [_txt_currPass release];
    [_txt_newPass release];
    [_txt_newPass_again release];
    [self unregisterForKeyboardNotifications];
    [_btn_agent release];
    [_f_agent_content release];
    [_f_agent_cardId release];
    [_f_agent_issueDate release];
    [_f_agent_address release];
    [_view_agent release];
    [_btn_chuTK release];
    [_f_hearderColor release];
    [_btn_tkUQ release];
    [super dealloc];
}
 
- (IBAction)btn_onlineTranfer_touch:(id)sender {
    VDSCOnlineCashTransferViewController *popover_Vew = [[self.superview.window.rootViewController storyboard] instantiateViewControllerWithIdentifier:@"onlineCashTransferList"];
    popoverController = [[UIPopoverController alloc] initWithContentViewController:popover_Vew];
    //popover.delegate = self;
    CGRect rect=((UIButton*)sender).frame;
    [popoverController presentPopoverFromRect:rect inView:self permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)btn_sms_touch:(id)sender {
    @try{
    //if(popoverView_sms==nil)
    popoverView_sms = [[self.superview.window.rootViewController storyboard] instantiateViewControllerWithIdentifier:@"SMSRegister"];
    popover_sms = [[UIPopoverController alloc] initWithContentViewController:popoverView_sms];
    popoverView_sms.delegate = self;
    CGRect rect=((UIButton*)sender).frame;
    [popover_sms presentPopoverFromRect:rect inView:self permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    //[popoverView_sms release];
    //popoverView_sms=nil;
        
    }
    @catch (NSException *ex) {
        NSLog(@"Uncaught exception: %@", ex.description);NSLog(@"Stack trace: %@", [ex callStackSymbols]);
    }
}

- (IBAction)btn_accountChange:(id)sender {
    @try{
    VDSCChangeAccountInfoViewController *popover_Vew = [[self.superview.window.rootViewController storyboard] instantiateViewControllerWithIdentifier:@"ChangeAccountInfo"];
    popover_changeInfo = [[UIPopoverController alloc] initWithContentViewController:popover_Vew];
    popover_Vew.delegate = self;
    CGRect rect=((UIButton*)sender).frame;
    popover_Vew.txt_sdt.text = self.btn_phone.titleLabel.text;
    
    popover_Vew.txt_email.text = self.btn_email.titleLabel.text;
        [popover_changeInfo presentPopoverFromRect:rect inView:self permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    @catch (NSException *ex) {
        NSLog(@"Uncaught exception: %@", ex.description);NSLog(@"Stack trace: %@", [ex callStackSymbols]);
    }
}
- (IBAction)btn_updatePass_touch:(id)sender {
    if([self checkInput]){
        NSArray *arr;
        NSDictionary *allDataDictionary;
        @try {
            
            arr = [[NSArray alloc] initWithObjects:@"KW_CLIENTSECRET",utils.clientInfo.secret
                   , @"KW_CLIENTID", utils.clientInfo.clientID
                   , @"KW_CLIENTCURPWD",self.txt_currPass.text
                   , @"KW_CLIENTNEWPWD",self.txt_newPass.text
                   ,nil];
            NSString *post = [utils postValueBuilder:arr];
            
            NSString *url = [[NSUserDefaults standardUserDefaults] stringForKey:@"tabChangePwd"];
            allDataDictionary = [utils getDataFromUrl:url method:@"POST" postData:post];
            
            if([[allDataDictionary objectForKey:@"success"] boolValue])
            {
                self.txt_newPass.text=self.txt_newPass_again.text=self.txt_currPass.text=@"";
                [utils showMessage:[utils.dic_language objectForKey:@"ipad.accountInfo.changeOk"] messageContent:nil];
                //[account.popover_sms dismissPopoverAnimated:YES];
            }
            else
            {
                [utils showMessage:@"Mật khẩu hiện tại không chính xác. Quý khách vui lòng thử lại" messageContent:nil];
                //[otp resetOtpPosition];
            }
        }
        @catch (NSException *exception) {
            NSLog(exception.description);
        }
        @finally {
            
            if(allDataDictionary!=nil)
                [allDataDictionary release];
            if(arr !=nil)
                [arr release];
        }
    }
}

- (IBAction)btn_chuTK_touch:(id)sender {
    [self.view_agent setHidden:YES];
    [self.btn_tkUQ setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [(UIButton*)sender setTitleColor:self.f_hearderColor.textColor forState:UIControlStateNormal];
}

- (IBAction)btn_nguoiUQ_touch:(id)sender {
    [self.view_agent setHidden:NO];
    [self.btn_chuTK setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [(UIButton*)sender setTitleColor:self.f_hearderColor.textColor forState:UIControlStateNormal];
}
-(BOOL)checkInput
{
    NSString *message=@"";
    if(self.txt_currPass.text.length==0)
        message=[utils.dic_language objectForKey:@"ipad.accountInfo.currentBlankPwd"];
    else  if(self.txt_newPass.text.length<8 || self.txt_newPass.text.length>30)
        message=[utils.dic_language objectForKey:@"ipad.accountInfo.rangePwdLength"];
    //else  if(self.txt_newPass_again.text.length==0)
    //    message=@"";
    else if(![self.txt_newPass.text isEqualToString:self.txt_newPass_again.text])
        message=[utils.dic_language objectForKey:@"ipad.accountInfo.wrongNewPwd"];
    if(message.length!=0)
      [ utils showMessage:message messageContent:nil];
    return message.length==0;
}
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.txt_currPass resignFirstResponder];
    [self.txt_newPass resignFirstResponder];
    [self.txt_newPass_again resignFirstResponder];
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}
-(void)unregisterForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)keyboardWillShown:(NSNotification*)aNotification
{
    if(activeField!=nil)
    {
    [UIView beginAnimations:@"nove" context:NULL];
    [UIView setAnimationDuration:0.25];
    //[self bringSubviewToFront:self.view_confirm];
    self.frame= CGRectMake(self.frame.origin.x, self.frame.origin.y-120, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    if(activeField !=nil)
    {
    [UIView beginAnimations:@"nove" context:NULL];
    [UIView setAnimationDuration:0.25];
    //[self bringSubviewToFront:self.view_confirm];
    self.frame= CGRectMake(self.frame.origin.x, self.frame.origin.y+120, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    }
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = [textField retain];
}

@end
