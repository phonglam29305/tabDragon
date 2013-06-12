//
//  VDSCOrderView.m
//  iPadDragon
//
//  Created by vdsc on 1/5/13.
//  Copyright (c) 2013 VDSC. All rights reserved.
//

#import "VDSCOrderView.h"
#import "HMSegmentedControl.h"
#import "M13Checkbox.h"
#import "OCCalendarViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CPPickerView.h"
#import "VDSCCommonUtils.h"
#import "TVPickerView.h"
#import "VDSCMachedOrderView.h"
#import "VDSCOrderHistoryView.h"
#import "VDSCCertificateCodeView.h"
#import "VDSCPriceBoardEntity.h"
#import "VDSCOrderTypeView.h"
#import "SSCheckBoxView.h"
#import "SSCheckBoxView.h"
#import "VDSCOrderEntity.h"
#import "VDSCEditOrderViewController.h"
#import "VDSCObjectStockBance.h"
#import "VDSCSystemParams.h"
#import "VDSCOTPView.h"
#import "VDSCMatchPriceByTimeViewController.h"
#import "VDSCOrderMatchPriceByTimeViewController.h"
#import "VDSCPush2DateListViewController.h"
#import "VDSCOrderUtility.h"
#import "ASIFormDataRequest.h"
#import "VDSCMainViewController.h"

#define kProgramaticallyAddedTvPickerViewTag 10

@interface VDSCOrderView()
{
    VDSCCommonUtils *utils;
    
    VDSCMachedOrderView *matchedOrderView;
    VDSCOrderHistoryView *orderHistory;
    VDSCCertificateCodeView *certificateCodeView;
    UIView *backgroundView;
    
    NSMutableArray *array_price;
    NSMutableArray *array_order;
    NSMutableArray *array_stock;
    NSMutableArray *array_stockMargin;
    NSMutableArray *array_matchPriceByTime;
    NSMutableData *webData_price;
    
    
    VDSCPriceBoardEntity *stockEntity;
    NSMutableData *webData_stock;
    NSURLConnection *connection_stock;
    
    UITextField *activeField;
    SSCheckBoxView *cbv;
    VDSCSystemParams *params;
    
    
    NSTimer *timer_order;
    
    VDSCOrderMatchPriceByTimeViewController *popover_orderMatchPriceByTime;
    VDSCPush2DateListViewController *popover_push2DateList;
    VDSCMatchPriceByTimeViewController *popover_matchPriceByTime;
    
    UIWebView *loading;
    VDSCOrderUtility *orderUtility;
    NSOperationQueue *queue;
}

@end
@implementation VDSCOrderView

@synthesize segmentedControl;
@synthesize otp;

@synthesize popoverController;

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
    orderUtility = [[VDSCOrderUtility alloc] init];
    orderUtility.utils = utils;
    orderUtility.delegate=self;
    params = [[VDSCSystemParams alloc] init];
    array_price = [[NSMutableArray alloc] init];
    self.arrayGtdDate = [[NSMutableArray alloc] init];
    array_order = [[NSMutableArray alloc] init];
    array_stock = [[NSMutableArray alloc] init];
    array_stockMargin = [[NSMutableArray alloc] init];
    array_matchPriceByTime = [[NSMutableArray alloc] init];
    self.table_todayOderList.delegate=self;
    self.table_todayOderList.dataSource = self;
    
    otp = [[[NSBundle mainBundle] loadNibNamed:@"VDSCOTPView" owner:self options:nil] objectAtIndex:0];
    otp.frame = CGRectMake(0, 0, 360, 30);
    [self.otpView addSubview:otp];
    
    [[self orderTab] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-menu.png"]]];
    [self.txt_ma addTarget:self action:@selector(txt_ma_ValueChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.txt_gia addTarget:self action:@selector(txt_ma_ValueChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.txt_khoiLuong addTarget:self action:@selector(txt_ma_ValueChanged:) forControlEvents:UIControlEventEditingChanged];
    
    [self.f_loaiLenh initSource:[NSArray arrayWithObjects:@"LO",@"ATO", @"ATC", @"MP", nil]];
    [self registerForKeyboardNotifications];
    self.txt_khoiLuong.delegate=self;
    self.txt_ma.delegate=self;
    self.txt_gia.delegate=self;
    self.txt_tuNgay.delegate=self;
    self.txt_denNgay.delegate=self;
    self.txt_hieuLuc.delegate=self;
    
    [self initControls];
    [self loadPriceBoard];
    [self loadDateList];
    loading = [utils showLoading:self.table_todayOderList];

    timer_order  = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(loadRealTimeData) userInfo:nil repeats:YES];
    [timer_order fire];
}
-(void) loadRealTimeData
{
    //NSLog(@"Load realtime data");
    [self loadOrders];
    
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
}

-(void) loadMarginStock
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *urlStr = [NSString stringWithFormat:@"%@",[user stringForKey:@"getMarginStock"]];
    
    NSArray *arr = [[NSArray alloc] initWithObjects:@"KW_CLIENTSECRET",utils.clientInfo.secret, @"KW_CLIENTID", utils.clientInfo.clientID, nil];
    NSString *post = [utils postValueBuilder:arr];
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIFormDataRequest *request_cash = [ASIFormDataRequest requestWithURL:url ];
    request_cash.tag=200;
    
    [request_cash addPostValue:[post substringFromIndex:5] forKey:@"info"];
    [request_cash setRequestMethod:@"POST"];
    [self grabURLInTheBackground:request_cash];
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
    request_cash.tag=300;
    
    [request_cash addPostValue:[post substringFromIndex:5] forKey:@"info"];
    [request_cash setRequestMethod:@"POST"];
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
    request_cash.tag=400;
    
    [request_cash addPostValue:[post substringFromIndex:5] forKey:@"info"];
    [request_cash setRequestMethod:@"POST"];
    [self grabURLInTheBackground:request_cash];
    
}

