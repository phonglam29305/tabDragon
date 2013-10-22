//
//  VDSCViewController.m
//  iPadDragon
//
//  Created by vdsc on 12/24/12.
//  Copyright (c) 2012 VDSC. All rights reserved.
//

#import "VDSCViewController.h"
#import "VDSCMainViewController.h"
#import "VDSCCommonUtils.h"
#import "ASIFormDataRequest.h"
#import "VDSCNewsEntity.h"
#import "VDSCNewsItemViewController.h"
#import "VDSCSystemParams.h"


@implementation VDSCViewController
{
    VDSCCommonUtils *utils;
    VDSCMainViewController *main;
    NSOperationQueue *queue;
    UIWebView *loading;
    VDSCSystemParams *params;
}

@synthesize loginButton=_loginButton;
@synthesize viewBackground;
@synthesize loginView;
@synthesize fieldMaTK;
@synthesize fieldMaBaoVe;
@synthesize fieldMatKhau;
@synthesize webData;
@synthesize array;
@synthesize scrollView;
@synthesize capcha;
@synthesize btnLogin;
@synthesize activeField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
- (void)resetDefaults {
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    NSDictionary * dict = [defs dictionaryRepresentation];
    for (id key in dict) {
        [defs removeObjectForKey:key];
    }
    [defs synchronize];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    //NSString *onlineServer = @"http://192.168.2.29/iDragonV3_IPAD";
    //NSString *onlineServer = @"http://192.168.2.18/iDragonV3_HOSE";
    NSString *onlineServer = @"https://idragon.vdsc.com.vn";
    NSString *priceBoardServer = @"http://price2.vdsc.com.vn/ipad";
    //NSString *priceBoardServer = @"http://172.16.1.19/ipad";
    //priceboard
    [user setObject:[NSString stringWithFormat:@"%@%@",priceBoardServer,@"/stockInfo.jsp?code=%@"] forKey:@"stock_info"];
    [user setObject:[NSString stringWithFormat:@"%@%@",priceBoardServer,@"/dataInfo.jsp?code=%@&matchedIdx=-1&counter=0"] forKey:@"stock_fullInfo"];
    [user setObject:[NSString stringWithFormat:@"%@%@",priceBoardServer,@"/marketInfo.jsp"] forKey:@"market_info"];
    [user setObject:[NSString stringWithFormat:@"%@%@",priceBoardServer,@"/boardInfo.jsp?id=%@&langId=vi_VN&sectorId=%d"] forKey:@"root_priceBoard"];
    [user setObject:[NSString stringWithFormat:@"%@%@",priceBoardServer,@"/updateInfo.jsp?boardId=%@&clientVersion=%ld"] forKey:@"change_priceBoard"];
    [user setObject:[NSString stringWithFormat:@"%@%@",priceBoardServer,@"/chartInfo.jsp?type=%@&code=%@&width=%@&height=%@&s1=KL&s2=Price"] forKey:@"chart_matchedPrice"];
    [user setObject:[NSString stringWithFormat:@"%@%@",priceBoardServer,@"/newsInfo.jsp?code=%@"] forKey:@"newsInfo"];
    [user setObject:[NSString stringWithFormat:@"%@%@",priceBoardServer,@"/news.jsp?code=%@"] forKey:@"news"];
    
    
    //stock
    [user setObject:[NSString stringWithFormat:@"%@%@",onlineServer,@"/tab/stockIdAndFloor.action"] forKey:@"getAllStock"];
    [user setObject:[NSString stringWithFormat:@"%@%@",onlineServer,@"/tab/stockMarginList.action"] forKey:@"getMarginStock"];
    [user setObject:[NSString stringWithFormat:@"%@%@",onlineServer,@"/tab/watchingStock.action"] forKey:@"getWatchingStocks"];
    [user setObject:[NSString stringWithFormat:@"%@%@",onlineServer,@"/tab/addWatchingStock.action"] forKey:@"addWatchingStock"];
    [user setObject:[NSString stringWithFormat:@"%@%@",onlineServer,@"/tab/removeWatchingStock.action"] forKey:@"removeWatchingStock"];
    [user setObject:[NSString stringWithFormat:@"%@%@",onlineServer,@"/tab/updateCapitalPrice.action"] forKey:@"updateCapitalPrice"];
    //login
    [user setObject:[NSString stringWithFormat:@"%@%@",onlineServer,@"/tab/tabLogin.action"] forKey:@"login"];
    [user setObject:[NSString stringWithFormat:@"%@%@",onlineServer,@"/tab/tabLogout.action"] forKey:@"logout"];
    //order
    [user setObject:[NSString stringWithFormat:@"%@%@",onlineServer,@"/tab/intradayOrders.action"] forKey:@"OrderTodayList"];
    [user setObject:[NSString stringWithFormat:@"%@%@",onlineServer,@"/tab/getGtdList.action"] forKey:@"getGtdList"];
    [user setObject:[NSString stringWithFormat:@"%@%@",onlineServer,@"/tab/createOrder.action"] forKey:@"createOrder"];
    [user setObject:[NSString stringWithFormat:@"%@%@",onlineServer,@"/tab/cancelOrder.action"] forKey:@"cancelOrder"];
    [user setObject:[NSString stringWithFormat:@"%@%@",onlineServer,@"/tab/editOrder.action"] forKey:@"editOrder"];
    [user setObject:[NSString stringWithFormat:@"%@%@",onlineServer,@"/tab/matchedOrderDetails.action"] forKey:@"orderMatchPriceList"];
    [user setObject:[NSString stringWithFormat:@"%@%@",onlineServer,@"/tab/tradingHistory.action"] forKey:@"matchedOrderHistory"];
    [user setObject:[NSString stringWithFormat:@"%@%@",onlineServer,@"/tab/orderHistory.action"] forKey:@"orderHistory"];
    [user setObject:[NSString stringWithFormat:@"%@%@",onlineServer,@"/tab/stock4Order.action"] forKey:@"stock4Order"];
    //client info
    [user setObject:[NSString stringWithFormat:@"%@%@",onlineServer,@"/tab/tabClientInfo.action"] forKey:@"clientInfo"];
    [user setObject:[NSString stringWithFormat:@"%@%@",onlineServer,@"/tab/tabCash.action"] forKey:@"clientCashInfo"];
    [user setObject:[NSString stringWithFormat:@"%@%@",onlineServer,@"/tab/tabStock.action"] forKey:@"clientStockInfo"];
    [user setObject:[NSString stringWithFormat:@"%@%@",onlineServer,@"/tab/getTransferAccountList.action"] forKey:@"onlineTranferList"];
    [user setObject:[NSString stringWithFormat:@"%@%@",onlineServer,@"/tab/smsServiceInfo.action"] forKey:@"SMSInfo"];
    [user setObject:[NSString stringWithFormat:@"%@%@",onlineServer,@"/tab/updateSmsService.action"] forKey:@"updateSmsService"];
    [user setObject:[NSString stringWithFormat:@"%@%@",onlineServer,@"/tab/updatePersonalInfo.action"] forKey:@"updatePersonalInfo"];
    [user setObject:[NSString stringWithFormat:@"%@%@",onlineServer,@"/tab/tabChangePwd.action"] forKey:@"tabChangePwd"];
    [user setObject:[NSString stringWithFormat:@"%@%@",onlineServer,@"/tab/entitlementInfo.action"] forKey:@"entitlementInfo"];
    [user setObject:[NSString stringWithFormat:@"%@%@",onlineServer,@"/tab/entitlementHistory.action"] forKey:@"entitlementHistory"];
    [user setObject:[NSString stringWithFormat:@"%@%@",onlineServer,@"/tab/entitlement.action"] forKey:@"entitlement"];
    [user setObject:[NSString stringWithFormat:@"%@%@",onlineServer,@"/tab/marginInfo.action"] forKey:@"marginInfo"];
    [user setObject:[NSString stringWithFormat:@"%@%@",onlineServer,@"/tab/marginIncreaseDebt.action"] forKey:@"marginIncreaseDebt"];
    [user setObject:[NSString stringWithFormat:@"%@%@",onlineServer,@"/tab/marginDecreaseDebt.action"] forKey:@"marginDecreaseDebt"];
    [user setObject:[NSString stringWithFormat:@"%@%@",onlineServer,@"/tab/marginExtendContract.action"] forKey:@"marginExtendContract"];
    [user setObject:[NSString stringWithFormat:@"%@%@",onlineServer,@"/tab/marginInfoOfAuthorized.action"] forKey:@"marginInfoOfAuthorized"];
    [user setObject:[NSString stringWithFormat:@"%@%@",onlineServer,@"/tab/marginTransferBuyingPower.action"] forKey:@"marginTransferBuyingPower"];
    
    [user setObject:[NSString stringWithFormat:@"%@%@",onlineServer,@"/tab/marginHistory.action"] forKey:@"marginHistory"];
    
    
    //OTP
    [user setObject:[NSString stringWithFormat:@"%@%@",onlineServer,@"/tab/checkOTP.action"] forKey:@"OTPChecker"];
    //system
    [user setObject:[NSString stringWithFormat:@"%@%@",onlineServer,@"/tab/params.action"] forKey:@"systemParams"];
    
    [user setObject:[NSString stringWithFormat:@"%@%@",onlineServer,@"/tab/transferCash.action"] forKey:@"transferCash"];
    [user setObject:[NSString stringWithFormat:@"%@%@",onlineServer,@"/tab/cashTransferHistory.action"] forKey:@"cashTransferHistory"];
    [user setObject:[NSString stringWithFormat:@"%@%@",onlineServer,@"/tab/orders4Sign.action"] forKey:@"order4Sign"];
    [user setObject:[NSString stringWithFormat:@"%@%@",onlineServer,@"/tab/signOrders.action"] forKey:@"signOrders"];
    /*
     //stock
     [user setObject:@"https://idragon.vdsc.com.vn/tab/stockIdAndFloor.action" forKey:@"getAllStock"];
     [user setObject:@"https://idragon.vdsc.com.vn/tab/stockMarginList.action" forKey:@"getMarginStock"];
     [user setObject:@"https://idragon.vdsc.com.vn/tab/watchingStock.action" forKey:@"getWatchingStocks"];
     [user setObject:@"https://idragon.vdsc.com.vn/tab/addWatchingStock.action" forKey:@"addWatchingStock"];
     [user setObject:@"https://idragon.vdsc.com.vn/tab/removeWatchingStock.action" forKey:@"removeWatchingStock"];
     [user setObject:@"https://idragon.vdsc.com.vn/tab/updateCapitalPrice.action" forKey:@"updateCapitalPrice"];
     //login
     [user setObject:@"https://idragon.vdsc.com.vn/tab/tabLogin.action" forKey:@"login"];
     [user setObject:@"https://idragon.vdsc.com.vn/tab/tabLogout.action" forKey:@"logout"];
     //order
     [user setObject:@"https://idragon.vdsc.com.vn/tab/intradayOrders.action" forKey:@"OrderTodayList"];
     [user setObject:@"https://idragon.vdsc.com.vn/tab/createOrder.action" forKey:@"createOrder"];
     [user setObject:@"https://idragon.vdsc.com.vn/tab/cancelOrder.action" forKey:@"cancelOrder"];
     [user setObject:@"https://idragon.vdsc.com.vn/tab/editOrder.action" forKey:@"editOrder"];
     [user setObject:@"https://idragon.vdsc.com.vn/tab/matchedOrderDetails.action" forKey:@"orderMatchPriceList"];
     [user setObject:@"https://idragon.vdsc.com.vn/tab/tradingHistory.action" forKey:@"matchedOrderHistory"];
     [user setObject:@"https://idragon.vdsc.com.vn/tab/orderHistory.action" forKey:@"orderHistory"];
     [user setObject:@"https://idragon.vdsc.com.vn/tab/stock4Order.action" forKey:@"stock4Order"];
     [user setObject:@"https://idragon.vdsc.com.vn/tab/getGtdList.action" forKey:@"getGtdList"];
     //client info
     [user setObject:@"https://idragon.vdsc.com.vn/tab/tabClientInfo.action" forKey:@"clientInfo"];
     [user setObject:@"https://idragon.vdsc.com.vn/tab/tabCash.action" forKey:@"clientCashInfo"];
     [user setObject:@"https://idragon.vdsc.com.vn/tab/tabStock.action" forKey:@"clientStockInfo"];
     [user setObject:@"https://idragon.vdsc.com.vn/tab/getTransferAccountList.action" forKey:@"onlineTranferList"];
     //OTP
     [user setObject:@"https://idragon.vdsc.com.vn/tab/checkOTP.action" forKey:@"OTPChecker"];
     //system
     [user setObject:@"https://idragon.vdsc.com.vn/tab/params.action" forKey:@"systemParams"];
     */
    
    [user synchronize];
}

