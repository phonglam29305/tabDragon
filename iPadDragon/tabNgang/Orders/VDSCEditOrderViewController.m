//
//  VDSCEditOrderViewController.m
//  iPadDragon
//
//  Created by vdsc on 3/29/13.
//  Copyright (c) 2013 VDSC. All rights reserved.
//

#import "VDSCEditOrderViewController.h"
#import "VDSCCommonUtils.h"
#import "VDSCOTPView.h"
#import "VDSCStock4OrderEntity.h"
#import "VDSCOrderView.h"
#import "VDSCPriceBoardEntity.h"
#import "SSCheckBoxView.h"
#import "VDSCPush2DateListViewController.h"
#import "VDSCOrderUtility.h"
#import "VDSCMainViewController.h"
#import "ASIFormDataRequest.h"

@interface VDSCEditOrderViewController ()
{
    VDSCCommonUtils *utils;
    VDSCOTPView *otp_cancelEdit;
    VDSCOTPView *otp_createOrder;
    VDSCPriceBoardEntity *stockEntity;
    //VDSCStock4OrderEntity *stockEntity;
    NSMutableArray *array_price;
    NSMutableArray *array_stockMargin;
    NSMutableArray *array_order;
    
    UITextField *activeField;
    SSCheckBoxView *cbv;
    VDSCOrderUtility *orderUtility;
    VDSCMainViewController *mainview;
    UIWebView *loading;
    NSOperationQueue *queue;
    UIPopoverController *popoverController;
}
@end



@implementation VDSCEditOrderViewController


@synthesize orderEntity;
@synthesize params;
@synthesize arrayGtdDate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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


