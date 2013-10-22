//
//  VDSCMainViewController.m
//  iPadDragon
//
//  Created by vdsc on 12/24/12.
//  Copyright (c) 2012 VDSC. All rights reserved.
//

#import "VDSCMainViewController.h"
#import "VDSCMarketInfo.h"
#import "VDSCCommonUtils.h"
#import "VDSCEditOrderViewController.h"
#import "ASIFormDataRequest.h"
#import "VDSCInfoViewController.h"
#import "tabNgang/Orders/VDSCMachedOrderView.h"
#import "VDSCListView.h"
#import "VDSCMarginTransServices.h"
#import "VDSCAccountInfoView.h"

@interface VDSCMainViewController()
{
    NSMutableArray *array_price;
    //NSTimer *timer_marqueeIndex;
    NSOperationQueue *queue;
    UIPopoverController *popover;
    VDSCEditOrderViewController *editOrderController;
}

@end

@implementation VDSCMainViewController


@synthesize mainView;
@synthesize market;
@synthesize list;
@synthesize miniPriceBoard;
@synthesize utils;
@synthesize orderSide;
@synthesize popoverOrderController;
@synthesize array_watchList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
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

-(void) addRemoveStockInWatchingList:(BOOL)isAdd stockId:(NSString*) stockId marketId:(NSString*)marketId
{
    @try{
        if(isAdd)
        {
            NSArray *arr = [[NSArray alloc] initWithObjects:stockId, marketId, nil];
            [array_watchList addObject:arr];
            [arr release];
        }
        else
        {
            NSArray *item = [[NSArray alloc] initWithObjects:stockId, marketId, nil];
            [array_watchList removeObject:item];
            [item release];
        }
        
        if(market!=nil && [[market.lbl_San.text lowercaseString] isEqualToString:@"danh mục quan tâm"]){
            if(isAdd)
            {
                NSString *stock=stockId;
                NSString *urlStr= [NSString stringWithFormat:[[NSUserDefaults standardUserDefaults] stringForKey:@"stock_info"], stock];
                
                NSURL *url = [NSURL URLWithString:urlStr];
                ASIFormDataRequest *request_cash = [ASIFormDataRequest requestWithURL:url ];
                request_cash.tag=300;
                [request_cash setRequestMethod:@"GET"];
                [self grabURLInTheBackground:request_cash];
                
            }
            else
            {
                VDSCPriceBoardEntity *item_del=nil;
                for(VDSCPriceBoardEntity *item in self.market.root_array_price)
                    if([item.f_maCK rangeOfString:stockId].location != NSNotFound)
                    {
                        item_del = [item retain];
                        break;
                    }
                if(item_del!=nil)
                {
                    [self.market.root_array_price removeObject:item_del];
                }
                
                item_del=nil;
                for(VDSCPriceBoardEntity *item in self.market.array_price)
                    if([item.f_maCK rangeOfString:stockId].location != NSNotFound)
                    {
                        item_del = [item retain];
                        break;
                    }
                if(item_del!=nil)
                {
                    [self.market.array_price removeObject:item_del];
                }
                
                item_del=nil;
                for(VDSCPriceBoardEntity *item in self.market.miniPriceBoard.root_array_price)
                    if([item.f_maCK rangeOfString:stockId].location != NSNotFound)
                    {
                        item_del = [item retain];
                        break;
                    }
                if(item_del!=nil)
                {
                    [self.market.miniPriceBoard.root_array_price removeObject:item_del];
                }
            }
            [self.market.priceBoard reloadData];
            [self.market.miniPriceBoard.priceBoard reloadData];
        }
    }
    @catch (NSException *ex) {
        NSLog(@"Uncaught exception: %@", ex.description);NSLog(@"Stack trace: %@", [ex callStackSymbols]);
    }
    
    
}
-(BOOL)checkStockInWatchingList:(NSString*)stockId
{
    if(array_price==nil)
        [self loadWatchingStocks];
    for(NSArray *item in array_watchList)
    {
        NSString *stock=[item objectAtIndex:0];
        if([stock isEqualToString:[stockId uppercaseString]])
            return YES;
    }
    return NO;
}