- (void)viewDidLoad
{
    [self resetDefaults];
    
    [[NSUserDefaults standardUserDefaults] setValue:@"Dữ liệu được cập nhật 10s 1 lần." forKey:@"infoView"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.fieldMatKhau.delegate=self;
    self.fieldMaTK.delegate=self;
    
    //[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"splashscreen.jpg"]]];
    //[self.loginView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"loginBackground"]]];
    
    [self.view bringSubviewToFront:viewBackground];
    [self registerForKeyboardNotifications];
    self.fieldMatKhau.secureTextEntry=YES;
    utils = [[VDSCCommonUtils alloc] init];
    params = [[VDSCSystemParams alloc] init];
    [self setLanguage];
    
    [[self viewBackground] setHidden:NO];
    [self performSelectorInBackground:@selector(showLoginView) withObject:nil];
    //[self showLoginView];
    
    
    
    [super viewDidLoad];
    
}
-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        if ((UIDeviceOrientationIsLandscape(toInterfaceOrientation))||(UIDeviceOrientationIsLandscape(toInterfaceOrientation))) {
            return YES;
        }
        else return NO;
    }
    else
    {
        if ((UIDeviceOrientationIsLandscape(toInterfaceOrientation))||(UIDeviceOrientationIsLandscape(toInterfaceOrientation))) {
            return YES;
        }
        else return NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated
    
}