- (void)viewDidLoad
{
    [super viewDidLoad];
    @try{
	// Do any additional setup after loading the view.
    array_price = [[NSMutableArray alloc] init];
    array_stockMargin = [[NSMutableArray alloc] init];
    arrayGtdDate = [[NSMutableArray alloc] init];
    //stockEntity = [[VDSCStock4OrderEntity alloc] init];
    //stockEntity.ceiling=0;
    //stockEntity.floor=0;
    mainview  =(VDSCMainViewController*)self.delegate;
    utils =[[VDSCCommonUtils alloc] init];
    orderUtility = [[VDSCOrderUtility alloc] init];
    orderUtility.utils = utils;
    orderUtility.delegate = self;
    self.f_loaiLenh_createOrder.delegate=self;
    otp_cancelEdit = [[[NSBundle mainBundle] loadNibNamed:@"VDSCOTPView" owner:self options:nil] objectAtIndex:0];
    otp_cancelEdit.frame = CGRectMake(0, 0, 360, 30);
    [self.otpView_cancelEdit addSubview:otp_cancelEdit];
    otp_createOrder = [[[NSBundle mainBundle] loadNibNamed:@"VDSCOTPView" owner:self options:nil] objectAtIndex:0];
    otp_createOrder.frame = CGRectMake(0, 0, 360, 30);
    [self.otpView_createOrder addSubview:otp_createOrder];
    
    [self.f_loaiLenh_createOrder initSource:[NSArray arrayWithObjects:@"LO",@"ATO", @"ATC", @"MP", nil]];
    
    //[self performSelectorInBackground:@selector(loadPriceBoard) withObject:nil];
    [self loadPriceBoard];
    self.table_todayOderList.delegate=self;
    self.table_todayOderList.dataSource=self;
    
    
    CGRect frame = CGRectMake(482, 165, 50, 50);
    SSCheckBoxViewStyle style = (2 % kSSCheckBoxViewStylesCount);
    BOOL checked = NO;
    cbv = [[SSCheckBoxView alloc] initWithFrame:frame
                                          style:style
                                        checked:checked];
    [self.view_createOrder addSubview:cbv];
    [self initLayout];
    }
    @catch (NSException *ex) {
        NSLog(@"Uncaught exception: %@", ex.description);NSLog(@"Stack trace: %@", [ex callStackSymbols]);
    }
    //[self performSelectorInBackground:@selector(initLayout) withObject:nil];
}
-(void) initLayout
{
    @try{
        if([self.orderSide isEqualToString:@"B"]||[self.orderSide isEqualToString:@"S"])
        {
            self.txt_ma.text = mainview.stockId;
            self.txt_gia.text =[utils.numberFormatter1Digits stringFromNumber:[NSNumber numberWithDouble: mainview.priceOrder]];
            self.btn_sideOrder.tag=[self.orderSide isEqualToString:@"B"]?1:0;
            [self btn_sideOrder_touch:self.btn_sideOrder];
            [self.view bringSubviewToFront:self.view_createOrder];
            params = [[VDSCSystemParams alloc] init];
            [self performSelectorInBackground:@selector(loadDateList) withObject:nil];
            [self performSelectorInBackground:@selector(LoadBalance) withObject:nil];
            //[self txt_ma_ValueChanged:self.txt_ma];
            [self getStockInfo:mainview.stockId];
        }
        else
            if([self.orderSide isEqualToString:@"C"]||[self.orderSide isEqualToString:@"E"])
            {
                
                array_order = [[NSMutableArray alloc] init];
                if(self.orderEntity==nil)
                {
                    //loading = [utils showLoading:self.view_orderList];
                    params = [[VDSCSystemParams alloc] init];
                    
                    self.lbl_cancelEdit.text=[self.orderSide isEqualToString:@"E"]?@"Sửa":@"Huỷ";
                    
                    [self.view bringSubviewToFront:self.view_orderList];
                    //[self performSelectorInBackground:@selector(loadOrders) withObject:nil];
                    [self loadOrders];
                }
                else
                {
                    [self.view bringSubviewToFront:self.view_cancelEdit];
                    
                    self.f_gia.text = [utils.numberFormatter1Digits stringFromNumber:[NSNumber numberWithDouble: orderEntity.price]];
                    self.f_khoiLuong.text =[utils.numberFormatter1Digits stringFromNumber:[NSNumber numberWithDouble: orderEntity.qty]];
                    self.f_loaiLenh.text = [params getOrderType:orderEntity.marketId type: orderEntity.type];
                    self.f_maCK.text = orderEntity.stockId;
                    //editOrderController.f_tenCK.text=self.st
                    
                    NSString *bs = @"bán";
                    if([orderEntity.side isEqualToString:@"B"]) bs=@"mua";
                    if([self.orderSide isEqualToString:@"C"])
                    {
                        self.f_title.text=[NSString stringWithFormat:@"Huỷ lệnh %@",  bs];
                        [self.txt_newPrice setHidden:YES];
                        CGRect rect = self.f_gia.frame;
                        rect.size.width=self.f_maCK.frame.size.width;
                        self.f_gia.frame=rect;
                        
                        [self.txt_newQTY setHidden:YES];
                        rect = self.f_khoiLuong.frame;
                        rect.size.width=self.f_maCK.frame.size.width;
                        self.f_khoiLuong.frame=rect;
                    }
                    else
                    {
                        if(!(([self.orderEntity.type isEqualToString:@"L"]||[self.orderEntity.type isEqualToString:@"R"]) && [self.orderEntity.marketId isEqualToString:@"HA"]))
                        {
                            [self.txt_newQTY setHidden:YES];
                            CGRect rect = self.f_khoiLuong.frame;
                            rect.size.width=self.f_maCK.frame.size.width;
                            self.f_khoiLuong.frame=rect;
                        }
                        [self.txt_newPrice setHidden:NO];
                        CGRect rect = self.f_gia.frame;
                        rect.size.width=self.f_maCK.frame.size.width-self.txt_newPrice.frame.size.width;
                        self.f_gia.frame=rect;
                        
                        [self.txt_newQTY setHidden:NO];
                        rect = self.f_khoiLuong.frame;
                        rect.size.width=self.f_maCK.frame.size.width-self.txt_newQTY.frame.size.width;
                        self.f_khoiLuong.frame=rect;
                        
                        self.f_title.text=[NSString stringWithFormat:@"Sửa lệnh %@", bs];
                        self.txt_newQTY.text = [NSString stringWithFormat:@"%@",[utils.numberFormatter1Digits stringFromNumber: [NSNumber numberWithDouble:self.orderEntity.qty]]];
                        self.txt_newPrice.text = [NSString stringWithFormat:@"%@",[utils.numberFormatter1Digits stringFromNumber: [NSNumber numberWithDouble:self.orderEntity.price]]];
                    }
                    
                    
                    
                    VDSCStock4OrderEntity *stock4Order = [utils loadStockInfo:orderEntity.stockId marketId:orderEntity.marketId orderSide:orderEntity.side];
                    self.f_tenCK.text = stock4Order.name;
                }
            }
    }
    @catch (NSException *ex) {
        NSLog(@"Uncaught exception: %@", ex.description);NSLog(@"Stack trace: %@", [ex callStackSymbols]);
    }
}
-(void) getStockInfo: (NSString*)stockID
{
    @try{
    self.f_tiLeVay.text =@"0";
    for(NSArray *stock in [array_stockMargin retain])
    {
        if([stockID isEqualToString:[stock objectAtIndex:0]])
            self.f_tiLeVay.text = [NSString stringWithFormat:@"%@",[stock objectAtIndex:1]];
    }
    
    self.f_soDuCK.text = @"0";
    VDSCStock4OrderEntity *stock4Order = [utils loadStockInfo:stockID marketId:@"" orderSide:self.btn_sideOrder.tag==0?@"B":@"S"];
    
    //stockEntity=stock4Order;
    if(self.btn_sideOrder.tag==1)
        self.f_soDuCK.text = [utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble: stock4Order.usable]];
    else
        self.f_sucMua.text = [utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble: stock4Order.usable]];
    
    if([[self.f_loaiLenh_createOrder getOrderType] isEqualToString:@"ATO"]||[[self.f_loaiLenh_createOrder getOrderType] isEqualToString:@"MOK"]||[[self.f_loaiLenh_createOrder getOrderType] isEqualToString:@"MAK"]||[[self.f_loaiLenh_createOrder getOrderType] isEqualToString:@"MTL"]||[[self.f_loaiLenh_createOrder getOrderType] isEqualToString:@"ATC"])
    {
        double kl=stock4Order.ceiling;
        if(self.btn_sideOrder.tag!=0)kl=stock4Order.floor;
        self.txt_gia.text = [utils.numberFormatter1Digits stringFromNumber:[NSNumber numberWithDouble:kl]];
    }
        [self resetOrderType:stock4Order];}
    @catch (NSException *ex) {
        NSLog(@"Uncaught exception: %@", ex.description);NSLog(@"Stack trace: %@", [ex callStackSymbols]);
    }
}
-(void) loadStockInfo
{
    stockEntity = nil;
    NSString *code = self.txt_ma.text;
    NSString *urlStr = [NSString stringWithFormat: [[NSUserDefaults standardUserDefaults] stringForKey:@"stock_info"], code];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIFormDataRequest *request_cash = [ASIFormDataRequest requestWithURL:url ];
    request_cash.tag=600;
    [request_cash setRequestMethod:@"GET"];
    [self grabURLInTheBackground:request_cash];
}
-(void)loadDateList
{
    NSArray *arr = [[NSArray alloc] initWithObjects:@"KW_CLIENTSECRET",utils.clientInfo.secret
                    , @"KW_CLIENTID", utils.clientInfo.clientID
                    , nil];
    NSString *post = [utils postValueBuilder:arr];
    
    NSString *urlStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"getGtdList"];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIFormDataRequest *request_cash = [ASIFormDataRequest requestWithURL:url ];
    request_cash.tag=500;
    
    [request_cash addPostValue:[post substringFromIndex:5] forKey:@"info"];
    [request_cash setRequestMethod:@"POST"];
    [self grabURLInTheBackground:request_cash];
    [arr release];
}
-(void) loadPriceBoard
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *urlStr = [NSString stringWithFormat:@"%@",[user stringForKey:@"getAllStock"]];
    
    NSArray *arr = [[NSArray alloc] initWithObjects:@"KW_CLIENTSECRET",utils.clientInfo.secret, @"KW_CLIENTID", utils.clientInfo.clientID, nil];
    NSString *post = [utils postValueBuilder:arr];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIFormDataRequest *request_cash = [ASIFormDataRequest requestWithURL:url ];
    request_cash.tag=400;
    
    [request_cash addPostValue:[post substringFromIndex:5] forKey:@"info"];
    [request_cash setRequestMethod:@"POST"];
    [self grabURLInTheBackground:request_cash];
    
    [arr release];
}