- (IBAction)btn_infoView_touch:(id)sender {
    @try{
        VDSCInfoViewController *controller =  [self.storyboard instantiateViewControllerWithIdentifier:@"VDSCInfoViewController"];
        controller.view.frame = CGRectMake(0, 0, 300, 200);
        controller.lbl_infoText.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"infoView"];
        if([self.activeView isKindOfClass:[VDSCAccountInfoView class]])
            controller.lbl_infoText.text = @" - Hiệu lực của mật khẩu:01/08/2013 13:19:51.\\n- Mật khẩu của Quý khách có hiệu lực trong 90 ngày kể từ lần thay đổi cuối cùng.\\n- Quý khách chỉ được thay đổi email và số điện thoại trên hệ thống Giao dịch trực tuyến.";
        else if([self.activeView isKindOfClass:[VDSCMachedOrderView class]])
            controller.lbl_infoText.text = @"Lệnh khớp trong ngày được cập nhật vào ngày giao dịch kế tiếp.";
        else if([self.activeView isKindOfClass:[VDSCMarginTransServices class]])
            controller.lbl_infoText.text = @"Các yêu cầu Tăng dư nợ, Chuyển sức mua và Gia hạn hợp đồng phải được sự chấp thuận của Rồng Việt.";
        else if([self.activeView isKindOfClass:[VDSCListView class]])
            controller.lbl_infoText.text = @"Giá vốn được cập nhật vào ngày giao dịch tiếp theo.";
        if(popover==nil)
            popover = [[UIPopoverController alloc] initWithContentViewController:controller];
        [popover presentPopoverFromRect:((UIButton*)sender).frame inView:((UIButton*)sender).superview permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    }
    @catch (NSException *ex) {
        NSLog(@"Uncaught exception: %@", ex.description);NSLog(@"Stack trace: %@", [ex callStackSymbols]);
    }
    
}

-(NSString*)getMarketByStock: (NSString*)stockId
{
    for(VDSCPriceBoardEntity *item in array_price)
    {
        if([item.f_maCK isEqualToString:stockId])
            return item.f_sanGD;
    }
    return @"";
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    @try{
        utils = [[VDSCCommonUtils alloc] init];
        
        array_watchList = [[NSMutableArray alloc] init];
        [self.f_marqueeIndex setOpaque:NO];
        NSString *html = [NSString stringWithFormat:@"<html><head></head><body style=\"margin: 0 0 0 0\"><marquee style=\"width: 769px; height: 30px; padding-top: 5px; font-style: arial; color:#00CC00;\" scrollamount=\"3\" >%@</marquee></body></html>", [utils.dic_language objectForKey:@"ipad.common.marqueeFoter"]];
        [self.f_marqueeIndex loadHTMLString:html baseURL:nil];
        
        //timer_marqueeIndex= [NSTimer scheduledTimerWithTimeInterval:35.0 target:self selector:@selector(loadMarqueeData) userInfo:nil repeats:YES];
        //[timer_marqueeIndex fire];
        
        
        [[self headerView] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"logo.png"]]];
        [[self bg_menuBackground] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-menu.png"]]];
        [self disableVerticalButton];
        [self showDefaultTab];
        
        self.lbl_cusName.text = [NSString stringWithFormat:@"033%@ - %@", utils.clientInfo.clientID, utils.clientInfo.clientName];
        
        array_price  = [[NSMutableArray alloc] init];
        [self loadPriceBoard];
        [self loadWatchingStocks];
    }
    @catch (NSException *ex) {
        NSLog(@"Uncaught exception: %@", ex.description);NSLog(@"Stack trace: %@", [ex callStackSymbols]);
    }
    
}
-(void) loadPriceBoard
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *urlStr = [NSString stringWithFormat:@"%@",[user stringForKey:@"getAllStock"]];
    
    NSArray *arr = [[NSArray alloc] initWithObjects:@"KW_CLIENTSECRET",utils.clientInfo.secret, @"KW_CLIENTID", utils.clientInfo.clientID, nil];
    NSString *post = [utils postValueBuilder:arr];
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIFormDataRequest *request_cash = [ASIFormDataRequest requestWithURL:url ];
    request_cash.tag=100;
    
    [request_cash addPostValue:[post substringFromIndex:5] forKey:@"info"];
    [request_cash setRequestMethod:@"POST"];
    [self grabURLInTheBackground:request_cash];
    [arr release];
}