-(void) showLoginView
{
    
    [self.view bringSubviewToFront:viewBackground];
    
    [self.viewBackground setHidden:NO];
    [self.view bringSubviewToFront:self.loginView];
    [self.loginView setHidden:NO];
    
}
-(void) hideLoginView
{
    [[self viewBackground] setHidden:YES];
    [self.loginView setHidden:YES];
}
- (IBAction)btnLogin:(id)sender {
    [self resetDefaults];
    if(loading==nil){
        //loading = [[utils showLoading:self.loginView] retain];
        [self.fieldMatKhau resignFirstResponder];
        [self.fieldMaTK resignFirstResponder];
        if(self.fieldMaTK.text.length==0){
            [utils showMessage:[utils.dic_language objectForKey:@"ipad.login.alert.missInput"] messageContent:nil];
            if(loading!=nil){
                [loading removeFromSuperview];
                [loading release];
                loading=nil;
            }
            return;
        }
        NSString *post = [NSString stringWithFormat:@"KW_WS_EXECPWD:::%@@@@KW_CLIENTID:::%@@@@KW_CLIENTPWD:::%@",[NSString stringWithFormat:@"Abc123XYZ2013_%@", [utils.shortDateFormater stringFromDate: [NSDate date]]],[self.fieldMaTK.text substringFromIndex:3],self.fieldMatKhau.text];
        //NSString *post = [NSString stringWithFormat:@"KW_WS_EXECPWD:::%@@@@KW_CLIENTID:::%@@@@KW_CLIENTPWD:::%@",@"Abc123XYZ2013_04/07/2013",[self.fieldMaTK.text substringFromIndex:3],self.fieldMatKhau.text];
        NSString *urlStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"login"];
        NSURL *url = [[NSURL alloc] initWithString: urlStr];
        ASIFormDataRequest *request_cash = [ASIFormDataRequest requestWithURL:url ];
        request_cash.tag=100;
        //request_cash.timeOutSeconds = 30;
        [request_cash addPostValue:post forKey:@"info"];
        [request_cash setRequestMethod:@"POST"];
        [self grabURLInTheBackground:request_cash];
        [url release];
    }
}