-(void) loadMarginStock
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *urlStr = [NSString stringWithFormat:@"%@",[user stringForKey:@"getMarginStock"]];
    
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
-(void) LoadBalance
{
    NSString *urlStr = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] stringForKey:@"clientCashInfo"]];
    
    NSArray *arr = [[NSArray alloc] initWithObjects:@"KW_CLIENTSECRET",utils.clientInfo.secret
                    , @"KW_CLIENTID", utils.clientInfo.clientID
                    , @"KW_ACCOUNTTYPE", utils.clientInfo.accountType
                    , nil];
    NSString *post = [utils postValueBuilder:arr];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIFormDataRequest *request_cash = [ASIFormDataRequest requestWithURL:url ];
    request_cash.tag=200;
    
    [request_cash addPostValue:[post substringFromIndex:5] forKey:@"info"];
    [request_cash setRequestMethod:@"POST"];
    [self grabURLInTheBackground:request_cash];
    
    [arr release];
}
-(void)loadOrders
{
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *urlStr = [NSString stringWithFormat:@"%@",[user stringForKey:@"OrderTodayList"]];
    
    NSArray *arr = [[NSArray alloc] initWithObjects:@"KW_CLIENTSECRET",utils.clientInfo.secret, @"KW_CLIENTID", utils.clientInfo.clientID, nil];
    NSString *post = [utils postValueBuilder:arr];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIFormDataRequest *request_cash = [ASIFormDataRequest requestWithURL:url ];
    request_cash.tag=300;
    
    [request_cash addPostValue:[post substringFromIndex:5] forKey:@"info"];
    [request_cash setRequestMethod:@"POST"];
    [self grabURLInTheBackground:request_cash];
    
    [arr release];
}
- (IBAction)grabURLInTheBackground:(ASIFormDataRequest *)request
{
    @try{
        if (!queue) {
            [queue=[NSOperationQueue alloc] init];
            [queue setShouldGroupAccessibilityChildren:NO];
        }
        
        [request setDelegate:self];
        [request setDidFinishSelector:@selector(requestDone:)];
        [request setDidFailSelector:@selector(requestWentWrong:)];
        [queue addOperation:request]; //queue is an NSOperationQueue
    }
    @catch (NSException *ex) {
        NSLog(@"Uncaught exception: %@", ex.description);NSLog(@"Stack trace: %@", [ex callStackSymbols]);
    }
}

- (void)requestDone:(ASIFormDataRequest *)request
{
    NSDictionary *allDataDictionary;
    @try{
        NSData *data = [request responseData];
        allDataDictionary = [[NSJSONSerialization JSONObjectWithData:data options:0 error:nil] retain];
        if(request.tag==100)
        {
            NSArray *data = [allDataDictionary objectForKey:@"list"];
            if(![data isEqual:[NSNull null]])
                [array_stockMargin removeAllObjects];
            for (NSArray *arrayOfEntity in data)
            {
                [array_stockMargin addObject:arrayOfEntity];
            }
            
        }
        else if(request.tag==200)
        {
            bool success = [[allDataDictionary objectForKey:@"success"] boolValue];
            if(success)
            {
                self.f_sucMua.text = [utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:[[allDataDictionary objectForKey:@"BuyingPowerd"] doubleValue]]];
                
            }
        }
        else if(request.tag==300)
        {
            if([[allDataDictionary objectForKey:@"success"] boolValue])
            {
                [array_order removeAllObjects];
                NSArray *data = [allDataDictionary objectForKey:@"list"];
                if( ![data isEqual: [NSNull null]] )
                {
                    for (NSDictionary *arrayOfEntity in data)
                    {
                        VDSCOrderEntity *price = [[VDSCOrderEntity alloc] init];
                        //price.loadOK = (BOOL *)list obj
                        price.orderId = [arrayOfEntity objectForKey:@"orderId"];
                        price.orderGroupId = [arrayOfEntity objectForKey:@"groupId"];
                        price.marketId = [arrayOfEntity objectForKey:@"marketId"];
                        price.stockId = [arrayOfEntity objectForKey:@"stockId"];
                        price.side = [arrayOfEntity objectForKey:@"side"];
                        price.qty = [[arrayOfEntity objectForKey:@"qty"] doubleValue];
                        price.price = [[arrayOfEntity objectForKey:@"price"] doubleValue];
                        price.wQty = [[arrayOfEntity objectForKey:@"wQty"] doubleValue];
                        price.mQty = [[arrayOfEntity objectForKey:@"mQty"] doubleValue];
                        price.avgMPrice = [[arrayOfEntity objectForKey:@"avgMPrice"] doubleValue];
                        price.status = [params getOrderStatus:[arrayOfEntity objectForKey:@"status"] langue:0];
                        price.type = [arrayOfEntity objectForKey:@"type"];
                        price.gtd = [arrayOfEntity objectForKey:@"gtd"];
                        price.time = [arrayOfEntity objectForKey:@"time"];
                        price.isCancel = [arrayOfEntity objectForKey:@"isCancel"];
                        price.isEdit = [arrayOfEntity objectForKey:@"isEdit"];
                        if(([self.orderSide isEqualToString:@"C"] && [price.isCancel isEqualToString:@"Y"])||([self.orderSide isEqualToString:@"E"] && [price.isEdit isEqualToString:@"Y"]))
                            [array_order addObject:price];
                        [price release];
                    }
                }
                //if(array_order!=nil && array_order.count>0)
                //{
                [self.table_todayOderList reloadData];
                //}
            }
        }
        else if(request.tag==400)
        {
            if([[allDataDictionary objectForKey:@"success"] boolValue])
            {
                NSArray *data = [allDataDictionary objectForKey:@"list"];
                //if(data == nil || data.count==0){return;}
                for (NSArray *arrayOfEntity in data)
                {
                    VDSCPriceBoardEntity *price = [[VDSCPriceBoardEntity alloc] init];
                    //price.loadOK = (BOOL *)list obj
                    price.f_maCK = [arrayOfEntity objectAtIndex:0];
                    price.f_sanGD = [arrayOfEntity objectAtIndex:1];
                    [array_price addObject:price];
                    [price release];
                }
                if(array_price!=nil && array_price.count>0)
                {
                    [self loadMarginStock];
                    //self.f_tiLeVay.text = [NSString stringWithFormat:@"%d", ((VDSCPriceBoardEntity*)[array_price objectAtIndex:0]).f_marginPer];
                }
            }
        }
        else if(request.tag==500)
        {
            if([[allDataDictionary objectForKey:@"success"] boolValue])
            {
                if(![[allDataDictionary objectForKey:@"list"] isEqual:[NSNull null]])
                {
                    for(NSString *item in [allDataDictionary objectForKey:@"list"])
                    {
                        [self.arrayGtdDate addObject:item];
                    }
                    self.txt_hieuLuc.text = [self.arrayGtdDate objectAtIndex:1];
                }
            }
        }
        else if(request.tag==600)
        {
            NSArray *arrayOfEntity = [allDataDictionary objectForKey:@"stock"];
            if([arrayOfEntity isKindOfClass:[NSNull class]] ){return;}
            //for (NSArray *arrayOfEntity in data)
            //{
            stockEntity = [[VDSCPriceBoardEntity alloc] init];
            stockEntity.f_tenCty = [allDataDictionary objectForKey:@"name"];
            stockEntity.f_ma = [arrayOfEntity objectAtIndex:0];
            stockEntity.f_maCK = [stockEntity.f_ma objectAtIndex:0];
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
            
            self.f_tiLeVay.text =@"0";
            for(NSArray *stock in [array_stockMargin retain])
            {
                if([stockEntity.f_maCK isEqualToString:[stock objectAtIndex:0]])
                    self.f_tiLeVay.text = [NSString stringWithFormat:@"%@",[stock objectAtIndex:1]];
            }
            
            for(VDSCPriceBoardEntity *stock in array_price)
            {
                if([stock.f_maCK isEqual: [stockEntity.f_ma objectAtIndex:0]])
                {
                    stockEntity.f_maCK = stock.f_maCK;
                    stockEntity.f_sanGD = stock.f_sanGD;
                    self.f_soDuCK.text = @"0";
                    VDSCStock4OrderEntity *stock4Order = [utils loadStockInfo:stock.f_maCK marketId:stock.f_sanGD orderSide:self.btn_sideOrder.tag==0?@"B":@"S"];
                    
                    if(self.btn_sideOrder.tag==1)
                        self.f_soDuCK.text = [utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble: stock4Order.usable]];
                    else
                        self.f_sucMua.text = [utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble: stock4Order.usable]];
                    
                    if([[self.f_loaiLenh_createOrder getOrderType] isEqualToString:@"ATO"]||[[self.f_loaiLenh_createOrder getOrderType] isEqualToString:@"MOK"]||[[self.f_loaiLenh_createOrder getOrderType] isEqualToString:@"MAK"]||[[self.f_loaiLenh_createOrder getOrderType] isEqualToString:@"MTL"]||[[self.f_loaiLenh_createOrder getOrderType] isEqualToString:@"ATC"])
                    {
                        double kl=stock4Order.ceiling;
                        if(self.btn_sideOrder.tag!=0)kl=stock4Order.floor;
                        self.txt_gia.text = [utils.numberFormatter1Digits stringFromNumber:[NSNumber numberWithDouble:kl]];
                    }
                    [self resetOrderType:stock4Order];
                }
                
            }
        }
        else
        {
            BOOL result=[[allDataDictionary objectForKey:@"isEdit"] boolValue];
            if([self.orderSide isEqualToString:@"C"])
                result=[[allDataDictionary objectForKey:@"isCancel"] boolValue];
            if(result)
            {
                if([self.orderSide isEqualToString:@"C"])
                    [utils showMessage: [utils.dic_language objectForKey:@"ipad.cancelOrder.cancelSuccess"] messageContent: @""];
                else
                    [utils showMessage:[utils.dic_language objectForKey:@"ipad.editOrder.editSuccess"]messageContent: @""];
                
                if([self.delegate isKindOfClass:[VDSCMainViewController class]])
                    [mainview.popoverOrderController dismissPopoverAnimated:YES];
                else
                    [((VDSCOrderView*)self.delegate).popoverController dismissPopoverAnimated:YES];
            }
            else{
                
                if([self.orderSide isEqualToString:@"C"])
                    [utils showMessage: @"Yêu cầu huỷ lệnh không được chấp nhận" messageContent: [orderUtility getErrorMessage: [allDataDictionary objectForKey:@"errCode"]]];
                else
                    [utils showMessage: @"Yêu cầu sửa lệnh không được chấp nhận" messageContent: [orderUtility getErrorMessage: [allDataDictionary objectForKey:@"errCode"]]];
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(exception.description);
    }
    @finally {
        if(allDataDictionary!=nil)
            [allDataDictionary release];
        
        if(loading !=nil)
        {
            [loading removeFromSuperview];
            [loading release];
            loading=nil;
        }
    }
    
}

