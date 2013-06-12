//
//  VDSCFullPriceBoard_PopoverViewController.m
//  iPadDragon
//
//  Created by vdsc on 1/2/13.
//  Copyright (c) 2013 VDSC. All rights reserved.
//

#import "VDSCFullPriceBoard_PopoverViewController.h"
#import "VDSCCommonUtils.h"
#import "VDSCMainViewController.h"
#import "VDSCStock4OrderEntity.h"
#import "VDSCPriceBoardEntity.h"

@interface VDSCFullPriceBoard_PopoverViewController ()
{
    VDSCCommonUtils *utils;
    VDSCPriceBoardEntity *stockEntity;
    NSTimer *timer;
}
@end

@implementation VDSCFullPriceBoard_PopoverViewController
@synthesize priceEntity;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    utils = [[VDSCCommonUtils alloc] init];
    //stockEntity = [priceEntity copy];
    //[self assignDataToControl];
    
    timer  = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(loadStockInfo) userInfo:nil repeats:YES];
    [timer fire];
}

-(void)assignDataToControl
{
    if(stockEntity == nil)
    {
        stockEntity = priceEntity;
        [self loadChart:stockEntity.f_maCK];
    }
    //{
    stockEntity.f_sanGD = [((VDSCMainViewController*)self.delegate) getMarketByStock:stockEntity.f_maCK];
    self.f_ma.text= [NSString stringWithFormat:@"%@",[stockEntity.f_ma objectAtIndex:0]];
    self.f_kl_gia.text= [NSString stringWithFormat:@"%@",[utils.numberFormatter2Digits stringFromNumber:[NSNumber numberWithDouble: [[stockEntity.f_kl_gia  objectAtIndex:0] doubleValue]]]];
    self.f_thamChieu.text= [NSString stringWithFormat:@"%@",[utils.numberFormatter2Digits stringFromNumber:[NSNumber numberWithDouble: [[stockEntity.f_thamchieu  objectAtIndex:0] doubleValue]]]];
    self.f_tran.text= [NSString stringWithFormat:@"%@",[utils.numberFormatter2Digits stringFromNumber:[NSNumber numberWithDouble: [[stockEntity.f_tran  objectAtIndex:0] doubleValue]]]];
    self.f_san.text= [NSString stringWithFormat:@"%@",[utils.numberFormatter2Digits stringFromNumber:[NSNumber numberWithDouble: [[stockEntity.f_san  objectAtIndex:0] doubleValue]]]];
    self.f_thap.text= [NSString stringWithFormat:@"%@",[utils.numberFormatter2Digits stringFromNumber:[NSNumber numberWithDouble: [[stockEntity.f_thap  objectAtIndex:0] doubleValue]]]];
    self.f_cao.text= [NSString stringWithFormat:@"%@",[utils.numberFormatter2Digits stringFromNumber:[NSNumber numberWithDouble: [[stockEntity.f_cao  objectAtIndex:0] doubleValue]]]];
    self.f_trungBinh.text= [NSString stringWithFormat:@"%@",[utils.numberFormatter2Digits stringFromNumber:[NSNumber numberWithDouble: [[stockEntity.f_trungBinh  objectAtIndex:0] doubleValue]]]];
    if([[stockEntity.f_kl_tangGiam objectAtIndex:0] doubleValue]==0)self.f_kl_tangGiam.text=@"";
    else self.f_kl_tangGiam.text= [NSString stringWithFormat:@"(%@)",[stockEntity.f_kl_tangGiam objectAtIndex:0]];
    double d = [[stockEntity.f_kl_tongkl objectAtIndex:0] doubleValue]/10;
    self.f_tongKL.text=[NSString stringWithFormat:@"%@",[utils.numberFormatter2Digits stringFromNumber:[NSNumber numberWithDouble:d]]];
    
    if([[stockEntity.f_ma objectAtIndex:1] isEqualToString:@"Z"])
    {
        [self.f_ma setBackgroundColor:[UIColor greenColor]];
        self.f_ma.textColor=[UIColor blueColor];
    }
    else
        [utils setLabelColor:[stockEntity.f_ma objectAtIndex:1] label:self.f_ma];
    
    
    [utils setLabelColor:[stockEntity.f_kl_gia objectAtIndex:1] label:self.f_kl_gia];
    [utils setLabelColor:[stockEntity.f_kl_tangGiam objectAtIndex:1] label:self.f_kl_tangGiam];
    
    [utils setLabelColor:[stockEntity.f_tran objectAtIndex:1] label:self.f_tran];
    [utils setLabelColor:[stockEntity.f_san objectAtIndex:1] label:self.f_san];
    [utils setLabelColor:[stockEntity.f_trungBinh objectAtIndex:1] label:self.f_trungBinh];
    [utils setLabelColor:[stockEntity.f_thamchieu objectAtIndex:1] label:self.f_thamChieu];
    [utils setLabelColor:[stockEntity.f_thap objectAtIndex:1] label:self.f_thap];
    [utils setLabelColor:[stockEntity.f_cao objectAtIndex:1] label:self.f_cao];
    [utils setLabelColor:[stockEntity.f_kl_tongkl objectAtIndex:1] label:self.f_tongKL];
    
    
    VDSCStock4OrderEntity *stock = [utils loadStockInfo:stockEntity.f_maCK marketId:stockEntity.f_sanGD orderSide:@"S"];
    self.f_congTy.text = stock.name;
    [stock release];
    //}
}
-(void) loadStockInfo
{
    if(stockEntity==nil || stockEntity.f_maCK == nil)return;
    NSString *code = stockEntity.f_maCK;
    NSString *url = [NSString stringWithFormat: [[NSUserDefaults standardUserDefaults] stringForKey:@"stock_info"], code];
    
    NSDictionary *allDataDictionary = [utils getDataFromUrl:url method:@"GET" postData:nil];
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
    
    [self assignDataToControl];
    NSLog(@"load info");
}
-(void) loadChart:(NSString*) stockCode
{
    
    NSString *strUrl = [NSString stringWithFormat:@"http://price.vdsc.com.vn/ipad/chartInfo.jsp?type=2&code=%@&width=800&height=285&s1=KL&s2=Giá", stockCode];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if([user objectForKey:@"chart_matchedPrice"]!=nil)
    {
        strUrl = [NSString stringWithFormat:[user stringForKey:@"chart_matchedPrice"], @"2", stockCode, @"500", @"285"];
    }
    NSURL* aURL = [NSURL URLWithString:strUrl];
    [self.chart_kl_gia loadRequest:[NSURLRequest requestWithURL:aURL]];
    [self.chart_kl_gia setAlpha:1];
}
- (IBAction)btn_buy_touch:(id)sender {
    
    VDSCMainViewController *mainView = (VDSCMainViewController*)self.delegate;
    mainView.stockId =stockEntity.f_maCK;
    mainView.priceOrder = [[stockEntity.f_ban1_gia objectAtIndex:0] doubleValue];
    mainView.orderSide=@"B";
    [mainView showOrderView:self.currentCell orderEntity:nil inView:self.marketInfo.priceBoard];
    [self.marketInfo.popover dismissPopoverAnimated:YES];
}