-(void) loadClientInfo
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setValue:@""  forKey:@"OTPNumber"];
    [user synchronize];
    
    NSArray *arr = [[NSArray alloc] initWithObjects:@"KW_CLIENTSECRET",utils.clientInfo.secret, @"KW_CLIENTID", utils.clientInfo.clientID, nil];
    NSString *post = [utils postValueBuilder:arr];
    
    NSString *url = [user stringForKey:@"clientInfo"];
    NSDictionary *allDataDictionary = [utils getDataFromUrl:url method:@"POST" postData:post];
    NSArray *personal = [allDataDictionary objectForKey:@"personal"];
    if(![personal isEqual:[NSNull null]]){
        utils.clientInfo.idCard = [personal objectAtIndex:2];
        utils.clientInfo.isuseDate = [personal objectAtIndex:3];
        utils.clientInfo.address = [personal objectAtIndex:4];
        utils.clientInfo.email = [personal objectAtIndex:7];
        utils.clientInfo.phone = [personal objectAtIndex:6];
        utils.clientInfo.OTPNumber = [personal objectAtIndex:5];
        [user setValue:utils.clientInfo.phone  forKey:@"phone"];
        [user setValue:utils.clientInfo.email  forKey:@"email"];
        [user setValue:utils.clientInfo.OTPNumber  forKey:@"OTPNumber"];
        [user setValue:@"VN" forKey:@"defaultLanguage"];
        
    }
    [user synchronize];
    [arr release];
}
- (IBAction)grabURLInTheBackground:(ASIFormDataRequest *)request
{
    if (!queue) {
        [queue=[NSOperationQueue alloc] init];
    }
    
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(requestDone:)];
    [request setDidFailSelector:@selector(requestWentWrong:)];
    [queue addOperation:request]; //queue is an NSOperationQueue
}

