//
//  VDSCMiniPriceBoard.m
//  iPadDragon
//
//  Created by vdsc on 1/4/13.
//  Copyright (c) 2013 VDSC. All rights reserved.
//

#import "VDSCMiniPriceBoard.h"
#import "VDSCPriceBoardEntity.h"
#import "VDSCCommonUtils.h"
#import "VDSCChangeStockEntity.h"
#import "VDSCNewsEntity.h"
#import "VDSCMainViewController.h"
#import "VDSCEditOrderViewController.h"
#import "VDSCNewsItemViewController.h"
#import "VDSCMarketInfo.h"
#import "ASIFormDataRequest.h"

@interface VDSCMiniPriceBoard()
{
    
    VDSCCommonUtils *utils;
    VDSCPriceBoardEntity *currStock;
    bool loading;
    
    NSMutableData *webData_price;
    NSURLConnection *connection_price;
    
    
    NSMutableData *webData_stock;
    NSURLConnection *connection_stock;
    
    NSMutableArray *arr_news;
    NSMutableArray *array_matchPriceByTime;
    NSOperationQueue *queue;
    NSString *matchedPrice;
    NSString *matchedTime;
    
    NSString *currInstrument;
    NSString *currInstrument_news;
}

@end
@implementation VDSCMiniPriceBoard
@synthesize priceBoard;
@synthesize array_price_change;
@synthesize loadFull;
@synthesize array_price;
@synthesize root_array_price;
@synthesize stockEntity;
@synthesize timer_price;
@synthesize timer_detail;

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
-(void)awakeFromNib
{
    utils = [[VDSCCommonUtils alloc] init];
    loadFull=YES;
    [self.f_keyWord addTarget:self action:@selector(f_keyWordValueChanged:) forControlEvents:UIControlEventEditingChanged];
    priceBoard.dataSource = self;
    priceBoard.delegate=self;
    
    self.tableNews.dataSource = self;
    self.tableNews.delegate = self;
    self.table_chiTietKL.dataSource = self;
    self.table_chiTietKL.delegate = self;
    
    arr_news = [[NSMutableArray alloc] init];
    root_array_price = [[NSMutableArray alloc] init];
    array_matchPriceByTime= [[NSMutableArray alloc] init];
    array_price = [[NSUserDefaults standardUserDefaults] objectForKey:@"stock_floor"];
    //[self loadPriceBoard];[[NSUserDefaults standardUserDefaults] doubleForKey:@"timeChangePriceboard"]
    double interval = [[NSUserDefaults standardUserDefaults] doubleForKey:@"timeChangePriceboard"];
    if(interval==0)interval=5;
    timer_price = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(loadPriceBoard) userInfo:nil repeats:YES];
    [timer_price fire];
    
    timer_detail = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(loadStockInfo) userInfo:nil repeats:YES];
    [timer_detail fire];
    [self.char_kl_gia setOpaque:NO];
    loading = NO;
    priceBoard.showsHorizontalScrollIndicator = NO;
    priceBoard.showsVerticalScrollIndicator = NO;
    matchedPrice=@"";
    matchedTime=@"";
}
-(void)loadStockInfo
{
    if(currStock!=nil){
        [self getSelectedStockInfo];
        [self performSelectorInBackground:@selector(loadNews) withObject:nil];
        [self loadChart:[currStock.f_ma objectAtIndex:0]];
    }
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == priceBoard){
        VDSCPriceBoardEntity *entity = (VDSCPriceBoardEntity*)[[array_price retain ]objectAtIndex:indexPath.row];
        currStock=[entity retain];
        [self loadStockInfo];
        [entity release];
    }
    else if(tableView == self.tableNews)
    {
        VDSCNewsEntity *news = ((VDSCNewsEntity *)[[arr_news retain] objectAtIndex:indexPath.row]);
        VDSCMainViewController *mainView=(VDSCMainViewController*)((VDSCMarketInfo*)self.delegate).delegate;
        VDSCNewsItemViewController *newController = [mainView.storyboard instantiateViewControllerWithIdentifier:@"VDSCNewsItemView"];
        newController.modalPresentationStyle = UIModalPresentationPageSheet;
        newController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        newController.newsEntity = [news retain];
        [mainView presentModalViewController:newController animated:YES];
        [news release];
    }
}