- (void)requestWentWrong:(ASIFormDataRequest *)request
{
    NSError *error = [request error];
    NSLog(error.description);
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{return utils.rowHeight;}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return array_order.count ;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{return 1;}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //@try{
    VDSCOrderEntity *order = [array_order objectAtIndex:indexPath.row];
    
    UIColor *color = [UIColor greenColor];
    if([order.side isEqualToString:@"S"]) color = [UIColor colorWithRed:212/255.0 green:10/255.0 blue:201/255.0 alpha:1];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] autorelease];
        
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 64, utils.rowHeight-1)];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [utils cellBackgroundColor];
        label.textColor = color;
        label.tag=100000;
        [label setFont:[UIFont fontWithName:utils.fontFamily size:utils.fontSize]];
        [cell addSubview:label];
        [label release];
        
        
        UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
        cancel.frame = CGRectMake(20, 0, 28, 28);
        [cancel setBackgroundImage:[UIImage imageNamed:@"btn-cancel_icon.png"] forState:UIControlStateNormal];
        cancel.tag = 10000;
        [cancel addTarget:self action:@selector(cancelOrder:) forControlEvents:UIControlEventTouchUpInside];
        cancel.backgroundColor = [utils cellBackgroundColor];
        [cancel setHidden:![self.orderSide isEqualToString:@"C"]];
        [cell addSubview:cancel];
        [cancel release];
        
        UIButton *edit = [UIButton buttonWithType:UIButtonTypeCustom];
        edit.frame = CGRectMake(20, 0, 28, 28);
        [edit setBackgroundImage:[UIImage imageNamed:@"btn_edit_icon.png"] forState:UIControlStateNormal];
        edit.tag = 20000;
        [edit addTarget:self action:@selector(editOrder:) forControlEvents:UIControlEventTouchUpInside];
        edit.backgroundColor = [utils cellBackgroundColor];
        [edit setHidden:![self.orderSide isEqualToString:@"E"]];
        [cell addSubview:edit];
        [edit release];
        
        
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(65, 0, 60, utils.rowHeight-1)];
        label.text = order.stockId;
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [utils cellBackgroundColor];
        label.textColor = color;
        label.tag=1000;
        [label setFont:[UIFont fontWithName:utils.fontFamily size:utils.fontSize]];
        [cell addSubview:label];
        [label release];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(label.frame.size.width+ label.frame.origin.x+1, 0, 81, utils.rowHeight-1)];
        label.text = [order.side isEqual:@"B"]?@"Mua":@"Bán";
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [utils cellBackgroundColor];
        label.textColor = color;
        label.tag=2000;
        [label setFont:[UIFont fontWithName:utils.fontFamily size:utils.fontSize]];
        [cell addSubview:label];
        [label release];
        
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(label.frame.size.width+ label.frame.origin.x+1, 0, 64, utils.rowHeight-1)];
        label.text = [NSString stringWithFormat:@"%@",[utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble: order.price]]];
        label.textAlignment = NSTextAlignmentRight;
        label.backgroundColor = [utils cellBackgroundColor];
        label.textColor = color;
        label.tag=3000;
        [label setFont:[UIFont fontWithName:utils.fontFamily size:utils.fontSize]];
        [cell addSubview:label];
        [label release];
        
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(label.frame.size.width+ label.frame.origin.x+1, 0, 71, utils.rowHeight-1)];
        label.text = [NSString stringWithFormat:@"%@",[utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble: order.qty]]];
        label.textAlignment = NSTextAlignmentRight;
        label.backgroundColor = [utils cellBackgroundColor];
        label.textColor = color;
        label.tag=4000;
        [label setFont:[UIFont fontWithName:utils.fontFamily size:utils.fontSize]];
        [cell addSubview:label];
        [label release];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(label.frame.size.width+ label.frame.origin.x+1, 0, 80, utils.rowHeight-1)];
        label.text = [NSString stringWithFormat:@"%@",[utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble: order.wQty]]];
        label.textAlignment = NSTextAlignmentRight;
        label.backgroundColor = [utils cellBackgroundColor];
        label.textColor = color;
        label.tag=5000;
        [label setFont:[UIFont fontWithName:utils.fontFamily size:utils.fontSize]];
        [cell addSubview:label];
        [label release];
        
        
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(label.frame.size.width+ label.frame.origin.x+1, 0, 94, utils.rowHeight-1)];
        label.text = [params getOrderType:order.marketId type: order.type];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [utils cellBackgroundColor];
        label.textColor = color;
        label.tag=6000;
        [label setFont:[UIFont fontWithName:utils.fontFamily size:utils.fontSize]];
        [cell addSubview:label];
        [label release];
    }
    else
    {
        UIView *cancel = [cell viewWithTag:10000];
        [cancel setHidden:![self.orderSide isEqualToString:@"C"]];
        
        UIView *edit = [cell viewWithTag:20000];
        [edit setHidden:![self.orderSide isEqualToString:@"E"]];
        
        UILabel* label = (UILabel*)[cell viewWithTag:1000];
        label.text = order.stockId;
        label.textColor = color;
        
        label = (UILabel*)[cell viewWithTag:2000];
        label.text = [order.side isEqual:@"B"]?@"Mua":@"Bán";
        label.textColor = color;
        
        
        label = (UILabel*)[cell viewWithTag:3000];
        label.text = [NSString stringWithFormat:@"%@",[utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble: order.price]]];
        label.textColor = color;
        
        
        label = (UILabel*)[cell viewWithTag:4000];
        label.text = [NSString stringWithFormat:@"%@",[utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble: order.qty]]];
        label.textColor = color;
        
        label = (UILabel*)[cell viewWithTag:5000];
        label.text = [NSString stringWithFormat:@"%@",[utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble: order.wQty]]];
        label.textColor = color;
        
        
        
        label = (UILabel*)[cell viewWithTag:6000];
        label.text = [params getOrderType:order.marketId type: order.type];
        label.textColor = color;
        
    }
        cell.tag = indexPath.row;
        return cell;
    //}
    //@catch (NSException *ex) {
    //    NSLog(@"Uncaught exception: %@", ex.description);NSLog(@"Stack trace: %@", [ex callStackSymbols]);
    //}
}
-(void) resetOrderType: (VDSCStock4OrderEntity*)stock4Order
{
    if([stock4Order.marketId isEqualToString:@"HO"])
    {
        [self.f_loaiLenh_createOrder initSourceOrderType:params.hsxOrderType];
    }
    else if([stock4Order.marketId isEqualToString:@"HA"])
    {
        [self.f_loaiLenh_createOrder initSourceOrderType:params.hnxOrderType];}
    else{
        [self.f_loaiLenh_createOrder initSourceOrderType:params.upcomOrderType];}
}