- (void)requestDone:(ASIFormDataRequest *)request
{
    NSDictionary *allDataDictionary;
    @try{
        NSData *data = [[request responseData] retain];
        allDataDictionary = [[NSJSONSerialization JSONObjectWithData:data options:0 error:nil] retain];
        if(request.tag==100)
        {
            [[NSUserDefaults standardUserDefaults] setValue:@""  forKey:@"clientID"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            if(![allDataDictionary isEqual:[NSNull null]]&&[[allDataDictionary objectForKey:@"success"] boolValue])
            {
                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                [user setObject:[allDataDictionary objectForKey:@"name"] forKey:@"clientName"];
                [user setObject:[self.fieldMaTK.text substringFromIndex:3] forKey:@"clientID"];
                [user setObject:[allDataDictionary objectForKey:@"secret"] forKey:@"secret"];
                [user setObject:[allDataDictionary objectForKey:@"tradingAccSeq"] forKey:@"tradingAccSeq"];
                [user setObject:[allDataDictionary objectForKey:@"accountType"] forKey:@"accountType"];
                [user setDouble:[[allDataDictionary objectForKey:@"orderFee"] doubleValue] forKey:@"tempFee"];
                [user setObject:NO forKey:@"saveOTP"];
                [user synchronize];
                [self hideLoginView];
                [utils init];
                //[self performSelectorInBackground:@selector(loadClientInfo) withObject:nil];
                [self loadClientInfo];
                self.fieldMaTK.text=@"033C";
                self.fieldMatKhau.text=@"";
            }
            else
            {
                if([allDataDictionary isEqual:[NSNull null]])
                {
                    [utils showMessage:@"Không thể kết nối được với hệ thống! Quý khách vui lòng kiểm tra lại kết nối internet hoặc liên hệ với VDSC để được hỗ trợ thêm." messageContent:nil];
                }
                else
                [self loginFail:[allDataDictionary objectForKey:@"errCode"]];
                //return;
            }
        }
        [data release];
        //[request clearDelegatesAndCancel];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception.description);
    }
    @finally {
        if(allDataDictionary!=nil)
            [allDataDictionary release];
        if(loading!=nil){
            [loading removeFromSuperview];
            [loading release];
            loading=nil;
        }
    }
    
}

- (void)requestWentWrong:(ASIFormDataRequest *)request
{
    [utils showMessage:@"Không thể kết nối được với hệ thống! Quý khách vui lòng kiểm tra lại kết nối internet hoặc liên hệ với VDSC để được hỗ trợ thêm." messageContent:nil];
    NSError *error = [request error];
    NSLog(@"%@",error.description);
    if(loading!=nil){
        [loading removeFromSuperview];
        [loading release];
        loading=nil;
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField == self.fieldMaTK)
        [self.fieldMatKhau becomeFirstResponder];
    else
        [self btnLogin:nil];
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.fieldMatKhau resignFirstResponder];
    [self.fieldMaTK resignFirstResponder];
}