-(void) loadChart:(NSString*) stockCode
{
    if([stockCode isEqualToString:currInstrument])return;
    currInstrument = stockCode;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *strUrl = [NSString stringWithFormat:[user stringForKey:@"chart_matchedPrice"],@"1" , stockCode, @"445", @"212"];
    NSURL* aURL = [[NSURL alloc] initWithString:strUrl];
    //if(![strUrl isEqualToString:matchedPrice])
    if(self.seq_chartType.selectedSegmentIndex==0)
    {
        matchedPrice =strUrl;
        [self.char_kl_gia loadHTMLString: @"" baseURL: nil];
        [self.char_kl_gia loadRequest:[NSURLRequest requestWithURL:aURL]];
    }
    [aURL release];
    
    //else{
    strUrl = [NSString stringWithFormat:[user stringForKey:@"chart_matchedPrice"],@"2" , stockCode, @"445", @"212"];
    aURL = [[NSURL alloc] initWithString:strUrl];
    [self.chart_matchedbyTime loadHTMLString: @"" baseURL: nil];
    [self.chart_matchedbyTime loadRequest:[NSURLRequest requestWithURL:aURL]];
    [aURL release];
    //}
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

-(void) getSelectedStockInfo
{
    if(currStock!=nil){
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:[user stringForKey:@"stock_fullInfo"], [currStock.f_ma objectAtIndex:0]]];
        
        ASIFormDataRequest *request_cash = [ASIFormDataRequest requestWithURL:url];
        request_cash.tag=100;
        
        [request_cash setRequestMethod:@"GET"];
        [self grabURLInTheBackground:request_cash];
    }
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
    @try{
        if(request.tag==100)
        {
            NSError *err;
            NSData *data = [[request responseData] retain];
            NSDictionary *allDataDictionary = [[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err] retain];
            /*if (err)
             {
             //NSLog([err description]);
             return;
             }*/
            NSArray *arrayOfEntity = [[allDataDictionary objectForKey:@"stock"] retain];
            
            stockEntity = [[VDSCPriceBoardEntity alloc] init];
            stockEntity.f_tenCty = [allDataDictionary objectForKey:@"name"];
            stockEntity.f_ma = [arrayOfEntity objectAtIndex:0];
            stockEntity.f_maCK = [stockEntity.f_ma objectAtIndex:0];
            stockEntity.f_sanGD = [((VDSCMainViewController*)((VDSCMarketInfo*)self.delegate).delegate) getMarketByStock:stockEntity.f_maCK];
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
            stockEntity.f_nuocNgoai_mua = [arrayOfEntity objectAtIndex:26];
            stockEntity.f_nuocNgoai_ban = [arrayOfEntity objectAtIndex:27];
            stockEntity.f_room = [arrayOfEntity objectAtIndex:28];
            
            [self loadChart:[stockEntity.f_ma objectAtIndex:0]];
            [self setCellValue:stockEntity];
            [self performSelectorInBackground:@selector(loadNews) withObject:nil];
            
            NSArray *arr = [[allDataDictionary objectForKey:@"pHis"] retain];
            if(![arr isEqual:[NSNull null]])
                if([[stockEntity.f_kl_gia objectAtIndex:0]doubleValue]>0)
                {
                    double giaHT=[[stockEntity.f_kl_gia objectAtIndex:0]doubleValue];
                    double gia1Tuan=[[arr objectAtIndex:0]doubleValue];
                    double gia1Thang=[[arr objectAtIndex:1]doubleValue];
                    double gia3thang=[[arr objectAtIndex:2]doubleValue];
                    double thap52=[[arr objectAtIndex:3]doubleValue];
                    double cao52=[[arr objectAtIndex:4]doubleValue];
                    
                    self.f_cao52Tuan.text= [NSString stringWithFormat:@"%@",[utils.numberFormatter1Digits stringFromNumber:[NSNumber numberWithDouble: cao52]]];
                    self.f_thap52Tuan.text= [NSString stringWithFormat:@"%@",[utils.numberFormatter1Digits stringFromNumber:[NSNumber numberWithDouble: thap52]]];
                    
                    self.f_tangGiam1Tuan.text= [NSString stringWithFormat:@"%@",[utils.numberFormatter1Digits stringFromNumber:[NSNumber numberWithDouble: (giaHT-gia1Tuan)*100/gia1Tuan]]];
                    self.f_tangGiam1Thang.text= [NSString stringWithFormat:@"%@",[utils.numberFormatter1Digits stringFromNumber:[NSNumber numberWithDouble: (giaHT-gia1Thang)*100/gia1Thang]]];
                    self.f_tangGiam3thang.text= [NSString stringWithFormat:@"%@",[utils.numberFormatter1Digits stringFromNumber:[NSNumber numberWithDouble: (giaHT-gia3thang)*100/gia3thang]]];
                    self.f_room.text= [NSString stringWithFormat:@"%@",[utils.numberFormatter2Digits stringFromNumber:[NSNumber numberWithDouble: [[stockEntity.f_room  objectAtIndex:0] doubleValue]]]];
                    
                    [utils setLabelColor:@"R" label:self.f_room];
                    NSString *color = @"R";
                    if(gia1Tuan< giaHT)
                        color=@"I";
                    else if(gia1Tuan > giaHT)
                        color=@"D";
                    [utils setLabelColor:color label:self.f_tangGiam1Tuan];
                    
                    
                    color = @"R";
                    if(gia1Thang < giaHT)
                        color=@"I";
                    else if(gia1Thang > giaHT)
                        color=@"D";
                    [utils setLabelColor:color label:self.f_tangGiam1Thang];
                    
                    color = @"R";
                    if(gia3thang< giaHT)
                        color=@"I";
                    else if(gia3thang > giaHT)
                        color=@"D";
                    [utils setLabelColor:color label:self.f_tangGiam3thang];
                    
                    color = @"R";
                    if(cao52> giaHT)
                        color=@"I";
                    else if(cao52 < giaHT)
                        color=@"D";
                    [utils setLabelColor:color label:self.f_cao52Tuan];
                    
                    color = @"R";
                    if(thap52> giaHT)
                        color=@"I";
                    else if(thap52 < giaHT)
                        color=@"D";
                    [utils setLabelColor:color label:self.f_thap52Tuan];
                }
            [array_matchPriceByTime removeAllObjects];
            
            if(![[allDataDictionary objectForKey:@"timing"] isEqual:[NSNull null]])
            {
                NSArray *array = [[allDataDictionary objectForKey:@"timing"] retain];
                for(int i=array.count-1; i>=0;i--)
                {
                    
                    [array_matchPriceByTime addObject:[array objectAtIndex:i]];
                }
                [array release];
                [self.table_chiTietKL reloadData];
            }
            [arr release];
            
            [allDataDictionary release];
            [data release];
            [arrayOfEntity release];
        }
        else
        {
            NSError *err;
            NSData *data = [request responseData];
            NSDictionary *allDataDictionary = [[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err] retain];
            /*if (err==Nil)
             {
             [data release];
             [allDataDictionary release];
             return;
             }*/
            [arr_news removeAllObjects];
            //NSArray *data_news = allDataDictionary;//[allDataDictionary objectForKey:@"news"];
            NSString *url = [NSString stringWithFormat:@"<br/><br/>Xem thêm tại <a href=\"http://data.vdsc.com.vn/vi/Com_News/%@/\" style=\"text-decoration:none;color:\"#0000ff\"><b>Trang Công cụ đầu tư</b></a>", self.f_maCK.text];
            if(![allDataDictionary isEqual:[NSNull null]]){
                for (NSDictionary *arrayOfEntity in allDataDictionary)
                {
                    VDSCNewsEntity *news = [VDSCNewsEntity alloc];
                    news.f_ID = [arrayOfEntity objectForKey:@"id"];
                    news.f_date = [arrayOfEntity objectForKey:@"time"];
                    news.f_title = [arrayOfEntity objectForKey:@"title"];
                    news.f_content = [arrayOfEntity objectForKey:@"content"];
                    news.f_content = [NSString stringWithFormat:@"%@%@", news.f_content, url];
                    [arr_news addObject:news];
                    [news release];
                }
            }
            [self.tableNews reloadData];
            [allDataDictionary release];
        }
    }
    @catch (NSException *ex) {
        NSLog(@"Uncaught exception: %@", ex.description);NSLog(@"Stack trace: %@", [ex callStackSymbols]);
    }
}
- (void)requestWentWrong:(ASIFormDataRequest *)request
{
    NSError *error = [request error];
    NSLog(error.description);
}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if(connection == connection_price)
        [webData_price setLength:0];
    else
        [webData_stock setLength:0];
}
-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Fail:********************");
}
-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if(connection == connection_price)
        [webData_price  appendData:data];
    else [webData_stock  appendData:data];
}
-(void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    NSError *err;
    //NSString *xml = [[NSString alloc] initWithBytes:[webData_price mutableBytes] length:[webData_price length] encoding:NSUTF8StringEncoding];
    NSDictionary *allDataDictionary = [NSJSONSerialization JSONObjectWithData:webData_price options:NSJSONReadingAllowFragments error:&err];
    if (err==Nil)
    {
        //NSLog([err description]);
        return;
    }
    NSArray *arrayOfEntity = [allDataDictionary objectForKey:@"stock"];
    
    stockEntity = [[VDSCPriceBoardEntity alloc] init];
    stockEntity.f_tenCty = [allDataDictionary objectForKey:@"name"];
    stockEntity.f_ma = [arrayOfEntity objectAtIndex:0];
    stockEntity.f_maCK = [stockEntity.f_ma objectAtIndex:0];
    stockEntity.f_sanGD = [((VDSCMainViewController*)((VDSCMarketInfo*)self.delegate).delegate) getMarketByStock:stockEntity.f_maCK];
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
    stockEntity.f_nuocNgoai_mua = [arrayOfEntity objectAtIndex:26];
    stockEntity.f_nuocNgoai_ban = [arrayOfEntity objectAtIndex:27];
    stockEntity.f_room = [arrayOfEntity objectAtIndex:28];
    
    [self loadChart:[stockEntity.f_ma objectAtIndex:0]];
    [self setCellValue:stockEntity];
    [self performSelectorInBackground:@selector(loadNews) withObject:nil];
    
    NSArray *arr = [allDataDictionary objectForKey:@"pHis"];
    if(![arr isEqual:[NSNull null]])
        if([[stockEntity.f_kl_gia objectAtIndex:0]doubleValue]>0)
        {
            double giaHT=[[stockEntity.f_kl_gia objectAtIndex:0]doubleValue];
            double gia1Tuan=[[arr objectAtIndex:0]doubleValue];
            double gia1Thang=[[arr objectAtIndex:1]doubleValue];
            double gia3thang=[[arr objectAtIndex:2]doubleValue];
            double thap52=[[arr objectAtIndex:3]doubleValue];
            double cao52=[[arr objectAtIndex:4]doubleValue];
            
            self.f_cao52Tuan.text= [NSString stringWithFormat:@"%@",[utils.numberFormatter1Digits stringFromNumber:[NSNumber numberWithDouble: cao52]]];
            self.f_thap52Tuan.text= [NSString stringWithFormat:@"%@",[utils.numberFormatter1Digits stringFromNumber:[NSNumber numberWithDouble: thap52]]];
            
            self.f_tangGiam1Tuan.text= [NSString stringWithFormat:@"%@",[utils.numberFormatter1Digits stringFromNumber:[NSNumber numberWithDouble: (giaHT-gia1Tuan)*100/gia1Tuan]]];
            self.f_tangGiam1Thang.text= [NSString stringWithFormat:@"%@",[utils.numberFormatter1Digits stringFromNumber:[NSNumber numberWithDouble: (giaHT-gia1Thang)*100/gia1Thang]]];
            self.f_tangGiam3thang.text= [NSString stringWithFormat:@"%@",[utils.numberFormatter1Digits stringFromNumber:[NSNumber numberWithDouble: (giaHT-gia3thang)*100/gia3thang]]];
            self.f_room.text= [NSString stringWithFormat:@"%@",[utils.numberFormatter2Digits stringFromNumber:[NSNumber numberWithDouble: [[stockEntity.f_room  objectAtIndex:0] doubleValue]]]];
            
            [utils setLabelColor:@"R" label:self.f_room];
            NSString *color = @"R";
            if(gia1Tuan> [[stockEntity.f_thamchieu objectAtIndex:0] doubleValue])
                color=@"I";
            else if(gia1Tuan < [[stockEntity.f_thamchieu objectAtIndex:0] doubleValue])
                color=@"D";
            [utils setLabelColor:color label:self.f_tangGiam1Tuan];
            
            color = @"R";
            if(gia1Tuan> [[stockEntity.f_thamchieu objectAtIndex:0] doubleValue])
                color=@"I";
            else if(gia1Tuan < [[stockEntity.f_thamchieu objectAtIndex:0] doubleValue])
                color=@"D";
            [utils setLabelColor:color label:self.f_tangGiam1Tuan];
            
            color = @"R";
            if(gia1Thang> [[stockEntity.f_thamchieu objectAtIndex:0] doubleValue])
                color=@"I";
            else if(gia1Thang < [[stockEntity.f_thamchieu objectAtIndex:0] doubleValue])
                color=@"D";
            [utils setLabelColor:color label:self.f_tangGiam1Thang];
            
            color = @"R";
            if(gia3thang> [[stockEntity.f_thamchieu objectAtIndex:0] doubleValue])
                color=@"I";
            else if(gia3thang < [[stockEntity.f_thamchieu objectAtIndex:0] doubleValue])
                color=@"D";
            [utils setLabelColor:color label:self.f_tangGiam3thang];
            
            color = @"R";
            if(cao52> [[stockEntity.f_thamchieu objectAtIndex:0] doubleValue])
                color=@"I";
            else if(cao52 < [[stockEntity.f_thamchieu objectAtIndex:0] doubleValue])
                color=@"D";
            [utils setLabelColor:color label:self.f_cao52Tuan];
            
            color = @"R";
            if(thap52> [[stockEntity.f_thamchieu objectAtIndex:0] doubleValue])
                color=@"I";
            else if(thap52 < [[stockEntity.f_thamchieu objectAtIndex:0] doubleValue])
                color=@"D";
            [utils setLabelColor:color label:self.f_thap52Tuan];
        }
    [array_matchPriceByTime removeAllObjects];
    
    if(![[allDataDictionary objectForKey:@"timing"] isEqual:[NSNull null]])
    {
        NSArray *array = [allDataDictionary objectForKey:@"timing"];
        for(int i=array.count-1; i>=0;i--)
        {
            
            [array_matchPriceByTime addObject:[array objectAtIndex:i]];
        }
        [self.table_chiTietKL reloadData];
    }
    
}
-(void) loadNews
{
    if([currStock.f_maCK isEqualToString:currInstrument_news])return;
    currInstrument_news = currStock.f_maCK;
    NSString *strUrl = [NSString stringWithFormat: [[NSUserDefaults standardUserDefaults] stringForKey:@"news"], [currStock.f_ma objectAtIndex:0]];
    NSURL *url = [[[NSURL alloc] initWithString:strUrl] autorelease];
    ASIFormDataRequest *request_cash = [ASIFormDataRequest requestWithURL:url];
    request_cash.tag=200;
    
    [request_cash setRequestMethod:@"GET"];
    [self grabURLInTheBackground:request_cash];
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
            self.f_kl_gia_1.text= [NSString stringWithFormat:@"%@",[price.f_kl_gia objectAtIndex:0]];
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
            
            
            d = [[price.f_nuocNgoai_mua objectAtIndex:0] doubleValue]/10;
            self.f_nngoai_mua.text= [NSString stringWithFormat:@"%@",[utils.numberFormatter2Digits stringFromNumber:[NSNumber numberWithDouble:d]]];
            d = [[price.f_nuocNgoai_ban objectAtIndex:0] doubleValue]/10;
            self.f_nn_ban.text= [NSString stringWithFormat:@"%@",[utils.numberFormatter2Digits stringFromNumber:[NSNumber numberWithDouble:d]]];
            
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
            
            [utils setLabelColor:[price.f_nuocNgoai_mua objectAtIndex:1] label:self.f_nngoai_mua];
            [utils setLabelColor:[price.f_nuocNgoai_ban objectAtIndex:1] label:self.f_nn_ban];
            
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
        //NSLog(@"Uncaught exception: %@", ex.description);NSLog(@"Stack trace: %@", [ex callStackSymbols]);
    }
}
-(void) loadPriceBoard
{
    //NSURL *url = [NSURL URLWithString:@"http://priceboard.vdsc.com.vn/ipad/boardInfo.jsp?id=hsx"];
    if(self.loadFull && ((VDSCMarketInfo*)self.delegate).root_array_price!=nil && ((VDSCMarketInfo*)self.delegate).root_array_price.count>0)
    {
        /*if(![array_price isEqual:[NSNull null]])
         [array_price removeAllObjects];
         if(![root_array_price isEqual:[NSNull null]])
         [root_array_price removeAllObjects];*/
        loadFull = NO;
        root_array_price = [((VDSCMarketInfo*)self.delegate).root_array_price retain];
        array_price = [((VDSCMarketInfo*)self.delegate).root_array_price retain];
        [self.priceBoard reloadData];
        if(![array_price isEqual:[NSNull null]] && array_price.count>0)
        {
            stockEntity = currStock=[((VDSCPriceBoardEntity*)[array_price objectAtIndex:0 ]) retain];
            [self getSelectedStockInfo];
        }
    }
    else if(loadFull==NO && ((VDSCMarketInfo*)self.delegate).array_price_change!=nil && ((VDSCMarketInfo*)self.delegate).array_price_change.count>0 && loading == NO)
    {
        loading = YES;
        array_price_change = ((VDSCMarketInfo*)self.delegate).array_price_change.copy;
        [self compareAndHighLightCell];
    }
}
-(void) compareAndHighLightCell
{
    if(array_price !=nil && array_price.count>0 && array_price_change!=nil && array_price_change.count>0)
    {
        for(VDSCPriceBoardEntity *data in array_price)
        {
            int index = [array_price indexOfObject:data];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
            UITableViewCell *cell = [priceBoard cellForRowAtIndexPath:indexPath];
            
            if(cell != nil)
            {
                UILabel *label = (UILabel*)[cell viewWithTag:100];
                NSString *maCK = label.text;
                for(VDSCChangeStockEntity *new_data in array_price_change)
                {
                    NSString *maCK_new = [NSString stringWithFormat:@"%@", new_data.code];
                    NSString *code = [maCK_new stringByReplacingOccurrencesOfString:maCK withString:@""];
                    
                    if( [code rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]].location == NSNotFound)
                    {
                        label = (UILabel*)[cell viewWithTag:[code integerValue]-1];
                        if(label!=nil && [label isKindOfClass: [UILabel class]])
                            //if([code integerValue]== label.tag+1)
                        {
                            if( [(NSString *)new_data.value rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]].location == NSNotFound)
                            {
                                double d = [(NSString *)new_data.value doubleValue]/10;
                                ((UILabel*)label).text =[NSString stringWithFormat:@"%@",[utils.numberFormatter2Digits stringFromNumber:[NSNumber numberWithDouble:d]]];
                            }
                            else
                            {
                                ((UILabel*)label).text = (NSString *)new_data.value;
                            }
                            [utils setLabelColor:new_data.color label:(UILabel*)label];
                            cell.backgroundColor = [UIColor greenColor];
                            
                            UILabel *label_hl = [[UILabel alloc] initWithFrame: label.frame];
                            label_hl.font = label.font;
                            label_hl.textAlignment = label.textAlignment;
                            label_hl.backgroundColor = [UIColor lightGrayColor];
                            label_hl.text = label.text;
                            label_hl.textColor = label.textColor;
                            [cell addSubview:label_hl];
                            //[self performSelectorInBackground:@selector(highlightCell:) withObject:label_hl];
                            //NSLog(maCK_new);
                            [UIView animateWithDuration:2 animations:^{[label_hl setAlpha:1];
                                [label_hl setAlpha:0];} completion:^(BOOL finised){[label_hl removeFromSuperview]; [label_hl release]; }];
                        }
                    }
                }
            }
        }
    }
    loading = NO;
}
-(void)highlightCell:(UILabel*)label
{
    sleep(1);
    [label removeFromSuperview];
    [label release];
}
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{return 1;}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == priceBoard)
        return array_price.count;
    else
        if(tableView == self.table_chiTietKL)
            return array_matchPriceByTime.count;
        else
            
            return arr_news.count;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == priceBoard)
        return 51;
    else if(tableView == self.table_chiTietKL)
        return 25;
    else return 30;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == priceBoard)
    {
        VDSCPriceBoardEntity *entity = [((VDSCPriceBoardEntity *)[array_price objectAtIndex:indexPath.row]) retain];
        NSString *cellIndentifier = @"VDSCFullCellPrice";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        if(cell==nil){
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier] autorelease];
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, priceBoard.frame.size.width, 51)];
            UIView *view_selected = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, priceBoard.frame.size.width, 51)] autorelease];
            
            view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"miniPriceboard_cellBG.png"]];
            view_selected.backgroundColor = [UIColor grayColor];
            cell.selectedBackgroundView=view_selected;
            
            
            UILabel *maCK = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 80, 25)];
            maCK.text=[entity.f_ma objectAtIndex:0];
            [utils setLabelColor:[entity.f_ma objectAtIndex:1] label:maCK];
            maCK.font =[UIFont boldSystemFontOfSize:17];
            maCK.tag=100;
            
            if([[entity.f_ma objectAtIndex:1] isEqualToString:@"Z"])
            {
                [maCK setBackgroundColor:[UIColor greenColor]];
                maCK.textColor=[UIColor blueColor];
            }
            else [utils setLabelColor:[entity.f_ma objectAtIndex:1] label:maCK];
            
            [view addSubview:maCK];
            [maCK release];
            
            maCK = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 50, 25)];
            maCK.text=[NSString stringWithFormat:@"%@",[utils.numberFormatter1Digits stringFromNumber:[NSNumber numberWithDouble: [[entity.f_kl_gia  objectAtIndex:0] doubleValue]]]];
            maCK.backgroundColor = [UIColor clearColor];
            maCK.font =[UIFont boldSystemFontOfSize:17];
            [utils setLabelColor:[entity.f_kl_gia objectAtIndex:1] label:maCK];
            maCK.tag=10;
            [view addSubview:maCK];
            [maCK release];
            
            maCK = [[UILabel alloc] initWithFrame:CGRectMake(160, 0, 80, 25)];
            maCK.text=[NSString stringWithFormat:@"(%@)" ,[entity.f_kl_tangGiam objectAtIndex:0]];
            maCK.backgroundColor = [UIColor clearColor];
            [utils setLabelColor:[entity.f_kl_gia objectAtIndex:1] label:maCK];
            maCK.textAlignment = NSTextAlignmentRight;
            maCK.tag=12;
            [view addSubview:maCK];
            [maCK release];
            
            double d = [[entity.f_kl_kl objectAtIndex:0] doubleValue]/10;
            maCK = [[UILabel alloc] initWithFrame:CGRectMake(160, 27, 80, 25)];
            maCK.text=[NSString stringWithFormat:@"%@" ,[utils.numberFormatter stringFromNumber:[NSNumber numberWithDouble:d]]];
            maCK.backgroundColor = [UIColor clearColor];
            [utils setLabelColor:[entity.f_kl_kl objectAtIndex:1] label:maCK];
            maCK.textAlignment = NSTextAlignmentRight;
            maCK.tag=11;
            [view addSubview:maCK];
            [maCK release];
            
            maCK = [[UILabel alloc] initWithFrame:CGRectMake(100, 27, 50, 25)];
            maCK.text=@"KLGD";
            maCK.backgroundColor = [UIColor clearColor];
            maCK.font = [UIFont fontWithName:@"Arial" size:13.0f];
            [utils setLabelColor:[entity.f_kl_kl objectAtIndex:1] label:maCK];
            maCK.tag=130;
            [view addSubview:maCK];
            [maCK release];
            
            
            [cell addSubview:view];
            [view release];
        }
        else
        {
            UILabel *maCK = (UILabel*)[cell viewWithTag:100];
            maCK.text=[entity.f_ma objectAtIndex:0];
            [utils setLabelColor:[entity.f_ma objectAtIndex:1] label:maCK];
            
            if([[entity.f_ma objectAtIndex:1] isEqualToString:@"Z"])
            {
                [maCK setBackgroundColor:[UIColor greenColor]];
                maCK.textColor=[UIColor blueColor];
            }
            else
            {
                [maCK setBackgroundColor:[UIColor clearColor]];
                [utils setLabelColor:[entity.f_ma objectAtIndex:1] label:maCK];
            }
            
            maCK = (UILabel*)[cell viewWithTag:10];
            maCK.text=[NSString stringWithFormat:@"%@",[utils.numberFormatter1Digits stringFromNumber:[NSNumber numberWithDouble: [[entity.f_kl_gia  objectAtIndex:0] doubleValue]]]];
            [utils setLabelColor:[entity.f_kl_gia objectAtIndex:1] label:maCK];
            
            
            maCK = (UILabel*)[cell viewWithTag:12];
            maCK.text=[NSString stringWithFormat:@"(%@)" ,[entity.f_kl_tangGiam objectAtIndex:0]];
            [utils setLabelColor:[entity.f_kl_gia objectAtIndex:1] label:maCK];
            
            double d = [[entity.f_kl_kl objectAtIndex:0] doubleValue]/10;
            maCK = (UILabel*)[cell viewWithTag:11];
            maCK.text=[NSString stringWithFormat:@"%@" ,[utils.numberFormatter stringFromNumber:[NSNumber numberWithDouble:d]]];
            [utils setLabelColor:[entity.f_kl_kl objectAtIndex:1] label:maCK];
            
            
            maCK = (UILabel*)[cell viewWithTag:130];
            maCK.text=@"KLGD";
            [utils setLabelColor:[entity.f_kl_kl objectAtIndex:1] label:maCK];
            
        }
        [entity release];
        return cell;
    }
    else if(tableView == self.table_chiTietKL)
    {
        NSInteger i=indexPath.row;
        NSArray *dic = [array_matchPriceByTime objectAtIndex:i];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"xxx"];
        if(cell ==nil){
            cell =[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"xxx"] autorelease];
            
            //if([nsclass class]){return cell;}
            int x=0;
            UILabel *label = [[UILabel alloc] init];
            label.frame = CGRectMake(x, 0, 98, 24);
            label.text = [dic objectAtIndex:0];
            label.backgroundColor = utils.cellBackgroundColor;
            label.font = [UIFont fontWithName:utils.fontFamily size:utils.fontSize];
            label.textColor = [UIColor lightGrayColor];
            label.tag=10;
            [cell addSubview:label];
            [label release];
            
            x=label.frame.origin.x+1+label.frame.size.width;
            label = [[UILabel alloc] init];
            label.frame = CGRectMake(x, 0, 81, 24);
            double d=[[dic objectAtIndex:1] doubleValue];
            label.text = [NSString stringWithFormat:@"%@  ", [utils.numberFormatter1Digits stringFromNumber:[NSNumber numberWithDouble:d]]];
            label.backgroundColor = utils.cellBackgroundColor;
            label.font = [UIFont fontWithName:utils.fontFamily size:utils.fontSize];
            label.textAlignment = UITextAlignmentRight;
            label.textColor = [UIColor lightGrayColor];
            label.tag=11;
            [cell addSubview:label];
            [label release];
            
            x=label.frame.origin.x+1+label.frame.size.width;
            label = [[UILabel alloc] init];
            label.frame = CGRectMake(x, 0, 107, 24);
            d=[[dic objectAtIndex:2] doubleValue];
            label.text = [NSString stringWithFormat:@"%@  ", [utils.numberFormatter stringFromNumber:[NSNumber numberWithDouble:d]]];
            label.backgroundColor = utils.cellBackgroundColor;
            label.font = [UIFont fontWithName:utils.fontFamily size:utils.fontSize];
            label.textAlignment = UITextAlignmentRight;
            label.textColor = [UIColor lightGrayColor];
            label.tag=12;
            [cell addSubview:label];
            [label release];
            
            x=label.frame.origin.x+1+label.frame.size.width;
            label = [[UILabel alloc] init];
            label.frame = CGRectMake(x, 0, 156, 24);
            d=[[dic objectAtIndex:3] doubleValue];
            label.text = [NSString stringWithFormat:@"%@  ", [utils.numberFormatter stringFromNumber:[NSNumber numberWithDouble:d]]];
            label.backgroundColor = utils.cellBackgroundColor;
            label.font = [UIFont fontWithName:utils.fontFamily size:utils.fontSize];
            label.textColor = [UIColor lightGrayColor];
            label.textAlignment = UITextAlignmentRight;
            label.tag=13;
            [cell addSubview:label];
            [label release];
        }
        else
        {
            UILabel *label = (UILabel*)[cell viewWithTag:10];
            label.text = [dic objectAtIndex:0];
            
            label = (UILabel*)[cell viewWithTag:11];
            double d=[[dic objectAtIndex:1] doubleValue];
            label.text = [NSString stringWithFormat:@"%@  ", [utils.numberFormatter1Digits stringFromNumber:[NSNumber numberWithDouble:d]]];
            
            label = (UILabel*)[cell viewWithTag:12];
            d=[[dic objectAtIndex:2] doubleValue];
            label.text = [NSString stringWithFormat:@"%@  ", [utils.numberFormatter stringFromNumber:[NSNumber numberWithDouble:d]]];
            label = (UILabel*)[cell viewWithTag:13];
            d=[[dic objectAtIndex:3] doubleValue];
            label.text = [NSString stringWithFormat:@"%@  ", [utils.numberFormatter stringFromNumber:[NSNumber numberWithDouble:d]]];
        }
        return cell;
    }
    else
    {
        NSString *cellIndentifier = @"VDSCFullCellPrice";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        if(cell==nil){
            cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier] autorelease];
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableNews.frame.size.width, 30)];
            view.backgroundColor = [UIColor darkGrayColor];
            
            UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.tableNews.frame.size.width-80, 25)];
            title.text=((VDSCNewsEntity*)[arr_news objectAtIndex:indexPath.row]).f_title;        [title setFont:[UIFont fontWithName:@"Arial" size:14]];
            title.textColor = [UIColor lightGrayColor];
            title.backgroundColor = [UIColor clearColor];
            title.tag=10;
            [view addSubview:title];
            
            UILabel *date = [[UILabel alloc] initWithFrame:CGRectMake(380, 10, 80, 25)];
            date.text=((VDSCNewsEntity*)[arr_news objectAtIndex:indexPath.row]).f_date;
            [date setFont:[UIFont fontWithName:@"Arial" size:11]];
            date.textColor = [UIColor yellowColor];
            date.backgroundColor = [UIColor clearColor];
            date.tag=11;
            [view addSubview:date];
            
            [cell addSubview:view];
            [view release];
            [date release];
            [title release];
        }
        else{
            UILabel *title = (UILabel*)[cell viewWithTag:10];
            title.text=((VDSCNewsEntity*)[arr_news objectAtIndex:indexPath.row]).f_title;
            
            UILabel *date = (UILabel*)[cell viewWithTag:11];
            date.text=((VDSCNewsEntity*)[arr_news objectAtIndex:indexPath.row]).f_date;
        }
        return cell;
    }
}