- (IBAction)cancelOrder:(id)sender
{
    self.orderEntity = [array_order objectAtIndex:[[((UIButton*)sender) superview] superview].tag];
    if([[[((UIButton*)sender) superview] superview] isKindOfClass:[UITableView class]])
        self.orderEntity = [array_order objectAtIndex:[((UIButton*)sender) superview].tag];
    [self initLayout];
}
- (IBAction)editOrder:(id)sender
{
    int index= [[((UIButton*)sender) superview] superview].tag;
    if([[[((UIButton*)sender) superview] superview] isKindOfClass:[UITableView class]])
        index= [((UIButton*)sender) superview].tag;
    self.orderEntity = [array_order objectAtIndex:index];
    if([self.orderEntity.marketId isEqualToString:@"HA"] && [self.orderEntity.type isEqualToString:@"C"])
    {
        [utils showMessage:@"Lệnh ATC không được sửa." messageContent:nil dismissAfter:3];
        return;
    }
    [self initLayout];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    /*[_txt_newQTY release];
    if(popoverController != nil)[popoverController release];
    [array_price release];
    [array_stockMargin release];
    [arrayGtdDate release];*/
    [super dealloc];
}
-(void)viewWillDisappear:(BOOL)animated
{
    //[self viewDidUnload];
    /* [self setF_maCK:nil];
     [self setF_tenCK:nil];
     [self setF_gia:nil];
     [self setF_khoiLuong:nil];
     [self setF_loaiLenh:nil];
     [self setF_title:nil];
     [self setTxt_newPrice:nil];
     [self setOtpView_cancelEdit:nil];
     [self setOtpView_createOrder:nil];
     [self setView_orderList:nil];
     [self setView_createOrder:nil];
     [self setView_cancelEdit:nil];
     [self setTable_todayOderList:nil];
     [self setLbl_cancelEdit:nil];
     [self setTxt_newQTY:nil];*/
}
- (void)viewDidUnload {
    [array_price release];
    [array_stockMargin release];
    [arrayGtdDate release];
    [_f_maCK release];
    [_f_tenCK release];
    [_f_gia release];
    [_f_khoiLuong release];
    [_f_loaiLenh release];
    [_f_title release];
    [_txt_newPrice release];
    [_otpView_cancelEdit release];
    [_otpView_createOrder release];
    [otp_cancelEdit release];
    [otp_createOrder release];
    [_view_orderList release];
    [_view_createOrder release];
    [_view_cancelEdit release];
    [_table_todayOderList release];
    [_lbl_cancelEdit release];
    [queue cancelAllOperations];
    [queue release];
    [super viewDidUnload];
}
- (IBAction)btn_confirm_touch:(id)sender {
    @try{
    if([orderEntity.gtd isEqualToString:@""]){
        NSString* checkMarketStatus = [orderUtility checkOrderMarket: orderEntity.type marketId:orderEntity.marketId stockCode:orderEntity.stockId orderSide:self.orderSide];
        if(checkMarketStatus.length>0){
            [utils showMessage:checkMarketStatus messageContent:nil dismissAfter:3];
            return;
        }
    }
    BOOL check = [self.orderSide isEqualToString:@"C"];
    if(!check) check = [self checkInput] && [self checkBeforeConfirm];
    if(check){
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *urlStr = [NSString stringWithFormat:@"%@",[user stringForKey:@"cancelOrder"]];
        
        
        NSArray *arr_otp = [[utils getOPTPosition:otp_cancelEdit.otp_number1.text OTPPosition2:otp_cancelEdit.otp_number2.text] retain];
        
        NSArray *arr = [[NSArray alloc] initWithObjects:@"KW_CLIENTSECRET",utils.clientInfo.secret
                        , @"KW_CLIENTID", utils.clientInfo.clientID
                        , @"KW_ORDER_ID", [NSString stringWithFormat:@"%@", orderEntity.orderId]
                        , @"KW_OTP_ROWIDX",[NSString stringWithFormat:@"%@",[arr_otp objectAtIndex:0]]
                        , @"KW_OTP_COLIDX",[NSString stringWithFormat:@"%@",[arr_otp objectAtIndex:1]]
                        , @"KW_OTP_VALUE",[NSString stringWithFormat:@"%@,%@",otp_cancelEdit.otp_number1Value.text,otp_cancelEdit.otp_number2Value.text], nil];
        double kl = [[self.txt_newQTY.text stringByReplacingOccurrencesOfString:@"," withString:@"" ] doubleValue];
        
        double kl_old = [[self.f_khoiLuong.text stringByReplacingOccurrencesOfString:@"," withString:@"" ] doubleValue];
        int modifyQty = kl - kl_old;
        if([self.orderSide isEqualToString:@"E"])
        {
            [arr release];arr = nil;
            urlStr = [NSString stringWithFormat:@"%@",[user stringForKey:@"editOrder"]];
            arr = [[NSArray alloc] initWithObjects:@"KW_CLIENTSECRET",utils.clientInfo.secret
                   , @"KW_CLIENTID", utils.clientInfo.clientID
                   , @"KW_ORDER_ID", [NSString stringWithFormat:@"%@", orderEntity.orderId]
                   , @"KW_ORDER_NEWPRICE", self.txt_newPrice.text
                   , @"KW_ORDER_NEWQTY", [NSString stringWithFormat:@"%d", modifyQty]
                   , @"KW_OTP_ROWIDX",[NSString stringWithFormat:@"%@",[arr_otp objectAtIndex:0]]
                   , @"KW_OTP_COLIDX",[NSString stringWithFormat:@"%@",[arr_otp objectAtIndex:1]]
                   , @"KW_OTP_VALUE",[NSString stringWithFormat:@"%@,%@",otp_cancelEdit.otp_number1Value.text,otp_cancelEdit.otp_number2Value.text], nil];
        }
        NSString *post = [utils postValueBuilder:arr];
        
        NSURL *url = [NSURL URLWithString:urlStr];
        ASIFormDataRequest *request_cash = [ASIFormDataRequest requestWithURL:url ];
        request_cash.tag=700;
        
        [request_cash addPostValue:[post substringFromIndex:5] forKey:@"info"];
        [request_cash setRequestMethod:@"POST"];
        [self grabURLInTheBackground:request_cash];
        
        [arr release];
        [arr_otp release];
    }
    }
    @catch (NSException *ex) {
        NSLog(@"Uncaught exception: %@", ex.description);NSLog(@"Stack trace: %@", [ex callStackSymbols]);
    }
}
-(BOOL) checkBeforeConfirm
{
    @try{
    BOOL result = YES;
    NSString *message=@"";
    double gia = [[self.txt_newPrice.text stringByReplacingOccurrencesOfString:@"," withString:@"" ] doubleValue];
    
    double gia_old = [[self.f_gia.text stringByReplacingOccurrencesOfString:@"," withString:@"" ] doubleValue];
    
    double kl = [[self.txt_newQTY.text stringByReplacingOccurrencesOfString:@"," withString:@"" ] doubleValue];
    
    double kl_old = [[self.f_khoiLuong.text stringByReplacingOccurrencesOfString:@"," withString:@"" ] doubleValue];
    
    VDSCStock4OrderEntity *stock4Order = [utils loadStockInfo:orderEntity.stockId marketId:orderEntity.marketId orderSide:orderEntity.side];
    if(gia==gia_old && kl ==  kl_old)
    {
        //result=NO;
        NSString* mess = [utils.dic_language objectForKey:@"ipad.editOrder.samePrice"];
        message = [NSString stringWithFormat:@"%@\n%@",message, mess];
    }
    else if(kl <=  orderEntity.mQty)
    {
        message = [NSString stringWithFormat:@"%@\n%@",message, @"Khối lượng sửa phải lớn hơn khối lượng khớp."];
    }
    else if([orderEntity.marketId isEqualToString:@"HA"] && kl_old<100 && kl>=100)
        message = [NSString stringWithFormat:@"%@\n%@",message, @"Không được phép sửa lệnh lô lẻ thành lô chẵn."];
    else if([orderEntity.marketId isEqualToString:@"HA"] && kl_old>=100 && kl<100)
        message = [NSString stringWithFormat:@"%@\n%@",message, @"Không được phép sửa lệnh lô chẵn thành lô lẻ."];
    else
    {
        result=kl>0;
        if(!([orderEntity.type isEqualToString:@"L"] && kl<100 && [orderEntity.marketId isEqualToString:@"HA"])){//lo le san hnx
            if(result){
                float x = fmod(kl, stock4Order.block);
                result = x==0;
            }
            if(!result)
                message = [NSString stringWithFormat:@"%@\n%@",message, [NSString stringWithFormat:[utils.dic_language objectForKey:@"ipad.order.worngQty"],[utils.numberFormatter stringFromNumber:[NSNumber numberWithDouble:stock4Order.block]]]];
        }
    }
    result=YES;
    if([orderEntity.type isEqualToString:@"L"] && ([orderEntity.gtd isEqualToString:@""]||(![orderEntity.gtd isEqualToString:@""] && ![orderEntity.status isEqualToString:@"Không hiệu lực"])))
        result = (gia>=stock4Order.floor && gia <=stock4Order.ceiling);
    
    int step_value=0;
    if(result)
    {
        result = gia>0;
        if(result){
            gia = gia*1000;
            double step=0;
            double oldstep=0;
            if([orderEntity.marketId isEqualToString:@"HO"])
            {
                //result = NO;
                int i=0;
                for(id pricebyStep in [params.hoseStepPrice objectAtIndex:0])
                {
                    step = [pricebyStep doubleValue]*1000;
                    if(gia<step && gia>oldstep)
                    {
                        int pri = [[NSString stringWithFormat:@"%f", gia] intValue];
                        step_value = [[[params.hoseStepPrice objectAtIndex:1] objectAtIndex:i] doubleValue]*1000;
                        int x = pri% step_value;
                        
                        result= x==0;
                        if(!result) break;
                    }
                    oldstep=step;
                    i+=1;
                }
            }
            else if([orderEntity.marketId isEqualToString:@"HA"])
            {
                //result = NO;
                int i=0;
                for(id pricebyStep in [params.hnxStepPrice objectAtIndex:0])
                {
                    step = [pricebyStep doubleValue]*1000;
                    if(gia<step)
                    {
                        int pri = [[NSString stringWithFormat:@"%f", gia] intValue];
                        step_value = [[[params.hoseStepPrice objectAtIndex:1] objectAtIndex:i] doubleValue]*1000;
                        int x = pri% step_value;
                        
                        result= x==0;
                        if(!result) break;
                    }
                    i+=1;
                }
            }
            else if([orderEntity.marketId isEqualToString:@"OTC"])
            {
                //result = NO;
                int i=0;
                for(id pricebyStep in [params.upcomStepPrice objectAtIndex:0])
                {
                    step = [pricebyStep doubleValue]*1000;
                    if(gia<step)
                    {
                        int pri = [[NSString stringWithFormat:@"%f", gia] intValue];
                        step_value = [[[params.hoseStepPrice objectAtIndex:1] objectAtIndex:i] doubleValue]*1000;
                        int x = pri% step_value;
                        
                        result= x==0;
                        if(!result) break;
                    }
                    i+=1;
                }
            }
        }
        if(!result)
        {
            NSString *alert = [NSString stringWithFormat:[utils.dic_language objectForKey:@"ipad.order.worngStepPrice"],step_value];
            message = [NSString stringWithFormat:@"%@\n%@",message, alert];
        }
        else
            if(![[NSUserDefaults standardUserDefaults] boolForKey:@"saveOTP"])
            {
                if([otp_cancelEdit checkInput]){
                    BOOL result = [utils otpCherker:otp_cancelEdit.otp_number1.text OTPPosition2:otp_cancelEdit.otp_number2.text OTPPosition1_Value:otp_cancelEdit.otp_number1Value.text OTPPosition2_value:otp_cancelEdit.otp_number2Value.text isSave:NO];
                    if(!result)
                    {
                        [utils showMessage:[utils.dic_language objectForKey:@"ipad.otp.saveFail"] messageContent:nil ];
                        return NO;
                    }
                    
                }
                return NO;
            }
    }
    else
    {
        message = [NSString stringWithFormat:@"%@\n%@",message,[NSString stringWithFormat:[utils.dic_language objectForKey:@"ipad.order.worngPrice"],message
                                                                , [utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:stock4Order.floor]], [utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:stock4Order.ceiling]]]];
    }
    if([orderEntity.side isEqualToString:@"B"])
    {
        
        double gia_chenhlech=gia/1000-gia_old;
        double phi=[[NSUserDefaults standardUserDefaults] doubleForKey:@"tempFee"];
        
        double amountWithFee = kl*gia_chenhlech+kl*gia_chenhlech*phi/100;
        if(gia_chenhlech>0 && amountWithFee > stock4Order.usable)
        {
            result=NO;
            message =  [NSString stringWithFormat:@"%@\n%@",message, [NSString stringWithFormat:[utils.dic_language objectForKey:@"ipad.editOrder.worngBuyAmount"], [utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:stock4Order.usable]]]];
        }
    }
    if(message.length>0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Đặt lệnh không thành công!" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.contentMode = UIViewContentModeTopLeft;
        [alert show];
    }
    
    return message.length==0;
}
@catch (NSException *ex) {
    NSLog(@"Uncaught exception: %@", ex.description);NSLog(@"Stack trace: %@", [ex callStackSymbols]);
    
    return NO;
}
}
-(BOOL)checkInput
{
    @try{
    if([self.orderSide isEqualToString:@"E"])
    {
        NSCharacterSet * set = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet];
        if([self.txt_newPrice.text rangeOfCharacterFromSet:set].location != NSNotFound)
        {
            [utils showMessage:@"Giá đặt không hợp lệ" messageContent:nil];
            return NO;
        }
    }
    else{
        NSCharacterSet * set = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789,."] invertedSet];
        if([self.txt_gia.text rangeOfCharacterFromSet:set].location != NSNotFound)
        {
            [utils showMessage:@"Giá đặt không hợp lệ" messageContent:nil];
            return NO;
        }
        else if([self.txt_khoiLuong.text rangeOfCharacterFromSet:set].location != NSNotFound)
        {
            [utils showMessage:@"Khối lượng đặt không hợp lệ" messageContent:nil];
            return NO;
        }
    }
        return YES;
    }
    @catch (NSException *ex) {
        NSLog(@"Uncaught exception: %@", ex.description);NSLog(@"Stack trace: %@", [ex callStackSymbols]);
        return NO;
    }
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    @try{
    [self.txt_newPrice resignFirstResponder];
    [self.txt_gia resignFirstResponder];
    [self.txt_khoiLuong resignFirstResponder];
    [self.txt_ma resignFirstResponder];
    
    
    double kl=[[self.txt_khoiLuong.text stringByReplacingOccurrencesOfString:@"," withString:@"" ] doubleValue];
    self.txt_khoiLuong.text = [utils.numberFormatter stringFromNumber:[NSNumber numberWithDouble:kl]];
    kl=[[self.txt_gia.text stringByReplacingOccurrencesOfString:@"," withString:@"" ] doubleValue];
        self.txt_gia.text = [utils.numberFormatter1Digits stringFromNumber:[NSNumber numberWithDouble:kl]];
    }
    @catch (NSException *ex) {
        NSLog(@"Uncaught exception: %@", ex.description);NSLog(@"Stack trace: %@", [ex callStackSymbols]);
    }
}
- (IBAction)btn_cancel_touch:(id)sender {
    
    if([self.delegate isKindOfClass:[VDSCMainViewController class]])
        [mainview.popoverOrderController dismissPopoverAnimated:YES];
    else
        [((VDSCOrderView*)self.delegate).popoverController dismissPopoverAnimated:YES];
}
- (IBAction)btn_sideOrder_touch:(id)sender {
    UIButton *btn = (UIButton*)sender;
    if(btn.tag==0)
    {
        btn.tag=1;
        [btn setTitle:@"            Bán" forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"button-sell.png"] forState:UIControlStateNormal];
    }
    else
    {
        btn.tag=0;
        [btn setBackgroundImage:[UIImage imageNamed:@"btn-buy-sell.png"] forState:UIControlStateNormal];
        [btn setTitle:@"     Mua" forState:UIControlStateNormal];
    }
    [self txt_ma_ValueChanged:self.txt_ma];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.txt_gia setEnabled:[[self.f_loaiLenh_createOrder getOrderType] isEqualToString:@"LO"]];
    [self tinhTong];
}