-(void) loadWatchingStocks
{
    NSArray *arr = [[NSArray alloc] initWithObjects:@"KW_CLIENTSECRET",utils.clientInfo.secret, @"KW_CLIENTID", utils.clientInfo.clientID, nil];
    NSString *post = [utils postValueBuilder:arr];
    
    NSString *urlStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"getWatchingStocks"];
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIFormDataRequest *request_cash = [ASIFormDataRequest requestWithURL:url ];
    request_cash.tag=200;
    
    [request_cash addPostValue:[post substringFromIndex:5] forKey:@"info"];
    [request_cash setRequestMethod:@"POST"];
    [self grabURLInTheBackground:request_cash];
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
        NSData *data = [request responseData];
        allDataDictionary = [[NSJSONSerialization JSONObjectWithData:data options:0 error:nil] retain];
        if(request.tag==100)
        {
            if([[allDataDictionary objectForKey:@"success"] boolValue])
            {
                NSArray *data = [allDataDictionary objectForKey:@"list"];
                if([data isEqual:[NSNull null]]){return;}
                for (NSArray *arrayOfEntity in data)
                {
                    VDSCPriceBoardEntity *price = [[VDSCPriceBoardEntity alloc] init];
                    //price.loadOK = (BOOL *)list obj
                    price.f_maCK = [arrayOfEntity objectAtIndex:0];
                    price.f_sanGD = [arrayOfEntity objectAtIndex:1];
                    [array_price addObject:price];
                    [price release];
                }
            }
        }
        else if(request.tag==200)
        {
            [array_watchList removeAllObjects];
            if([[allDataDictionary objectForKey:@"list"] isEqual:[NSNull null]])
            {
                return;
            }
            for(NSArray *item in [allDataDictionary objectForKey:@"list"])
            {
                NSArray *obj = [[NSArray alloc] initWithObjects:[item objectAtIndex:0], [item objectAtIndex:1], nil];
                [array_watchList addObject:obj];
                [obj release];
            }
        }
        else if(request.tag==300)
        {
            NSArray *arrayOfEntity = [allDataDictionary objectForKey:@"stock"];
            if(![arrayOfEntity isEqual:[NSNull null]]){
                VDSCPriceBoardEntity *stockEntity = [[VDSCPriceBoardEntity alloc] init];
                stockEntity.f_tenCty = [allDataDictionary objectForKey:@"name"];
                stockEntity.f_ma = [arrayOfEntity objectAtIndex:0];
                stockEntity.f_maCK = [stockEntity.f_ma objectAtIndex:0];
                stockEntity.f_sanGD = [self getMarketByStock:stockEntity.f_maCK];
                stockEntity.f_tran = [arrayOfEntity objectAtIndex:2];
                stockEntity.f_san = [arrayOfEntity objectAtIndex:3];
                stockEntity.f_thamchieu = [arrayOfEntity objectAtIndex:1];
                
                stockEntity.f_mua4_kl = [arrayOfEntity objectAtIndex:4];
                stockEntity.f_mua3_gia = [arrayOfEntity objectAtIndex:5];
                stockEntity.f_mua3_kl = [arrayOfEntity objectAtIndex:6];
                stockEntity.f_mua2_gia = [arrayOfEntity objectAtIndex:7];
                stockEntity.f_mua2_kl = [arrayOfEntity objectAtIndex:8];
                stockEntity.f_mua1_gia = [arrayOfEntity objectAtIndex:9];
                stockEntity.f_mua1_kl = [arrayOfEntity objectAtIndex:10];
                
                stockEntity.f_kl_gia = [arrayOfEntity objectAtIndex:11];
                stockEntity.f_kl_kl = [arrayOfEntity objectAtIndex:12];
                stockEntity.f_kl_tangGiam = [arrayOfEntity objectAtIndex:13];
                stockEntity.f_kl_tongkl = [arrayOfEntity objectAtIndex:14];
                
                stockEntity.f_ban1_gia = [arrayOfEntity objectAtIndex:15];
                stockEntity.f_ban1_kl = [arrayOfEntity objectAtIndex:16];
                stockEntity.f_ban2_gia = [arrayOfEntity objectAtIndex:17];
                stockEntity.f_ban2_kl = [arrayOfEntity objectAtIndex:18];
                stockEntity.f_ban3_gia = [arrayOfEntity objectAtIndex:19];
                stockEntity.f_ban3_kl = [arrayOfEntity objectAtIndex:20];
                stockEntity.f_ban4_kl = [arrayOfEntity objectAtIndex:21];
                
                stockEntity.f_moCua = [arrayOfEntity objectAtIndex:22];
                stockEntity.f_cao = [arrayOfEntity objectAtIndex:23];
                stockEntity.f_thap = [arrayOfEntity objectAtIndex:24];
                stockEntity.f_trungBinh = [arrayOfEntity objectAtIndex:25];
                
                [self.market.root_array_price addObject:stockEntity];
                
                [self.market.priceBoard reloadData];
                [self.market.miniPriceBoard.priceBoard reloadData];
                [stockEntity release];
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(exception.description);
    }
    @finally {
        if(allDataDictionary!=nil)
            [allDataDictionary release];
    }
    
}