- (IBAction)btn_sell_touch:(id)sender {
    
    VDSCMainViewController *mainView = (VDSCMainViewController*)self.delegate;
    mainView.stockId =stockEntity.f_maCK;
    mainView.orderSide=@"S";
    mainView.priceOrder = [[stockEntity.f_mua1_gia objectAtIndex:0] doubleValue];
    [mainView showOrderView:self.currentCell orderEntity:nil inView:self.marketInfo.priceBoard];
    [self.marketInfo.popover dismissPopoverAnimated:YES];
}

- (IBAction)btn_add_touch:(id)sender {
    if([((VDSCMainViewController*)self.delegate) checkStockInWatchingList:stockEntity.f_maCK])
    {
        [utils showMessage:[utils.dic_language objectForKey:@"ipad.watchingList.existsStock"] messageContent:nil dismissAfter:2];
        return;
    }
    [utils addStock2WatchingList:stockEntity.f_maCK marketId:stockEntity.f_sanGD];
    [((VDSCMainViewController*)self.delegate) addRemoveStockInWatchingList:YES stockId:stockEntity.f_maCK  marketId:stockEntity.f_sanGD];
}

- (IBAction)btn_remove_touch:(id)sender {
    if(![((VDSCMainViewController*)self.delegate) checkStockInWatchingList:stockEntity.f_maCK])
    {
        [utils showMessage:[utils.dic_language objectForKey:@"ipad.watchingList.notExistsStock"] messageContent:nil dismissAfter:2];
        return;
    }
    [utils removeStock2WatchingList:stockEntity.f_maCK marketId:stockEntity.f_sanGD];
    [((VDSCMainViewController*)self.delegate) addRemoveStockInWatchingList:NO stockId:stockEntity.f_maCK  marketId:stockEntity.f_sanGD];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc {
    [_f_ma release];
    [_f_congTy release];
    [_f_kl_gia release];
    [_f_kl_tangGiam release];
    [_f_thamChieu release];
    [_f_tran release];
    [_f_tongKL release];
    [_f_san release];
    [_f_thap release];
    [_f_cao release];
    [_f_trungBinh release];
    [_chart_kl_gia release];
    [utils release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setF_ma:nil];
    [self setF_congTy:nil];
    [self setF_kl_gia:nil];
    [self setF_kl_tangGiam:nil];
    [self setF_thamChieu:nil];
    [self setF_tongKL:nil];
    [super viewDidUnload];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [timer invalidate];
    timer = nil;
}
@end