-(void)loadOrders
{
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *urlStr = [NSString stringWithFormat:@"%@",[user stringForKey:@"OrderTodayList"]];
    
    NSArray *arr = [[NSArray alloc] initWithObjects:@"KW_CLIENTSECRET",utils.clientInfo.secret, @"KW_CLIENTID", utils.clientInfo.clientID, nil];
    NSString *post = [utils postValueBuilder:arr];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIFormDataRequest *request_cash = [ASIFormDataRequest requestWithURL:url ];
    request_cash.tag=500;
    
    [request_cash addPostValue:[post substringFromIndex:5] forKey:@"info"];
    [request_cash setRequestMethod:@"POST"];
    [self grabURLInTheBackground:request_cash];
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
                if(![data isEqual:[NSNull null]])
                    for (NSArray *arrayOfEntity in data)
                    {
                        VDSCPriceBoardEntity *price = [[VDSCPriceBoardEntity alloc] init];
                        price.f_maCK = [arrayOfEntity objectAtIndex:0];
                        price.f_sanGD = [arrayOfEntity objectAtIndex:1];
                        [array_price addObject:price];
                        [price release];
                    }
                if(array_price!=nil && array_price.count>0)
                {
                    [self loadMarginStock];
                }
            }
        }
        else if(request.tag==200)
        {
            NSArray *data = [allDataDictionary objectForKey:@"list"];
            if([data isEqual:[NSNull null]]){return;}
            [array_stockMargin removeAllObjects];
            for (NSArray *arrayOfEntity in data)
            {
                [array_stockMargin addObject:arrayOfEntity];
            }
            
        }
        else if(request.tag==300)
        {
            bool success = [[allDataDictionary objectForKey:@"success"] boolValue];
            if(success)
            {
                self.f_sucMua.text = [utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:[[allDataDictionary objectForKey:@"BuyingPowerd"] doubleValue]]];
                
            }
        }
        else if(request.tag==400)
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
        else if(request.tag==500)
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
                        [array_order addObject:price];
                        [price release];
                    }
                    if(array_order!=nil && array_order.count>0)
                    {
                        [self.table_todayOderList reloadData];
                    }
                }
            }
        }
        else if(request.tag==600)
        {
            
        }
    }
    @catch (NSException *exception) {
        NSLog(exception.description);
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
    VDSCOrderEntity *order = [array_order objectAtIndex:indexPath.row];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, utils.rowHeight)];
    bgView.backgroundColor = [UIColor grayColor];
    [cell setBackgroundView:bgView];
    
    UIColor *color = [UIColor greenColor];
    if([order.side isEqualToString:@"S"]) color = [UIColor colorWithRed:212/255.0 green:10/255.0 blue:201/255.0 alpha:1];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 88, utils.rowHeight-1)];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [utils cellBackgroundColor];
    label.textColor = color;
    [label setFont:[UIFont fontWithName:utils.fontFamily size:utils.fontSize]];
    [cell addSubview:label];
    [label release];
    
    if([order.isCancel isEqualToString:@"Y"])
    {
        UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
        cancel.frame = CGRectMake(10, 3, 24, 24);
        [cancel setBackgroundImage:[UIImage imageNamed:@"btn-datlenh-cancel.png"] forState:UIControlStateNormal];
        cancel.tag = indexPath.row;
        [cancel addTarget:self action:@selector(cancelOrder:) forControlEvents:UIControlEventTouchUpInside];
        cancel.backgroundColor = [utils cellBackgroundColor];
        [cell addSubview:cancel];
        [cancel release];
    }
    if([order.isEdit isEqualToString:@"Y"])
    {
        UIButton *edit = [UIButton buttonWithType:UIButtonTypeCustom];
        edit.frame = CGRectMake(50, 3, 24, 24);
        [edit setBackgroundImage:[UIImage imageNamed:@"btn-datlenh-edit.png"] forState:UIControlStateNormal];
        edit.tag = indexPath.row;
        [edit addTarget:self action:@selector(editOrder:) forControlEvents:UIControlEventTouchUpInside];
        edit.backgroundColor = [utils cellBackgroundColor];
        [cell addSubview:edit];
        
        [edit release];
    }
    
    
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(89, 0, 76, utils.rowHeight-1)];
    label.text = order.stockId;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [utils cellBackgroundColor];
    label.textColor = color;
    [label setFont:[UIFont fontWithName:utils.fontFamily size:utils.fontSize]];
    [cell addSubview:label];
    [label release];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(label.frame.size.width+ label.frame.origin.x+1, 0, 87, utils.rowHeight-1)];
    label.text = [order.side isEqual:@"B"]?@"Mua":@"Bán";
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [utils cellBackgroundColor];
    label.textColor = color;
    [label setFont:[UIFont fontWithName:utils.fontFamily size:utils.fontSize]];
    [cell addSubview:label];
    [label release];
    
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(label.frame.size.width+ label.frame.origin.x+1, 0, 69, utils.rowHeight-1)];
    label.text = [NSString stringWithFormat:@"%@",[utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble: order.price]]];
    label.textAlignment = NSTextAlignmentRight;
    label.backgroundColor = [utils cellBackgroundColor];
    label.textColor = color;
    [label setFont:[UIFont fontWithName:utils.fontFamily size:utils.fontSize]];
    [cell addSubview:label];
    [label release];
    
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(label.frame.size.width+ label.frame.origin.x+1, 0, 71, utils.rowHeight-1)];
    label.text = [NSString stringWithFormat:@"%@",[utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble: order.qty]]];
    label.textAlignment = NSTextAlignmentRight;
    label.backgroundColor = [utils cellBackgroundColor];
    label.textColor = color;
    [label setFont:[UIFont fontWithName:utils.fontFamily size:utils.fontSize]];
    [cell addSubview:label];
    [label release];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(label.frame.size.width+ label.frame.origin.x+1, 0, 94, utils.rowHeight-1)];
    label.text = [NSString stringWithFormat:@"%@",[utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble: order.wQty]]];
    label.textAlignment = NSTextAlignmentRight;
    label.backgroundColor = [utils cellBackgroundColor];
    label.textColor = color;
    [label setFont:[UIFont fontWithName:utils.fontFamily size:utils.fontSize]];
    [cell addSubview:label];
    [label release];
    
    UIButton *edit = [UIButton buttonWithType:UIButtonTypeCustom];
    edit.frame = CGRectMake(label.frame.size.width+ label.frame.origin.x+1, 0, 80, utils.rowHeight-1);
    //[edit setBackgroundImage:[UIImage imageNamed:@"btn_edit_icon.png"] forState:UIControlStateNormal];
    edit.tag = indexPath.row;
    [edit setTitle:[NSString stringWithFormat:@"%@",[utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble: order.avgMPrice]]] forState:UIButtonTypeCustom];
    [edit addTarget:self action:@selector(btn_showOrderMatchPriceByTime:) forControlEvents:UIControlEventTouchUpInside];
    edit.titleLabel.textAlignment = NSTextAlignmentRight;
    edit.backgroundColor = [utils cellBackgroundColor];
    [cell addSubview:edit];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(edit.frame.size.width+ edit.frame.origin.x+1, 0, 94, utils.rowHeight-1)];
    label.text = [params getOrderStatus:order.status langue:0];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [utils cellBackgroundColor];
    label.textColor = color;
    [label setFont:[UIFont fontWithName:@"Arial" size:12.0f]];
    [cell addSubview:label];
    [label release];
    
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(label.frame.size.width+ label.frame.origin.x+1, 0, 82, utils.rowHeight-1)];
    label.text = [params getOrderType:order.marketId type: order.type];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [utils cellBackgroundColor];
    label.textColor = color;
    [label setFont:[UIFont fontWithName:utils.fontFamily size:utils.fontSize]];
    [cell addSubview:label];
    [label release];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(label.frame.size.width+ label.frame.origin.x+1, 0, 103, utils.rowHeight-1)];
    label.text = order.gtd;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [utils cellBackgroundColor];
    label.textColor = color;
    [label setFont:[UIFont fontWithName:utils.fontFamily size:utils.fontSize]];
    [cell addSubview:label];
    [label release];
    
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(label.frame.size.width+ label.frame.origin.x+1, 0, 128, utils.rowHeight-1)];
    label.text = order.time;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [utils cellBackgroundColor];
    label.textColor = color;
    [label setFont:[UIFont fontWithName:utils.fontFamily size:utils.fontSize]];
    [cell addSubview:label];
    [label release];
    
    return cell;
}
-(IBAction)cancelOrder:(id)sender
{
    UIButton *cancel = (UIButton*)sender;
    VDSCOrderEntity *order = [array_order objectAtIndex:cancel.tag];
    if(![order isEqual:[NSNull null]])
    {
        UITableViewCell *cell = [self.table_todayOderList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:cancel.tag inSection:0]];
        VDSCEditOrderViewController *editOrderController = [[self.delegate storyboard]instantiateViewControllerWithIdentifier:@"EditOrderView"];
        editOrderController.orderEntity = order;
        editOrderController.orderSide=@"C";
        editOrderController.params = params;
        [editOrderController setModalPresentationStyle:UIModalPresentationFormSheet];
        [editOrderController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
        //[self.delegate presentModalViewController:editOrderController animated:YES];
        editOrderController.delegate=self;
        //editOrderController.view.frame = CGRectMake(90, 140, 370, 320);
        
        popoverController = [[UIPopoverController alloc] initWithContentViewController:editOrderController];
        [popoverController presentPopoverFromRect:((UIButton*)sender).frame inView:cell permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        //[self performSelectorInBackground:@selector(loadOrders) withObject:nil];
        //[self.otpView setHidden:[[[NSUserDefaults standardUserDefaults] objectForKey:@"saveOTP"] boolValue]];
    }
}
-(IBAction)editOrder:(id)sender
{
    UIButton *cancel = (UIButton*)sender;
    VDSCOrderEntity *order = [array_order objectAtIndex:cancel.tag];
    if(![order isEqual:[NSNull null]])
    {
        
        UITableViewCell *cell = [self.table_todayOderList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:cancel.tag inSection:0]];
        VDSCEditOrderViewController *editOrderController = [[self.delegate storyboard]instantiateViewControllerWithIdentifier:@"EditOrderView"];
        editOrderController.orderEntity = order;
        editOrderController.orderSide=@"E";
        editOrderController.params = params;
        [editOrderController setModalPresentationStyle:UIModalPresentationFormSheet];
        [editOrderController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
        //[self.delegate presentModalViewController:editOrderController animated:YES];
        //editOrderController.view.frame = CGRectMake(90, 140, 370, 320);
        editOrderController.delegate=self;
        popoverController = [[UIPopoverController alloc] initWithContentViewController:editOrderController];
        [popoverController presentPopoverFromRect:((UIButton*)sender).frame inView:cell permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        //[self performSelectorInBackground:@selector(loadOrders) withObject:nil];
        //[self.otpView setHidden:[[[NSUserDefaults standardUserDefaults] objectForKey:@"saveOTP"] boolValue]];
    }
}
-(void) initControls
{
    //tab
    segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"    Lệnh     ", @"Lịch sử đặt lệnh", @"Lịch sử khớp lệnh", @"Xác nhận thẻ"]];
    [segmentedControl setFrame:CGRectMake(0, 0, 560, 30)];
    [segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [segmentedControl setTag:1];
    segmentedControl.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-menu.png"]];
    segmentedControl.textColor = [UIColor whiteColor];
    segmentedControl.font = [UIFont fontWithName:@"Arial" size:15];
    [self.orderTab addSubview:segmentedControl];
    
    
    //checkbox lenh cho
    CGRect frame = CGRectMake(940, 124, 50, 50);
    SSCheckBoxViewStyle style = (2 % kSSCheckBoxViewStylesCount);
    BOOL checked = NO;
    cbv = [[SSCheckBoxView alloc] initWithFrame:frame
                                          style:style
                                        checked:checked];
    [self.f_datLenh addSubview:cbv];
    self.f_loaiLenh.delegate = self;
    
}
- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return UIInterfaceOrientationIsPortrait(toInterfaceOrientation);
}

- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    switch (segmentedControl.selectedIndex) {
        case 1:
            if(orderHistory==nil)
            {
                orderHistory = [[[NSBundle mainBundle] loadNibNamed:@"VDSCOrderHistoryView" owner:self options:nil] objectAtIndex:0];
                orderHistory.frame = CGRectMake(0, 30, width, height-30);
                [self addSubview:orderHistory];
            }
            
            ((VDSCMainViewController*)self.delegate).activeView = orderHistory;
            [self bringSubviewToFront:orderHistory];
            break;
            
        case 2:
            if(matchedOrderView==nil)
            {
                matchedOrderView = [[[NSBundle mainBundle] loadNibNamed:@"VDSCMatchedOrderView" owner:self options:nil] objectAtIndex:0];
                matchedOrderView.frame = CGRectMake(0, 30, width, height-30);
                [self addSubview:matchedOrderView];
                matchedOrderView.params = params;
            }
            ((VDSCMainViewController*)self.delegate).activeView = matchedOrderView;
            [self bringSubviewToFront:matchedOrderView];
            break;
        case 3:
            
            if(backgroundView ==nil)
            {
                backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 30, width, height)];
                backgroundView.alpha = 0.5f;
                backgroundView.backgroundColor = [UIColor whiteColor];
                [self addSubview:backgroundView];
            }
            [self bringSubviewToFront:backgroundView];
            
            if(certificateCodeView==nil)
            {
                certificateCodeView = [[[NSBundle mainBundle] loadNibNamed:@"VDSCCertificateCodeView" owner:self options:nil] objectAtIndex:0];
                certificateCodeView.frame = CGRectMake(200, 140, 525, 324);
                certificateCodeView.backgroundColor = [UIColor clearColor];
                [self addSubview:certificateCodeView];
            }
            ((VDSCMainViewController*)self.delegate).activeView = certificateCodeView;
            [self bringSubviewToFront:certificateCodeView];
            if([[[NSUserDefaults standardUserDefaults] objectForKey:@"saveOTP"] boolValue])
            {
                [utils showMessage:[utils.dic_language objectForKey:@"ipad.otp.savedAlert"] messageContent:nil];
                [certificateCodeView setHidden:YES];
            }
            break;
        default:
            
            [self.otpView setHidden:[[[NSUserDefaults standardUserDefaults] objectForKey:@"saveOTP"] boolValue]];
            if(backgroundView !=nil){
                [backgroundView removeFromSuperview];
                [backgroundView release];backgroundView = nil;}
            if(matchedOrderView!=nil)
                [self sendSubviewToBack: matchedOrderView];
            if(orderHistory!=nil)
                [self sendSubviewToBack: orderHistory];
            if(certificateCodeView!=nil)
                [self sendSubviewToBack: certificateCodeView];
            break;
    }
	
}