- (void)requestWentWrong:(ASIFormDataRequest *)request
{
    NSError *error = [request error];
    NSLog(error.description);
}

-(void)loadMarqueeData
{
    [self.f_marqueeIndex loadHTMLString:[self.marketIndex htmlBuilder] baseURL:nil];
}

-(void)showDefaultTab
{
    switch (self.defaultTab_0market_1order_2services_3list_4balance_5account) {
        case 0:
            [self tabMarketView:nil];
            break;
        case 1:
            [self tabOrderView:nil];
            break;
        case 2:
            [self tabServiceView:nil];
            break;
        case 3:
            [self tabListView:nil];
            break;
        case 4:
            [self tabBalanceView:nil];
            break;
        case 5:
            [self tabAccountInfoView:nil];
            break;
        default:
            break;
    }
}
- (IBAction)tabMarketView:(id)sender {
    @try{
        [self hideKeyboard];
        if(self.accountInfo!=nil)
            self.accountInfo.activeField=nil;
        if(self.services!=nil)
            [self.services unregisterForKeyboardNotifications ];
        [self.view sendSubviewToBack:self.view_footer];
        if(self.market==nil)
        {
            market = [[[NSBundle mainBundle] loadNibNamed:@"VDSCMarketInfo" owner:self options:nil] objectAtIndex:0];
            market.frame = CGRectMake(0, 0, self.mainView.frame.size.width, self.mainView.frame.size.height);
            [self.mainView addSubview:market];
            market.delegate = self;
        }
        [self disableVerticalButton];
        [self setBackgroundTab:nil];
        market.btn_showMiniPriceBoard.tag=0;
        [market.btn_showMiniPriceBoard setBackgroundImage:[UIImage imageNamed:@"btn-banggia-mini.png"] forState:UIControlStateNormal];
        [self.btn_market setBackgroundImage:[UIImage imageNamed:@"btn-left-2.png"] forState:UIControlStateNormal];
        [self.mainView bringSubviewToFront:market];
    }
    @catch (NSException *ex) {
        NSLog(@"Uncaught exception: %@", ex.description);NSLog(@"Stack trace: %@", [ex callStackSymbols]);
    }
    
}
- (IBAction)tabNewsView:(id)sender {
    @try{
        [self hideKeyboard];
        if(self.accountInfo!=nil)
            self.accountInfo.activeField=nil;
        [self.view sendSubviewToBack:self.view_footer];
        if(self.news==nil)
        {
            self.news = [[[NSBundle mainBundle] loadNibNamed:@"VDSCNewsView" owner:self options:nil] objectAtIndex:0];
            self.news.frame = CGRectMake(0, 0, self.mainView.frame.size.width, 642);
            [self.news.marketInfo addSubview: self.marketIndex];
            [self.mainView addSubview:self.news];
        }
        [self disableVerticalButton];
        [self setBackgroundTab:nil];
        [self.btn_VDSCNews setBackgroundImage:[UIImage imageNamed:@"btn-left-4.png"] forState:UIControlStateNormal];
        [self.mainView bringSubviewToFront:self.news];
    }
    @catch (NSException *ex) {
        NSLog(@"Uncaught exception: %@", ex.description);NSLog(@"Stack trace: %@", [ex callStackSymbols]);
    }
    
}
- (IBAction)tabBusinessNewsView:(id)sender {
    @try{
        [self hideKeyboard];
        if(self.accountInfo!=nil)
            self.accountInfo.activeField=nil;
        [self.view sendSubviewToBack:self.view_footer];
        if(self.businessNews==nil)
        {
            self.businessNews = [[[NSBundle mainBundle] loadNibNamed:@"VDSCBusinessNewsView" owner:self options:nil] objectAtIndex:0];
            self.businessNews.frame = CGRectMake(0, 0, self.mainView.frame.size.width, 642);
            [self.businessNews.marketInfo addSubview: self.marketIndex];
            [self.mainView addSubview:self.businessNews];
        }
        
        [self disableVerticalButton];
        [self setBackgroundTab:nil];
        [self.btn_businessNews setBackgroundImage:[UIImage imageNamed:@"btn-left-3.png"] forState:UIControlStateNormal];
        [self.mainView bringSubviewToFront:self.businessNews];
    }
    @catch (NSException *ex) {
        NSLog(@"Uncaught exception: %@", ex.description);NSLog(@"Stack trace: %@", [ex callStackSymbols]);
    }
    
}
- (IBAction)tabOrderView:(id)sender {
    @try{
        [self hideKeyboard];
        if(self.accountInfo!=nil)
            self.accountInfo.activeField=nil;
        if(self.services!=nil)
            [self.services unregisterForKeyboardNotifications ];
        [self.view bringSubviewToFront:self.view_footer];
        if(self.order==nil)
        {
            self.order = [[[NSBundle mainBundle] loadNibNamed:@"VDSCOrderView" owner:self options:nil] objectAtIndex:0];
            self.order.frame = CGRectMake(0, 0, self.mainView.frame.size.width, 640);
            [self.mainView addSubview:self.order];
            self.order.delegate = self;
        }
        /*if(self.stockId != nil && ![self.stockId isEqualToString:@""])
         {
         self.order.txt_ma.text = self.stockId;
         self.order.btn_sideOrder.tag=[orderSide isEqualToString:@"B"]?1:0;
         [self.order btn_sideOrder_touch:self.order.btn_sideOrder];
         [self.order loadStockInfo];
         self.stockId=@"";
         }
         self.stockId=@"";
         self.priceOrder=0;*/
        [self setBackgroundTab:self.btn_order];
        self.order.segmentedControl.selectedIndex=0;
        [self.order.otpView setHidden:[[[NSUserDefaults standardUserDefaults] objectForKey:@"saveOTP"] boolValue]];
        [self.mainView bringSubviewToFront:self.order];
    }
    @catch (NSException *ex) {
        NSLog(@"Uncaught exception: %@", ex.description);NSLog(@"Stack trace: %@", [ex callStackSymbols]);
    }
    
}
- (IBAction)tabListView:(id)sender {
    @try{
        [self hideKeyboard];
        if(self.accountInfo!=nil)
            self.accountInfo.activeField=nil;
        if(self.services!=nil)
            [self.services unregisterForKeyboardNotifications];
        
        [self.view bringSubviewToFront:self.view_footer];
        if(self.list==nil)
        {
            list = [[[[NSBundle mainBundle] loadNibNamed:@"VDSCListView" owner:self options:nil] objectAtIndex:0] retain];
            list.frame = CGRectMake(0, 0, self.mainView.frame.size.width, self.mainView.frame.size.height) ;
            [self.mainView addSubview:list];
        }
        list.delegate=self;
        [self setBackgroundTab:self.btn_list];
        self.activeView = list;
        [self.mainView bringSubviewToFront:list];
    }
    @catch (NSException *ex) {
        NSLog(@"Uncaught exception: %@", ex.description);NSLog(@"Stack trace: %@", [ex callStackSymbols]);
    }
}