- (void)dealloc {
    [root_array_price release];
    [arr_news release];
    [array_price release];
    [webData_price release];
    [webData_stock release];
    [_f_keyWord release];
    [_f_maCK release];
    [_f_tenCty release];
    [_f_kl_gia release];
    [_f_kl_tangGiam release];
    [_f_thamChieu release];
    [_f_tran release];
    [_f_thap release];
    [_f_trungBinh release];
    [_f_tongKL release];
    [_f_cao52Tuan release];
    [_f_thap52Tuan release];
    [_f_nngoai_mua release];
    [_f_tangGiam1Tuan release];
    [_f_room release];
    [_f_tangGiam1Thang release];
    [_f_tangGiam3thang release];
    [_f_mua3_kl release];
    [_f_mua3_gia release];
    [_f_mua2_gia release];
    [_f_mua2_gia release];
    [_f_mua1_gia release];
    [_f_mua1_kl release];
    [_f_kl_gia release];
    [_f_kl_kl_1 release];
    [_f_ban1_gia release];
    [_f_ban2_gia release];
    [_f_ban3_gia release];
    [_f_ban1_kl release];
    [_f_ban2_kl release];
    [_f_ban3_kl release];
    [_f_nn_ban release];
    [_tableNews release];
    [_process_mua release];
    [_process_ban release];
    [_char_kl_gia release];
    [_view_chart release];
    [_chart_matchedbyTime release];
    [_table_chiTietKL release];
    [_view_chiTietKL release];
    [_seq_chartType release];
    [super dealloc];
}
- (IBAction)showFullPriceBoard:(id)sender {
    [self.superview sendSubviewToBack:self];
}