- (IBAction)btn_dieuKhoan_touch:(id)sender {
    VDSCNewsEntity *news = [[VDSCNewsEntity alloc] init];
    news.f_title=@"Điều khoản sử dụng";
    news.f_content = params.ternLink;
    news.isWebLink=YES;
    VDSCNewsItemViewController *newController = [self.storyboard instantiateViewControllerWithIdentifier:@"VDSCNewsItemView"];
    newController.modalPresentationStyle = UIModalPresentationFullScreen;
    newController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    newController.newsEntity = news;
    [self presentModalViewController:newController animated:YES];
    [news release];
}

- (IBAction)btn_hoTro_touch:(id)sender {
    VDSCNewsEntity *news = [[VDSCNewsEntity alloc] init];
    news.f_title=@"Hỗ trợ";
    news.f_content = params.supportLink;
    news.isWebLink=YES;
    VDSCNewsItemViewController *newController = [self.storyboard instantiateViewControllerWithIdentifier:@"VDSCNewsItemView"];
    newController.modalPresentationStyle = UIModalPresentationFullScreen;
    newController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    newController.newsEntity = news;
    [self presentModalViewController:newController animated:YES];
    [news release];
}

- (IBAction)btn_huongDan_touch:(id)sender {
    VDSCNewsEntity *news = [[VDSCNewsEntity alloc] init];
    news.f_title=@"Hướng dẫn sử dụng";
    news.f_content = params.instructionLink;
    news.isWebLink=YES;
    VDSCNewsItemViewController *newController = [self.storyboard instantiateViewControllerWithIdentifier:@"VDSCNewsItemView"];
    newController.modalPresentationStyle = UIModalPresentationFullScreen;
    newController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    newController.newsEntity = news;
    [self presentModalViewController:newController animated:YES];
    [news release];
    
}
-(void)loginFail:(NSString *)errorCode
{
    NSString *message = @"";
    
    if ([errorCode isEqualToString:@"HKSEF0034"])
        message = [utils.dic_language objectForKey:@"ipad.login.alert.wrongInfo"];
    else if ([errorCode isEqualToString:@"HKSEF0035"])
        message = [utils.dic_language objectForKey:@"ipad.login.alert.lockAccount"];
    else if ([errorCode isEqualToString:@"CORE10155"])
        message = @"Không tồn tại TK này";
    else if ([errorCode isEqualToString:@"ERRCODE_8888"])
        message = @"Web method bị exeception";
    else if ([errorCode isEqualToString:@"ERRCODE_9999"])
        message = @"Pwd Data bị hết hạn";
    else if([errorCode isEqualToString:@"TPBASEREQERROR"])
        message=[utils.dic_language objectForKey:@"ipad.login.alert.dayend"];
    else if ([errorCode isEqualToString:@"ERR-PARA"])
        message = [utils.dic_language objectForKey:@"ipad.login.alert.missInput"];
    
    
    [self.fieldMatKhau resignFirstResponder];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Đăng nhập hệ thống" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
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
    //if(fieldMaBaoVe.editing)
    //{
    [UIView beginAnimations:@"nove" context:NULL];
    [UIView setAnimationDuration:0.25];
    self.loginView.frame= CGRectMake(self.loginView.frame.origin.x, self.loginView.frame.origin.y-150, self.loginView.frame.size.width, self.loginView.frame.size.height);
    [UIView commitAnimations];
    //}
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    //if(activeField == fieldMaBaoVe)
    //{
    [UIView beginAnimations:@"nove" context:NULL];
    [UIView setAnimationDuration:0.25];
    self.loginView.frame= CGRectMake(self.loginView.frame.origin.x, self.loginView.frame.origin.y+150, self.loginView.frame.size.width, self.loginView.frame.size.height);
    [UIView commitAnimations];
    //}
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = textField;
    //NSLog(textField);
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeField = nil;
}