- (IBAction)tabBalanceView:(id)sender {
    @try{
        [self hideKeyboard];
        if(self.accountInfo!=nil)
            self.accountInfo.activeField=nil;
        [self.view bringSubviewToFront:self.view_footer];
        if(self.balance==nil)
        {
            self.balance = [[[NSBundle mainBundle] loadNibNamed:@"VDSCBalanceView" owner:self options:nil] objectAtIndex:0];
            self.balance.frame = CGRectMake(0, 0, self.mainView.frame.size.width, 642);
            [self.mainView addSubview:self.balance];
        }
        self.balance.delegate=self;
        [self setBackgroundTab:self.btn_balance];
        [self.mainView bringSubviewToFront:self.balance];}
    @catch (NSException *ex) {
        NSLog(@"Uncaught exception: %@", ex.description);NSLog(@"Stack trace: %@", [ex callStackSymbols]);
    }
}
- (IBAction)tabServiceView:(id)sender {
    @try{
        if(self.accountInfo!=nil)
            self.accountInfo.activeField=nil;
        [self.view bringSubviewToFront:self.view_footer];
        [self hideKeyboard];
        if(self.services==nil)
        {
            self.services = [[[NSBundle mainBundle] loadNibNamed:@"VDSCCashTranferServices" owner:self options:nil] objectAtIndex:0];
            self.services.frame = CGRectMake(0, 0, self.mainView.frame.size.width, self.mainView.frame.size.height);
            [self.mainView addSubview:self.services];
        }
        self.services.delegate=self;
        self.services.segmentedControl.selectedIndex=0;
        [self.services registerForKeyboardNotifications];
        [self setBackgroundTab:self.btn_services];
        [self.mainView bringSubviewToFront:self.services];}
    @catch (NSException *ex) {
        NSLog(@"Uncaught exception: %@", ex.description);NSLog(@"Stack trace: %@", [ex callStackSymbols]);
    }
}
- (IBAction)tabAccountInfoView:(id)sender {
    @try{
        [self.view bringSubviewToFront:self.view_footer];
        [self hideKeyboard];
        if(self.accountInfo==nil)
        {
            self.accountInfo = [[[NSBundle mainBundle] loadNibNamed:@"VDSCAccountInfoView" owner:self options:nil] objectAtIndex:0];
            self.accountInfo.frame = CGRectMake(0, 0, self.mainView.frame.size.width, 642);
            [self.mainView addSubview:self.accountInfo];
        }
        self.accountInfo.delegate=self;
        self.activeView = self.accountInfo;
        [self.accountInfo registerForKeyboardNotifications];
        [self disableVerticalButton];
        [self setBackgroundTab:nil];
        [self.btn_accountInfo setBackgroundImage:[UIImage imageNamed:@"btn-left-5.png"] forState:UIControlStateNormal];
        [self.mainView bringSubviewToFront:self.accountInfo];}
    @catch (NSException *ex) {
        NSLog(@"Uncaught exception: %@", ex.description);NSLog(@"Stack trace: %@", [ex callStackSymbols]);
    }
}
-(void)hideKeyboard
{
    if(self.order!=nil)
    {
        [self.order touchesBegan:0 withEvent:nil];
    }
    if(self.accountInfo!=nil)
    {
        [self.accountInfo touchesBegan:0 withEvent:nil];
    }
    if(self.services!=nil)
    {
        [self.services touchesBegan:0 withEvent:nil];
    }
    if(self.market!=nil)
    {
        [self.market touchesBegan:0 withEvent:nil];
    }
}