- (IBAction)f_keyWordValueChange:(id)sender {
}
- (IBAction)btn_buy_touch:(id)sender {
    VDSCMainViewController *mainView = (VDSCMainViewController*)((VDSCMarketInfo*)self.delegate).delegate;
    mainView.stockId =self.f_maCK.text;
    mainView.orderSide=@"B";
    mainView.priceOrder = [[stockEntity.f_ban1_gia objectAtIndex:0] doubleValue];
    [mainView showOrderView:sender orderEntity:nil inView:self.view_chart];
}
-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [((VDSCMarketInfo*)self.delegate).f_keyWord resignFirstResponder];
}
- (IBAction)btn_sell_touch:(id)sender {
    VDSCMainViewController *mainView = (VDSCMainViewController*)((VDSCMarketInfo*)self.delegate).delegate;
    mainView.stockId =self.f_maCK.text;
    mainView.orderSide=@"S";
    mainView.priceOrder = [[stockEntity.f_mua1_gia objectAtIndex:0] doubleValue];
    [mainView showOrderView:sender orderEntity:nil inView:self.view_chart];
}


- (IBAction)btn_add_touch:(id)sender {
    if([((VDSCMainViewController*)((VDSCMarketInfo*)self.delegate).delegate) checkStockInWatchingList:stockEntity.f_maCK])
    {
        [utils showMessage:@"Chứng khoán này đã được thêm vào danh mục quan tâm" messageContent:nil dismissAfter:1];
        return;
    }
    [utils addStock2WatchingList:stockEntity.f_maCK marketId:stockEntity.f_sanGD];
    [((VDSCMainViewController*)((VDSCMarketInfo*)self.delegate).delegate) addRemoveStockInWatchingList:YES stockId:stockEntity.f_maCK  marketId:stockEntity.f_sanGD];
}

- (IBAction)btn_remove_touch:(id)sender {
    if(![((VDSCMainViewController*)((VDSCMarketInfo*)self.delegate).delegate) checkStockInWatchingList:stockEntity.f_maCK])
    {
        [utils showMessage:@"Chứng khoán này không nằm trong danh mục quan tâm" messageContent:nil dismissAfter: 1];
        return;
    }
    [utils removeStock2WatchingList:stockEntity.f_maCK marketId:stockEntity.f_sanGD];
    [((VDSCMainViewController*)((VDSCMarketInfo*)self.delegate).delegate) addRemoveStockInWatchingList:NO stockId:stockEntity.f_maCK  marketId:stockEntity.f_sanGD];
}
- (IBAction)tab_changed:(id)sender {
    switch (((UISegmentedControl*)sender).selectedSegmentIndex) {
        case 0:
            [self.view_chart bringSubviewToFront:self.char_kl_gia];
            break;
        case 1:
            [self.view_chart bringSubviewToFront:self.chart_matchedbyTime];
            break;
        case 2:
            [self.view_chart bringSubviewToFront:self.view_chiTietKL];
            break;
        default:
            break;
    }
}
@end