- (IBAction)btn_hieuLuc_touch:(id)sender {
    
    popover_push2DateList =  [[self.superview.window.rootViewController storyboard] instantiateViewControllerWithIdentifier:@"Push2DateList"];
    if(popoverController!=nil){[popoverController release];popoverController = nil;}
    popover_push2DateList.delegate=self;
    popoverController = [[UIPopoverController alloc] initWithContentViewController:popover_push2DateList];
    CGRect rect=CGRectMake(((UIButton*)sender).frame.origin.x, ((UIButton*)sender).frame.origin.y+35, 50, 30);
    [popoverController presentPopoverFromRect:rect inView:self permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}
- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardCoViewWillRotateNotification object:nil];
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardCoViewDidRotateNotification object:nil];
}



#pragma mark - IBActions
- (IBAction)backgroundTouchDown:(id)sender {
    [self.txt_denNgay resignFirstResponder];
}


#pragma mark - UI Keyboard Co View Delegate
- (void) keyboardCoViewWillAppear:(UIKeyboardCoView*)keyboardCoView{
    NSLog(@"Keyboard Co View Will Appear");
}

- (void) keyboardCoViewDidAppear:(UIKeyboardCoView*)keyboardCoView{
    NSLog(@"Keyboard Co View Did Appear");
    for(UIView *view in self.scroll_keycorrect.subviews)
        [view removeFromSuperview];
}

- (void) keyboardCoViewWillDisappear:(UIKeyboardCoView*)keyboardCoView{
    NSLog(@"Keyboard Co View Will Disappear");
    for(UIView *view in self.scroll_keycorrect.subviews)
        [view removeFromSuperview];
}


- (void) keyboardCoViewDidDisappear:(UIKeyboardCoView*)keyboardCoView{
    NSLog(@"Keyboard Co View Did Disappear");
}