- (IBAction)exit:(id)sender {
    @try{
        NSString *url = [[NSUserDefaults standardUserDefaults] stringForKey:@"logout"];
        
        NSArray *arr = [[NSArray alloc] initWithObjects:
                        @"KW_CLIENTSECRET",utils.clientInfo.secret
                        , @"KW_CLIENTID", utils.clientInfo.clientID
                        , nil];
        NSString *post = [utils postValueBuilder:arr];
        NSDictionary *allDataDictionary = [[utils getDataFromUrl:url method:@"POST" postData:post] retain];
        [[NSUserDefaults standardUserDefaults] setObject:NO forKey:@"saveOTP"];
        [[NSUserDefaults standardUserDefaults] setValue:@""  forKey:@"OTPNumber"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [allDataDictionary release];
        [arr release];
        [self.splashView showLoginView];
        if(market != nil)
        {
            [market.timer_price invalidate];
            //market.timer_price = nil;
            if(market.miniPriceBoard!=nil)
            {
                [market.miniPriceBoard.timer_price invalidate];
                //market.miniPriceBoard.timer_price = nil;
            }
            [market release];
            market =nil;
        }
        if(self.order !=nil)
        {
          [self.order.timer_order invalidate];
            [self.order release];
        }
        if(self.list !=nil)
        {
            [self.list.timer invalidate];
            [self.list release];
        }
        if(self.balance !=nil)
        {
            [self.balance.timer invalidate];
            //[self.balance release];
        }
        [self dismissModalViewControllerAnimated:YES];
        //[self dealloc];
        
        //[timer_marqueeIndex invalidate];
        //timer_marqueeIndex=nil;
        //[self.marketIndex dealloc];
        /*_marketIndex=nil;*/
        /*if(list != nil)
         [list release];
         if(miniPriceBoard != nil)
         [miniPriceBoard release];
         if(_businessNews != nil)
         [_businessNews release];
         if(_news != nil)
         [_news release];
         if(_order != nil)
         [_order release];
         if(_balance != nil)
         [_balance release];
         if(_services != nil)
         [_services release];
         if(_accountInfo != nil)
         [_accountInfo release];*/
    }
    @catch (NSException *ex) {
        NSLog(@"Uncaught exception: %@", ex.description);NSLog(@"Stack trace: %@", [ex callStackSymbols]);
    }
}

- (IBAction)btn_buy_touch:(id)sender {
    orderSide=@"B";
    [self showOrderView: sender orderEntity:nil inView:self.bg_menuBackground];
}
- (IBAction)btn_sell_touch:(id)sender {
    orderSide=@"S";
    [self showOrderView: sender orderEntity:nil inView:self.bg_menuBackground];
}
- (IBAction)btn_cancel_touch:(id)sender {
    orderSide=@"C";
    [self showOrderView: sender orderEntity:nil inView:self.bg_menuBackground];
}
- (IBAction)btn_edit_touch:(id)sender {
    orderSide=@"E";
    [self showOrderView: sender orderEntity:nil inView:self.bg_menuBackground];
}
-(void)showOrderView:(UIView*)sender orderEntity:(id)orderEntity inView:(UIView*)inView
{
    @try{
        //if(editOrderController==nil)
            editOrderController = [[self storyboard]instantiateViewControllerWithIdentifier:@"EditOrderView"];
        editOrderController.orderEntity = nil;
        editOrderController.orderSide=[orderSide retain];
        editOrderController.params = nil;
        editOrderController.delegate=[self retain];;
        //[editOrderController initLayout];
        popoverOrderController = [[UIPopoverController alloc] initWithContentViewController:editOrderController];
        CGRect rect = sender.frame;
        [popoverOrderController presentPopoverFromRect:rect inView:inView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    @catch (NSException *ex) {
        NSLog(@"Uncaught exception: %@", ex.description);NSLog(@"Stack trace: %@", [ex callStackSymbols]);
    }
    
}

-(void)setBackgroundTab:(UIButton*)tab
{
    [self disableVerticalButton];self.activeView = self.view;
    [self.btn_balance setBackgroundImage:[UIImage imageNamed:@"tabmenu-den.png"] forState:UIControlStateNormal];
    [self.btn_services setBackgroundImage: [UIImage imageNamed:@"tabmenu-den.png"]forState:UIControlStateNormal];
    [self.btn_list setBackgroundImage:[UIImage imageNamed:@"tabmenu-den.png"] forState:UIControlStateNormal];
    [self.btn_order setBackgroundImage: [UIImage imageNamed:@"tabmenu-den.png"]forState:UIControlStateNormal];
    
    if(tab!=nil)
        [tab setBackgroundImage: [UIImage imageNamed:@"tabmenu-do.png"]forState:UIControlStateNormal];
}

-(void) disableVerticalButton
{
    self.activeView = self.view;
    [self.btn_market setBackgroundImage:[UIImage imageNamed:@"btn-left2-hide.png"] forState:UIControlStateNormal];
    [self.btn_businessNews setBackgroundImage: [UIImage imageNamed:@"btn-left3-hide.png"]forState:UIControlStateNormal];
    [self.btn_VDSCNews setBackgroundImage:[UIImage imageNamed:@"btn-left4-hide.png"] forState:UIControlStateNormal];
    [self.btn_accountInfo setBackgroundImage: [UIImage imageNamed:@"btn-left5-hide.png"]forState:UIControlStateNormal];
}

-(void)showLogin{
    
    [[self splashView] showLoginView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setMainView:nil];
    [self setHeaderView:nil];
    [self setBg_menuBackground:nil];
    [self setBtn_order:nil];
    [self setBtn_list:nil];
    [self setBtn_balance:nil];
    [self setBtn_services:nil];
    [self setBtn_market:nil];
    [self setBtn_businessNews:nil];
    [self setBtn_VDSCNews:nil];
    [self setBtn_accountInfo:nil];
    [self setLbl_cusName:nil];
    [self setMarket:nil];
    [self setOrder:nil];
    [self setList:nil];
    [self setMiniPriceBoard:nil];
    [self setNews:nil];
    [self setBalance:nil];
    [self setServices:nil];
    [self setAccountInfo:nil];
    //[self setF_marqueeIndex:nil];
    [self setView_footer:nil];
    [self setBtn_buy:nil];
    [self setBtn_sell:nil];
    [self setBtn_cancel:nil];
    [self setBtn_edit:nil];
    if(editOrderController!=nil)[editOrderController release];
    [super viewDidUnload];
}

- (void)dealloc {
    
    [_marketIndex release];
    if(market != nil)
        [market release];
    if(list != nil)
        [list release];
    if(miniPriceBoard != nil)
        [miniPriceBoard release];
    if(_businessNews != nil)
        [_businessNews release];
    if(_news != nil)
        [_news release];
    if(_order != nil)
        [_order release];
    if(_balance != nil)
        [_balance release];
    if(_services != nil)
        [_services release];
    if(_accountInfo != nil)
        [_accountInfo release];
    [queue cancelAllOperations];
    [queue release];
    [array_price release];
    //[_bg_menuBackground release];
    [_btn_order release];
    [_btn_list release];
    [_btn_balance release];
    [_btn_services release];
    [_btn_market release];
    [_btn_businessNews release];
    [_btn_VDSCNews release];
    [_btn_accountInfo release];
    [_lbl_cusName release];
    //[_f_marqueeIndex release];
    [_view_footer release];
    [_btn_buy release];
    [_btn_sell release];
    [_btn_cancel release];
    [_btn_edit release];
    [popover release];
    [super dealloc];
}

@end