- (IBAction)showMainView:(id)sender {
    if(main ==nil)
        main = [[self storyboard]instantiateViewControllerWithIdentifier:@"MainView"] ;
    [main setModalPresentationStyle:UIModalPresentationFullScreen];
    [main setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    main.splashView = self;
    UIButton *tab = (UIButton *)sender;
    main.defaultTab_0market_1order_2services_3list_4balance_5account=tab.tag;
    [self presentModalViewController:main animated:YES ];
    [main release];
    main=nil;
}
-(void) setLanguage
{
    [self.btnLogin setTitle:[utils.dic_language objectForKey:@"ipad.login.btn_login"] forState:UIControlStateNormal];
    self.lbl_thitruong.text = [[utils.dic_language objectForKey:@"ipad.login.tabMarket"] uppercaseString];
    self.lbl_lenh.text = [[utils.dic_language objectForKey:@"ipad.login.tabOrder"] uppercaseString];
    self.lbl_dichvu.text = [[utils.dic_language objectForKey:@"ipad.login.tabServices"] uppercaseString];
    self.lbl_danhmuc.text = [[utils.dic_language objectForKey:@"ipad.login.tabList"] uppercaseString];
    self.lbl_sodu.text = [[utils.dic_language objectForKey:@"ipad.login.tabBalance"] uppercaseString];
    self.lbl_taikhoan.text = [[utils.dic_language objectForKey:@"ipad.login.tabAccountInfo"] uppercaseString];
    
    
}

- (void)viewDidUnload {
    [self setLoginButton:nil];
    [self setLoginView:nil];
    [self setViewBackground:nil];
    [self setV_login:nil];
    [self setLbl_thitruong:nil];
    [self setLbl_lenh:nil];
    [self setLbl_dichvu:nil];
    [self setLbl_taikhoan:nil];
    [self setLbl_sodu:nil];
    [self setLbl_danhmuc:nil];
    [super viewDidUnload];
}
-(void) dealloc
{
    [loginView release];
    [viewBackground release];
    [_loginButton release];
    [_v_login release];
    [_lbl_thitruong release];
    [_lbl_lenh release];
    [_lbl_dichvu release];
    [_lbl_taikhoan release];
    [_lbl_sodu release];
    [_lbl_danhmuc release];
    [super dealloc];
}
@end