- (IBAction)txt_ma_ValueChanged:(id)sender {
    stockEntity=nil;
    if(self.txt_ma.text.length >=3)
        [self loadStockInfo];
    //[self getStockInfo:self.txt_ma.text];
    
    [self tinhTong];
    
}
-(void) tinhTong
{
    @try{
    NSString *orderType=[[self.f_loaiLenh_createOrder getOrderType] isEqualToString:@"ATO"]?@"O":
    [[self.f_loaiLenh_createOrder getOrderType] isEqualToString:@"ATC"]?@"C":
    [[self.f_loaiLenh_createOrder getOrderType] isEqualToString:@"LO"]?@"L":@"M";
    if(![orderType isEqualToString:@"L"])
    {
        if(self.btn_sideOrder.tag==0)
            self.txt_gia.text= [NSString stringWithFormat:@"%@",[stockEntity.f_tran objectAtIndex:0]];
        else
            self.txt_gia.text= [NSString stringWithFormat:@"%@",[stockEntity.f_san objectAtIndex:0] ];
    }
    
    double kl=[[self.txt_khoiLuong.text stringByReplacingOccurrencesOfString:@"," withString:@"" ] doubleValue];
    double gia=[[self.txt_gia.text stringByReplacingOccurrencesOfString:@"," withString:@"" ] doubleValue];
    double phi=[[NSUserDefaults standardUserDefaults] doubleForKey:@"tempFee"];
    
    double tonggt = kl*gia+kl*gia*phi/100;
        self.f_tongTien.text = [NSString stringWithFormat:@"%@",[utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:tonggt]]];
    }
    @catch (NSException *ex) {
        NSLog(@"Uncaught exception: %@", ex.description);NSLog(@"Stack trace: %@", [ex callStackSymbols]);
    }
}
- (IBAction)btn_hieuLuc_touch:(id)sender {
    @try{
    VDSCPush2DateListViewController *popover_push2DateList =  [[self storyboard] instantiateViewControllerWithIdentifier:@"Push2DateList"];
    popover_push2DateList.delegate=self;
    popoverController = [[UIPopoverController alloc] initWithContentViewController:popover_push2DateList];
    CGRect rect=((UIButton*)sender).frame;//CGRectMake(((UIButton*)sender).frame.origin.x, ((UIButton*)sender).frame.origin.y+35, 50, 30);
        [popoverController presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    @catch (NSException *ex) {
        NSLog(@"Uncaught exception: %@", ex.description);NSLog(@"Stack trace: %@", [ex callStackSymbols]);
    }
}
- (IBAction)btn_cancelOrder_Confirm:(id)sender {
    @try{
    if(!cbv.checked){
        NSString* checkMarketStatus = [orderUtility checkOrderMarket: [self.f_loaiLenh_createOrder getOrderType] marketId:stockEntity.f_sanGD stockCode:self.txt_ma.text orderSide:(self.btn_sideOrder.tag==0?@"B":@"S")];
        if(checkMarketStatus.length>0){
            [utils showMessage:checkMarketStatus messageContent:nil dismissAfter:3];
            return;
        }}
    if([self checkInput])
    {
        NSString *orderType=[self.f_loaiLenh_createOrder getOrderType];
        double khoiluong =[[self.txt_khoiLuong.text stringByReplacingOccurrencesOfString:@"," withString:@"" ] doubleValue];
        double gia = [[self.txt_gia.text stringByReplacingOccurrencesOfString:@"," withString:@"" ] doubleValue];
        double giatri =[[self.f_tongTien.text stringByReplacingOccurrencesOfString:@"," withString:@"" ] doubleValue];
        
        [orderUtility sendOrder:orderType stockEntity:stockEntity params:params orderSide:(self.btn_sideOrder.tag==0?@"B":@"S") price:gia qty:khoiluong amountWithFee:giatri isGtdOrder:cbv.checked gtdDate:self.txt_hieuLuc.text otpView:otp_createOrder];
        
    }
    }
    @catch (NSException *ex) {
        NSLog(@"Uncaught exception: %@", ex.description);NSLog(@"Stack trace: %@", [ex callStackSymbols]);
    }
    
}

- (IBAction)btn_cancelOrder_cancel_touch:(id)sender
{
    [self clearInputData];
}
-(void)clearInputData
{
    self.txt_ma.text=@"";
    self.f_tongTien.text=self.f_tiLeVay.text=self.f_soDuCK.text=self.txt_gia.text = self.txt_khoiLuong.text=@"0";
    cbv.checked=NO;
    [otp_createOrder resetOtpPosition];
}
@end