-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [webData_stock setLength:0];
}
-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Fail:********************");
}
-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [webData_stock  appendData:data];
}
-(void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSDictionary* allData = [[NSJSONSerialization JSONObjectWithData:webData_stock options:0 error:nil] retain];
    NSArray* arrayOfEntity = [allData objectForKey:@"stock"];
    if([arrayOfEntity isEqual:[NSNull null]])return;
    stockEntity = [[VDSCPriceBoardEntity alloc] init];
    stockEntity.f_tenCty = [allData objectForKey:@"name"];
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
    
    [self setCellValue:stockEntity];
    self.f_tiLeVay.text =@"0";
    for(NSArray *stock in array_stockMargin)
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
        }
        
    }
    
    [array_matchPriceByTime removeAllObjects];
    NSArray *array = [allData objectForKey:@"timing"];
    if(![array isEqual:[NSNull null]])
        for(int i=array.count-1; i>=0;i--)
        {
            [array_matchPriceByTime addObject:[array objectAtIndex:i]];
        }
    [self touchesBegan:0 withEvent:nil];
    [connection release];
}
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.txt_ma resignFirstResponder];
    [self.txt_gia resignFirstResponder];
    [self.txt_khoiLuong resignFirstResponder];
    [otp.otp_number1Value resignFirstResponder];
    [otp.otp_number2Value resignFirstResponder];
    
    if(matchedOrderView!=nil)
        [matchedOrderView touchesBegan:0 withEvent:nil];
    if(orderHistory!=nil)
        [orderHistory touchesBegan:0 withEvent:nil];
    
    double kl=[[self.txt_khoiLuong.text stringByReplacingOccurrencesOfString:@"," withString:@"" ] doubleValue];
    self.txt_khoiLuong.text = [utils.numberFormatter stringFromNumber:[NSNumber numberWithDouble:kl]];
    kl=[[self.txt_gia.text stringByReplacingOccurrencesOfString:@"," withString:@"" ] doubleValue];
    self.txt_gia.text = [utils.numberFormatter1Digits stringFromNumber:[NSNumber numberWithDouble:kl]];
}
-(void) loadStockInfo
{
    stockEntity = nil;
    NSString *code = self.txt_ma.text;
    NSString *temp=[[NSUserDefaults standardUserDefaults] stringForKey:@"stock_fullInfo"];
    NSString *urlStr= [NSString stringWithFormat:temp, code];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    connection_stock = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if(connection_stock)
    {
        webData_stock = [[NSMutableData alloc] init];
    }
    
    
}
-(void) setCellValue:(VDSCPriceBoardEntity *) price
{
    @try{
        if (price!=nil) {
            
            self.f_tenCty.text=price.f_tenCty;
            
            self.f_maCK.text= [price.f_ma objectAtIndex:0];
            self.f_mua3_gia.text= [NSString stringWithFormat:@"%@",[price.f_mua3_gia objectAtIndex:0]];
            double d = [[price.f_mua3_kl objectAtIndex:0] doubleValue]/10;
            self.f_mua3_kl.text= [NSString stringWithFormat:@"%@",[utils.numberFormatter2Digits stringFromNumber:[NSNumber numberWithDouble:d]]];
            
            self.f_mua2_gia.text= [NSString stringWithFormat:@"%@",[utils.numberFormatter2Digits stringFromNumber:[NSNumber numberWithDouble: [[price.f_mua2_gia  objectAtIndex:0] doubleValue]]]];
            d = [[price.f_mua2_kl objectAtIndex:0] doubleValue]/10;
            self.f_mua2_kl.text=[NSString stringWithFormat:@"%@",[utils.numberFormatter2Digits  stringFromNumber:[NSNumber numberWithDouble:d]]];
            
            self.f_mua1_gia.text= [NSString stringWithFormat:@"%@",[utils.numberFormatter2Digits stringFromNumber:[NSNumber numberWithDouble: [[price.f_mua1_gia  objectAtIndex:0] doubleValue]]]];
            d = [[price.f_mua1_kl objectAtIndex:0] doubleValue]/10;
            self.f_mua1_kl.text=[NSString stringWithFormat:@"%@",[utils.numberFormatter2Digits stringFromNumber:[NSNumber numberWithDouble:d]]];
            
            
            self.f_kl_gia.text= [NSString stringWithFormat:@"%@",[utils.numberFormatter2Digits stringFromNumber:[NSNumber numberWithDouble: [[price.f_kl_gia  objectAtIndex:0] doubleValue]]]];
            self.f_kl_gia_1.text= [NSString stringWithFormat:@"%@",[utils.numberFormatter2Digits stringFromNumber:[NSNumber numberWithDouble: [[price.f_kl_gia  objectAtIndex:0] doubleValue]]]];
            d = [[price.f_kl_kl objectAtIndex:0] doubleValue]/10;
            self.f_kl_kl_1.text=[NSString stringWithFormat:@"%@",[utils.numberFormatter2Digits stringFromNumber:[NSNumber numberWithDouble:d]]];
            //NSString *per = [price.f_kl_tangGiam objectAtIndex:0]
            self.f_kl_tangGiam.text= [NSString stringWithFormat:@"(%@)" ,[price.f_kl_tangGiam objectAtIndex:0]];
            d = [[price.f_kl_tongkl objectAtIndex:0] doubleValue]/10;
            self.f_tongKL.text=[NSString stringWithFormat:@"%@",[utils.numberFormatter2Digits stringFromNumber:[NSNumber numberWithDouble:d]]];
            
            d = [[price.f_ban1_kl objectAtIndex:0] doubleValue]/10;
            self.f_ban1_kl.text= [NSString stringWithFormat:@"%@",[utils.numberFormatter2Digits stringFromNumber:[NSNumber numberWithDouble:d]]];
            self.f_ban1_gia.text= [NSString stringWithFormat:@"%@",[utils.numberFormatter2Digits stringFromNumber:[NSNumber numberWithDouble: [[price.f_ban1_gia  objectAtIndex:0] doubleValue]]]];
            d = [[price.f_ban2_kl objectAtIndex:0] doubleValue]/10;
            self.f_ban2_kl.text=[NSString stringWithFormat:@"%@",[utils.numberFormatter2Digits stringFromNumber:[NSNumber numberWithDouble:d]]];
            self.f_ban2_gia.text= [NSString stringWithFormat:@"%@",[utils.numberFormatter2Digits stringFromNumber:[NSNumber numberWithDouble: [[price.f_ban2_gia  objectAtIndex:0] doubleValue]]]];
            d = [[price.f_ban3_kl objectAtIndex:0] doubleValue]/10;
            self.f_ban3_kl.text=[NSString stringWithFormat:@"%@",[utils.numberFormatter2Digits stringFromNumber:[NSNumber numberWithDouble:d]]];
            self.f_ban3_gia.text= [NSString stringWithFormat:@"%@",[utils.numberFormatter2Digits stringFromNumber:[NSNumber numberWithDouble: [[price.f_ban3_gia  objectAtIndex:0] doubleValue]]]];
            
            
            self.f_thamChieu.text= [NSString stringWithFormat:@"%@",[utils.numberFormatter2Digits stringFromNumber:[NSNumber numberWithDouble: [[price.f_thamchieu  objectAtIndex:0] doubleValue]]]];
            self.f_tran.text= [NSString stringWithFormat:@"%@",[utils.numberFormatter2Digits stringFromNumber:[NSNumber numberWithDouble: [[price.f_tran  objectAtIndex:0] doubleValue]]]];
            self.f_san.text= [NSString stringWithFormat:@"%@",[utils.numberFormatter2Digits stringFromNumber:[NSNumber numberWithDouble: [[price.f_san  objectAtIndex:0] doubleValue]]]];
            self.f_thap.text= [NSString stringWithFormat:@"%@",[utils.numberFormatter2Digits stringFromNumber:[NSNumber numberWithDouble: [[price.f_thap  objectAtIndex:0] doubleValue]]]];
            self.f_cao.text= [NSString stringWithFormat:@"%@",[utils.numberFormatter2Digits stringFromNumber:[NSNumber numberWithDouble: [[price.f_cao  objectAtIndex:0] doubleValue]]]];
            self.f_trungBinh.text= [NSString stringWithFormat:@"%@",[utils.numberFormatter2Digits stringFromNumber:[NSNumber numberWithDouble: [[price.f_trungBinh  objectAtIndex:0] doubleValue]]]];
            
            [utils setLabelColor:[price.f_ma objectAtIndex:1] label:self.f_maCK];
            [utils setLabelColor:[price.f_mua3_gia objectAtIndex:1] label:self.f_mua3_gia];
            [utils setLabelColor:[price.f_mua3_kl objectAtIndex:1] label:self.f_mua3_kl];
            [utils setLabelColor:[price.f_mua2_gia objectAtIndex:1] label:self.f_mua2_gia];
            [utils setLabelColor:[price.f_mua2_kl objectAtIndex:1] label:self.f_mua2_kl];
            [utils setLabelColor:[price.f_mua1_gia objectAtIndex:1] label:self.f_mua1_gia];
            [utils setLabelColor:[price.f_mua1_kl objectAtIndex:1] label:self.f_mua1_kl];
            
            [utils setLabelColor:[price.f_kl_gia objectAtIndex:1] label:self.f_kl_gia];
            [utils setLabelColor:[price.f_kl_gia objectAtIndex:1] label:self.f_kl_gia_1];
            [utils setLabelColor:[price.f_kl_kl objectAtIndex:1] label:self.f_kl_kl_1];
            [utils setLabelColor:[price.f_kl_tangGiam objectAtIndex:1] label:self.f_kl_tangGiam];
            [utils setLabelColor:[price.f_kl_tongkl objectAtIndex:1] label:self.f_tongKL];
            
            [utils setLabelColor:[price.f_ban3_gia objectAtIndex:1] label:self.f_ban3_gia];
            [utils setLabelColor:[price.f_ban3_kl objectAtIndex:1] label:self.f_ban3_kl];
            [utils setLabelColor:[price.f_ban2_gia objectAtIndex:1] label:self.f_ban2_gia];
            [utils setLabelColor:[price.f_ban2_kl objectAtIndex:1] label:self.f_ban2_kl];
            [utils setLabelColor:[price.f_ban1_gia objectAtIndex:1] label:self.f_ban1_gia];
            [utils setLabelColor:[price.f_ban1_kl objectAtIndex:1] label:self.f_ban1_kl];
            
            
            [utils setLabelColor:[price.f_tran objectAtIndex:1] label:self.f_tran];
            [utils setLabelColor:[price.f_san objectAtIndex:1] label:self.f_san];
            [utils setLabelColor:[price.f_trungBinh objectAtIndex:1] label:self.f_trungBinh];
            [utils setLabelColor:[price.f_thamchieu objectAtIndex:1] label:self.f_thamChieu];
            [utils setLabelColor:[price.f_thap objectAtIndex:1] label:self.f_thap];
            [utils setLabelColor:[price.f_cao objectAtIndex:1] label:self.f_cao];
            
            float ban=[[price.f_ban1_kl objectAtIndex:0] floatValue]
            +[[price.f_ban2_kl objectAtIndex:0] floatValue]
            +[[price.f_ban3_kl objectAtIndex:0] floatValue]
            +[[price.f_ban4_kl objectAtIndex:0] floatValue];
            float mua=[[price.f_mua1_kl objectAtIndex:0] floatValue]
            +[[price.f_mua2_kl objectAtIndex:0] floatValue]
            +[[price.f_mua3_kl objectAtIndex:0] floatValue]
            +[[price.f_mua4_kl objectAtIndex:0] floatValue];
            
            float per = mua*100/(ban+mua);
            float width = self.process_mua.frame.size.width+self.process_ban.frame.size.width;
            //NSLog([NSString stringWithFormat:@"%f",per]);
            
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            [formatter setMaximumFractionDigits:1];
            [formatter setRoundingMode: NSNumberFormatterRoundHalfEven];
            
            int mua_width = [[formatter stringFromNumber:[NSNumber numberWithFloat: width*per/100]] intValue];
            int per_int = [[formatter stringFromNumber:[NSNumber numberWithFloat: per]] intValue];
            
            self.process_mua.frame = CGRectMake(self.process_mua.frame.origin.x, self.process_mua.frame.origin.y, mua_width, self.process_mua.frame.size.height);
            self.process_mua.text = [NSString stringWithFormat:@"%d%%",per_int];
            
            self.process_ban.frame=CGRectMake(self.process_mua.frame.origin.x+self.process_mua.frame.size.width+1, self.process_ban.frame.origin.y, width-self.process_mua.frame.size.width, self.process_mua.frame.size.height);
            self.process_ban.text = [NSString stringWithFormat:@"%d%%",100-per_int];
            
        }
    }
    @catch (NSException *ex) {
        //NSLog(ex.description);
    }
}
- (IBAction)txt_ma_ValueChanged:(id)sender {
    
    if(sender == self.txt_ma)
    {
        stockEntity=nil;
        if(array_price!=nil && array_price.count>0)
        {
            NSString *code = self.txt_ma.text;
            
            NSMutableArray *array = [[NSMutableArray alloc] init];
            
            for(VDSCPriceBoardEntity *entity in array_price)
            {
                NSString *stock =entity.f_maCK;
                if([stock rangeOfString:code].location != NSNotFound)
                {
                    [array addObject:stock];
                }
            }
            for(UIView *view in self.scroll_keycorrect.subviews)
                [view removeFromSuperview];
            int with=0;
            for(NSString *stock in array)
            {
                UIButton *label = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                [label setTitle: stock forState:UIControlStateNormal ] ;
                label.frame = CGRectMake(43+70*with+2*with, 5, 70, 25);
                [label addTarget:self action:@selector(stock_touchInside:) forControlEvents:UIControlEventTouchUpInside];
                label.tag=0;
                [label setBackgroundColor:[UIColor darkGrayColor]];
                [self.scroll_keycorrect addSubview:label];
                //[label release];
                with +=1;
            }
            [self.scroll_keycorrect setContentSize:CGSizeMake((43+70*with+2*with)+70, self.scroll_keycorrect.frame.size.height)];
            if(self.txt_ma.text.length >=3)
                [self loadStockInfo];
            
            [self tinhTong];
        }
    }
    else{
                [self tinhTong];
    }
}
- (IBAction)stock_touchInside:(id)sender {
    //text ma chung khoan
    if(((UIButton*)sender).tag==0)
    {
        self.txt_ma.text = ((UIButton*)sender).titleLabel.text;
        [self.txt_ma resignFirstResponder];
    }
    //khoi luong
    else if(((UIButton*)sender).tag==1)
    {
        UIButton *btn = sender;
        double qty = [[self.txt_khoiLuong.text stringByReplacingOccurrencesOfString:@"," withString:@"" ] doubleValue];
        if([[btn.titleLabel.text substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"+"])
        {
            double value = [[[btn.titleLabel.text substringWithRange:NSMakeRange(1, [btn.titleLabel.text length]-1)] stringByReplacingOccurrencesOfString:@"," withString:@"" ] doubleValue];
            qty += value;
        }
        else if([[btn.titleLabel.text substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"-"])
        {
            double value = [[[btn.titleLabel.text substringWithRange:NSMakeRange(1, [btn.titleLabel.text length]-1)] stringByReplacingOccurrencesOfString:@"," withString:@"" ] doubleValue];
            qty -= value;
            if(qty<0)
                qty=0;
        }
        self.txt_khoiLuong.text = [NSString stringWithFormat:@"%@",[utils.numberFormatter stringFromNumber:[NSNumber numberWithDouble: qty]]];
        
        
    }
    //gia
    else if(((UIButton*)sender).tag==2)
    {
        UIButton *btn = sender;
        if([btn.titleLabel.text isEqualToString:@"Trần"])
        {
            self.txt_gia.text = [NSString stringWithFormat:@"%@",[utils.numberFormatter1Digits stringFromNumber:[NSNumber numberWithDouble:[[stockEntity.f_tran objectAtIndex:0] doubleValue]]]];
        }
        else
            if([btn.titleLabel.text isEqualToString:@"Sàn"])
            {
                self.txt_gia.text = [NSString stringWithFormat:@"%@",[utils.numberFormatter1Digits stringFromNumber:[NSNumber numberWithDouble:[[stockEntity.f_san objectAtIndex:0] doubleValue]]]];
            }
            else
                if([btn.titleLabel.text isEqualToString:@"Tham chiếu"])
                {
                    self.txt_gia.text = [NSString stringWithFormat:@"%@",[utils.numberFormatter1Digits stringFromNumber:[NSNumber numberWithDouble:[[stockEntity.f_thamchieu objectAtIndex:0] doubleValue]]]];
                }
                else
                {
                    double qty = [[self.txt_gia.text stringByReplacingOccurrencesOfString:@"," withString:@"" ] doubleValue];
                    if([[btn.titleLabel.text substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"+"])
                    {
                        double value = [[[btn.titleLabel.text substringWithRange:NSMakeRange(1, [btn.titleLabel.text length]-1)] stringByReplacingOccurrencesOfString:@"," withString:@"" ] doubleValue];
                        qty += value;
                    }
                    else if([[btn.titleLabel.text substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"-"])
                    {
                        double value = [[[btn.titleLabel.text substringWithRange:NSMakeRange(1, [btn.titleLabel.text length]-1)] stringByReplacingOccurrencesOfString:@"," withString:@"" ] doubleValue];
                        qty -= value;
                        if(qty<0)
                            qty=0;
                    }
                    self.txt_gia.text = [NSString stringWithFormat:@"%@",[utils.numberFormatter1Digits stringFromNumber:[NSNumber numberWithDouble: qty]]];
                    
                }
    }
    [self tinhTong];
}
-(void) tinhTong
{
    NSString *orderType=[[self.f_loaiLenh getOrderType] isEqualToString:@"ATO"]?@"O":
    [[self.f_loaiLenh getOrderType] isEqualToString:@"ATC"]?@"C":
    [[self.f_loaiLenh getOrderType] isEqualToString:@"LO"]?@"L":@"M";
    if(![orderType isEqualToString:@"L"])
    {
        if(stockEntity==nil)
        {self.txt_gia.text=@"0";}
        else
            if(self.btn_sideOrder.tag==0)
                self.txt_gia.text= [NSString stringWithFormat:@"%@",[stockEntity.f_tran objectAtIndex:0]];
            else
                self.txt_gia.text= [NSString stringWithFormat:@"%@",[stockEntity.f_san objectAtIndex:0]];
    }
    
    double kl= [[[utils.numberFormatter stringFromNumber:[NSNumber numberWithDouble:[[self.txt_khoiLuong.text stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue]]]stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
    double gia=[[self.txt_gia.text stringByReplacingOccurrencesOfString:@"," withString:@"" ] doubleValue];
    double phi=[[NSUserDefaults standardUserDefaults] doubleForKey:@"tempFee"];
    
    double tonggt = kl*gia+kl*gia*phi/100;
    if(self.btn_sideOrder.tag==1)
        tonggt = kl*gia;
    self.f_tongTien.text = [NSString stringWithFormat:@"%@",[utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:tonggt]]];
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
}

-(void)unregisterForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = textField;
    for(UIView *view in self.scroll_keycorrect.subviews)
        [view removeFromSuperview];
    if(activeField == self.txt_gia)
    {
        if([self.txt_gia.text isEqualToString:@"0"])self.txt_gia.text=@"";
        int with=0;
        NSArray *arr = [[NSArray alloc] initWithObjects:@"+0.1",@"+0.5",@"+1",@"+10", @"+50",@"-0.1",@"-0.5",@"-1",@"-10",@"-50",@"Trần",@"Sàn", @"Tham chiếu", nil];
        for(NSString *stock in arr)
        {
            UIButton *label = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [label setTitle: stock forState:UIControlStateNormal ] ;
            label.frame = CGRectMake(43+74*with+2*with, 5, 74, 25);
            [label addTarget:self action:@selector(stock_touchInside:) forControlEvents:UIControlEventTouchUpInside];
            label.tag=2;
            [label setBackgroundColor:[UIColor darkGrayColor]];
            label.titleLabel.font = [UIFont systemFontOfSize:13];
            [self.scroll_keycorrect addSubview:label];
            with +=1;
        }
        [self.scroll_keycorrect setContentSize:CGSizeMake((43+74*with+2*with)+74, self.scroll_keycorrect.frame.size.height)];
        
    }
    else if(activeField == self.txt_khoiLuong)
    {
        int with=0;
        if([self.txt_khoiLuong.text isEqualToString:@"0"])self.txt_khoiLuong.text=@"";
        NSArray *arr = [[NSArray alloc] initWithObjects:@"+10",@"+100",@"+500",@"+1,000",@"+10,000",@"+100,000", @"-10",@"-100",@"-500",@"-1,000",@"-10,000",@"-100,000",nil];
        for(NSString *stock in arr)
        {
            UIButton *label = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [label setTitle: stock forState:UIControlStateNormal ] ;
            label.frame = CGRectMake(43+80*with+2*with, 5, 80, 25);
            [label addTarget:self action:@selector(stock_touchInside:) forControlEvents:UIControlEventTouchUpInside];
            label.tag=1;
            [label setBackgroundColor:[UIColor darkGrayColor]];
            label.titleLabel.font = [UIFont systemFontOfSize:15];
            [self.scroll_keycorrect addSubview:label];
            with +=1;
        }
        [self.scroll_keycorrect setContentSize:CGSizeMake((43+80*with+2*with)+80, self.scroll_keycorrect.frame.size.height)];
        [arr release];
    }
    
    if(activeField == self.txt_tuNgay||activeField == self.txt_denNgay||activeField == self.txt_hieuLuc)
    {
        [self.scroll_keycorrect setHidden:YES];
    }
    else [self.scroll_keycorrect setHidden:NO];
}
- (void)keyboardWillShown:(NSNotification*)aNotification
{
    //if(activeField == self.txt_tuNgay || activeField == self.txt_denNgay || activeField == txt_hie)
    //for(UIView *view in self.scroll_keycorrect.subviews)
    //    [view removeFromSuperview];
}

-(BOOL)checkInput
{
    
    NSCharacterSet * set = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789.,"] invertedSet];
    if([self.txt_gia.text rangeOfCharacterFromSet:set].location != NSNotFound)
    {
        [utils showMessage:@"Giá đặt không hợp lệ" messageContent:nil];
        return NO;
    }
    else
    {
        set = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789,"] invertedSet];
        if([self.txt_khoiLuong.text rangeOfCharacterFromSet:set].location != NSNotFound)
        {
            [utils showMessage:@"Khối lượng đặt không hợp lệ" messageContent:nil];
            return NO;
        }
    }
    
    return YES;
}
- (IBAction)btn_OrderConfirm:(id)sender {
    
    if([self checkInput]){
        NSString *orderType=[[self.f_loaiLenh getOrderType] isEqualToString:@"ATO"]?@"O":
        [[self.f_loaiLenh getOrderType] isEqualToString:@"ATC"]?@"C":
        [[self.f_loaiLenh getOrderType] isEqualToString:@"LO"]?@"L":@"M";
        double khoiluong =[[self.txt_khoiLuong.text stringByReplacingOccurrencesOfString:@"," withString:@"" ] doubleValue];
        double gia = [[self.txt_gia.text stringByReplacingOccurrencesOfString:@"," withString:@"" ] doubleValue];
        double giatri =[[self.f_tongTien.text stringByReplacingOccurrencesOfString:@"," withString:@"" ] doubleValue];
        
        [orderUtility sendOrder:orderType stockEntity:stockEntity params:params orderSide:(self.btn_sideOrder.tag==0?@"B":@"S") price:gia qty:khoiluong amountWithFee:giatri isGtdOrder:cbv.checked gtdDate:self.txt_hieuLuc.text otpView:otp];
        /*{
         [self loadOrders];
         [self clearInputData];
         }
         else [otp resetOtpPosition];*/
        
    }
}
-(void)clearInputData
{
    self.txt_ma.text=@"";
    self.f_sucMua.text= self.f_tongTien.text=self.f_tiLeVay.text=self.f_soDuCK.text=self.txt_gia.text = self.txt_khoiLuong.text=@"0";
    cbv.checked=NO;
    stockEntity = nil;
    [otp resetOtpPosition];
}
- (IBAction)btn_showMatchPriceByTime:(id)sender {
    if(array_matchPriceByTime!=nil && array_matchPriceByTime.count>0)
    {
        //if(popover_matchPriceByTime==nil)
        popover_matchPriceByTime = [[self.superview.window.rootViewController storyboard] instantiateViewControllerWithIdentifier:@"MatchPriceByTime"];
        popover_matchPriceByTime.dataSource = array_matchPriceByTime;
        [popover_matchPriceByTime.table_accList reloadData];
        if(popoverController!=nil){[popoverController release];popoverController = nil;}
        popoverController = [[UIPopoverController alloc] initWithContentViewController:popover_matchPriceByTime];
        CGRect rect=CGRectMake(((UIButton*)sender).frame.origin.x, ((UIButton*)sender).frame.origin.y+35, 50, 30);
        [popoverController presentPopoverFromRect:rect inView:self permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}- (IBAction)btn_showOrderMatchPriceByTime:(id)sender {
    for(VDSCOrderEntity *data in array_order){
        
        int i = [array_order indexOfObject:data];
        NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];
        UITableViewCell *cell =[self.table_todayOderList cellForRowAtIndexPath:index];
        [cell setSelected:NO];
    }
    UITableViewCell *cell = (UITableViewCell*)[((UIButton*)sender) superview];
    //[cell setSelected:YES];
    //if(popover_orderMatchPriceByTime)
    popover_orderMatchPriceByTime = [[self.superview.window.rootViewController storyboard] instantiateViewControllerWithIdentifier:@"OrderMatchPriceByTime"];
    VDSCOrderEntity *order = [array_order objectAtIndex:((UIButton*)sender).tag];
    popover_orderMatchPriceByTime.orderEntity = order;
    if(popoverController!=nil){[popoverController release];popoverController = nil;}
    popoverController= [[UIPopoverController alloc] initWithContentViewController:popover_orderMatchPriceByTime];
    CGRect rect=CGRectMake(((UIButton*)sender).frame.origin.x+20, ((UIButton*)sender).frame.origin.y+10, 50, 30);
    [popoverController presentPopoverFromRect:rect inView:cell permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
    [((UIButton*)sender) setHighlighted:NO];
    
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
    [self.txt_gia setEnabled:[[self.f_loaiLenh getOrderType] isEqualToString:@"LO"]];
    [self tinhTong];
}
- (void)dealloc {
    [_orderTab release];
    [_f_datLenh release];
    [_f_tuNgay release];
    [_f_searchBar release];
    [_btn_tuNgay release];
    [_txt_tuNgay release];
    [_txt_denNgay release];
    [_txt_hieuLuc release];
    [_f_loaiLenh release];
    [_scroll_keycorrect release];
    [_txt_ma release];
    [_txt_khoiLuong release];
    [_txt_gia release];
    [self unregisterForKeyboardNotifications];
    [activeField release];
    [_table_todayOderList release];
    //[_seg_orderSide release];
    [_f_sucMua release];
    [_f_soDuCK release];
    [_f_tongTien release];
    [otp release];
    [_f_tiLeVay release];
    [_otpView release];
    [_btn_sideOrder release];
    [timer_order invalidate];
    timer_order = nil;
    [queue release];
    if(popoverController!=nil){[popoverController release];popoverController = nil;}
    if(popover_push2DateList!=nil){[popover_push2DateList release];popover_push2DateList = nil;}
    if(popover_matchPriceByTime!=nil){[popover_matchPriceByTime release];popover_matchPriceByTime = nil;}
    if(popover_orderMatchPriceByTime!=nil){[popover_orderMatchPriceByTime release];popover_orderMatchPriceByTime = nil;}
    
    [super dealloc];
}
- (IBAction)btn_cancel_touch:(id)sender {
    [self clearInputData];
}
@end
