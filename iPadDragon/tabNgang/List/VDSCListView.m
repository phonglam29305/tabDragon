//
//  VDSCListView.m
//  iPadDragon
//
//  Created by vdsc on 12/25/12.
//  Copyright (c) 2012 VDSC. All rights reserved.
//

#import "VDSCListView.h"
#import "OCCalendarViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "VDSCCommonUtils.h"
#import "VDSCObjectStockBalance.h"
#import "VDSCListSettingViewController.h"
#import "VDSCMainViewController.h"

#define contains(str1, str2)([str1 rangeOfString: str2].location != NSNotFound)

@interface VDSCListView()
{
    VDSCCommonUtils *utils;
    NSMutableArray *array;
    NSArray *array_sorted;
    double tongGTVon;
    double tongGTTT;
    UIWebView *loading;
    NSTimer *timer;
    //VDSCListSettingViewController *popover_Vew;
}
@end
@implementation VDSCListView

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
    array = [[NSMutableArray alloc] init];
    array_sorted = [[NSArray alloc] init];
    self.table_list.delegate = self;
    self.table_list.dataSource = self;
    loading = [utils showLoading:self.table_list];
    //[self loadData];
    timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(sheduleData) userInfo:nil repeats:YES];
    [timer fire];
}
-(void) sheduleData
{
    [self performSelectorInBackground:@selector(loadData) withObject:nil];
}
-(void)loadData
{
    NSArray *arr;
    NSDictionary *allDataDictionary;
    @try {
        arr = [[NSArray alloc] initWithObjects:@"KW_CLIENTSECRET",utils.clientInfo.secret
               , @"KW_CLIENTID", utils.clientInfo.clientID
               , @"KW_TRADINGACCSEQ", utils.clientInfo.tradingAccSeq
               , @"KW_PORTFOLIO_MODE", @"1"
               , nil];
        NSString *post = [utils postValueBuilder:arr];
        
        NSString *url = [[NSUserDefaults standardUserDefaults] stringForKey:@"clientStockInfo"];
        allDataDictionary = [utils getDataFromUrl:url method:@"POST" postData:post];
        //NSArray *data = [[allDataDictionary objectForKey:@"list"] copy];
        if([[allDataDictionary objectForKey:@"success"] boolValue])
        {
            VDSCObjectStockBalance *stock = nil;
            if(![[allDataDictionary objectForKey:@"list"] isEqual:[NSNull null]]){
                [array removeAllObjects];
                tongGTTT =0;
                tongGTVon =0;
                for (NSDictionary *item in [allDataDictionary objectForKey:@"list"]) {
                    //if([[item objectForKey:@"STATUS"] isEqual:@"L"]){
                    stock = [[VDSCObjectStockBalance alloc] init];
                    stock.MaCK = [item objectForKey:@"StockCode"];
                    stock.SanGD = [item objectForKey:@"MarketId"];
                    stock.GiaThiTruong = [[item objectForKey:@"MarketPrice"] doubleValue];
                    stock.KLTinhGiaVon =[[item objectForKey:@"TotalQty"] doubleValue];
                    stock.GiaVon = [[utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:[[item objectForKey:@"AvgPrice"] doubleValue]]] doubleValue];
                    stock.CatLo = [[item objectForKey:@"LossPrice"] doubleValue];
                    stock.ChotLoi = [[item objectForKey:@"ProfitPrice"] doubleValue];
                    
                    [array addObject:stock];
                    
                    double giaTriTT= stock.KLTinhGiaVon*stock.GiaThiTruong;
                    double giaTriVon=stock.KLTinhGiaVon*stock.GiaVon;
                    tongGTTT += giaTriTT;
                    tongGTVon +=giaTriVon;
                    
                    [stock release];
                    
                }
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(exception.description);
    }
    @finally {
        if(array.count>0)
        {
            NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"MaCK" ascending:YES];
            //[yourArray sortUsingDescriptors:[NSArray arrayWithObject:sort]];
            array_sorted= [[array sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]] retain];
            
            [self.table_list reloadData];
            
            self.f_tongCong.text=[NSString stringWithFormat:@"%@",[utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:tongGTVon]]];
            self.f_tongCongTT.text=[NSString stringWithFormat:@"%@",[utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:tongGTTT]]];
            self.f_giaTriLoiLo.text=[NSString stringWithFormat:@"%@",[utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:tongGTTT-tongGTVon]]];
            self.f_tiLeLoiLo.text=[NSString stringWithFormat:@"%@",[utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:(tongGTTT-tongGTVon)*100/tongGTVon]]];
        }
        if(allDataDictionary!=nil)
            [allDataDictionary release];
        if(arr !=nil)
            [arr release];
        
        if(loading !=nil)
        {
            [loading removeFromSuperview];
            [loading release];
            loading=nil;
        }
        
    }
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{return utils.rowHeight;}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return array_sorted.count ;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{return 1;}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    //if(cell){[cell removeFromSuperview]; [cell release];}
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    VDSCObjectStockBalance *stock = [array_sorted objectAtIndex:indexPath.row];
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, utils.rowHeight)];
    bgView.backgroundColor = [UIColor grayColor];
    [cell setBackgroundView:bgView];
    
    double giaTriTT= stock.KLTinhGiaVon*stock.GiaThiTruong;
    double giaTriVon=stock.KLTinhGiaVon*stock.GiaVon;
    double tien = giaTriTT-giaTriVon;
    double tiLe = tien*100/giaTriVon;
    
    UIColor *color =[UIColor greenColor];
    if(tiLe<0)
        color=[UIColor colorWithRed:191/255.0 green:0/255.0 blue:23/255.0 alpha:1];
    else if(tiLe==0)
        color=[UIColor colorWithRed:200/255.0 green:199/255.0 blue:68/255.0 alpha:1];
    
    UIColor *color_catlo =utils.cellBackgroundColor;
    if(stock.GiaThiTruong<=stock.CatLo)
        color_catlo=[UIColor colorWithRed:191/255.0 green:0/255.0 blue:23/255.0 alpha:1];
    
    UIColor *color_chotloi =utils.cellBackgroundColor;
    if(stock.GiaThiTruong>=stock.ChotLoi && stock.ChotLoi>0)
        color_chotloi=[UIColor greenColor];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.f_maCK.frame.origin.x, 0, self.f_maCK.frame.size.width, utils.rowHeight-1)];
    label.text = stock.MaCK;
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = utils.cellBackgroundColor;
    label.textColor = color;
    [label setFont:[UIFont fontWithName:utils.fontFamily size:utils.fontSize]];
    [cell addSubview:label];
    [label release];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(self.f_giaTT.frame.origin.x, 0, self.f_giaTT.frame.size.width, utils.rowHeight-1)];
    label.text = [NSString stringWithFormat:@"%@ ",[utils.numberFormatter2Digits stringFromNumber:[NSNumber numberWithDouble:stock.GiaThiTruong]]];
    label.textAlignment = UITextAlignmentRight;
    label.backgroundColor = utils.cellBackgroundColor;
    label.textColor = color;
    [label setFont:[UIFont fontWithName:utils.fontFamily size:utils.fontSize]];
    [cell addSubview:label];
    [label release];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(self.f_tongKL.frame.origin.x, 0, self.f_tongKL.frame.size.width, utils.rowHeight-1)];
    label.text = [NSString stringWithFormat:@"%@ ",[utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:stock.KLTinhGiaVon]]];
    label.textAlignment = NSTextAlignmentRight;
    label.backgroundColor = utils.cellBackgroundColor;
    label.textColor = color;
    [label setFont:[UIFont fontWithName:utils.fontFamily size:utils.fontSize]];
    [cell addSubview:label];
    [label release];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(self.f_giaVon.frame.origin.x, 0, self.f_giaVon.frame.size.width, utils.rowHeight-1)];
    label.text = [NSString stringWithFormat:@"%@ ",[utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:stock.GiaVon]]];
    label.textAlignment = NSTextAlignmentRight;
    label.backgroundColor = utils.cellBackgroundColor;
    label.textColor = color;
    [label setFont:[UIFont fontWithName:utils.fontFamily size:utils.fontSize]];
    [cell addSubview:label];
    [label release];
    
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(self.f_tien.frame.origin.x, 0, self.f_tien.frame.size.width, utils.rowHeight-1)];
    label.text = [NSString stringWithFormat:@"%@ ",[utils.numberFormatter2Digits stringFromNumber:[NSNumber numberWithDouble:tien]]];
    label.textAlignment = NSTextAlignmentRight;
    label.backgroundColor = utils.cellBackgroundColor;
    label.textColor = color;
    [label setFont:[UIFont fontWithName:utils.fontFamily size:utils.fontSize]];
    [cell addSubview:label];
    [label release];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(self.f_tiLe.frame.origin.x, 0, self.f_tiLe.frame.size.width, utils.rowHeight-1)];
    label.text = [NSString stringWithFormat:@"%@ ",[utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:stock.GiaVon==0?0:tiLe]]];
    label.textAlignment = NSTextAlignmentRight;
    label.backgroundColor = utils.cellBackgroundColor;
    label.textColor = color;
    [label setFont:[UIFont fontWithName:utils.fontFamily size:utils.fontSize]];
    [cell addSubview:label];
    [label release];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(self.f_giaTriVon.frame.origin.x, 0, self.f_giaTriVon.frame.size.width, utils.rowHeight-1)];
    label.text = [NSString stringWithFormat:@"%@",[utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:giaTriVon]]];
    label.textAlignment = NSTextAlignmentRight;
    label.backgroundColor = utils.cellBackgroundColor;
    label.textColor = color;
    [label setFont:[UIFont fontWithName:utils.fontFamily size:utils.fontSize]];
    [cell addSubview:label];
    [label release];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(self.f_giaTriTT.frame.origin.x, 0, self.f_giaTriTT.frame.size.width, utils.rowHeight-1)];
    label.text = [NSString stringWithFormat:@"%@ ",[utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:giaTriTT]]];
    label.textAlignment = NSTextAlignmentRight;
    label.backgroundColor = utils.cellBackgroundColor;
    label.textColor = color;
    [label setFont:[UIFont fontWithName:utils.fontFamily size:utils.fontSize]];
    [cell addSubview:label];
    [label release];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(self.f_catLo.frame.origin.x, 0, self.f_catLo.frame.size.width, utils.rowHeight-1)];
    label.text = [NSString stringWithFormat:@"%@ ",[utils.numberFormatter1Digits stringFromNumber:[NSNumber numberWithDouble:stock.CatLo]]];
    label.textAlignment = NSTextAlignmentRight;
    label.backgroundColor = color_catlo;
    label.textColor = [UIColor lightGrayColor];
    [label setFont:[UIFont fontWithName:@"Arial-BoldMT" size:utils.fontSize]];
    [cell addSubview:label];
    [label release];
    UIButton *catlo_ = [UIButton buttonWithType:UIButtonTypeCustom];
    catlo_.frame = label.frame;
    catlo_.tag=indexPath.row;
    [catlo_ addTarget:self action:@selector(catlo_touch:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:catlo_];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(self.f_chotLoi.frame.origin.x, 0, self.f_chotLoi.frame.size.width, utils.rowHeight-1)];
    label.text = [NSString stringWithFormat:@"%@ ",[utils.numberFormatter1Digits stringFromNumber:[NSNumber numberWithDouble:stock.ChotLoi]]];
    label.textAlignment = NSTextAlignmentRight;
    label.backgroundColor = color_chotloi;
    label.textColor = [UIColor lightGrayColor];
    [label setFont:[UIFont fontWithName:@"Arial-BoldMT" size:utils.fontSize]];
    //label.font = System
    [cell addSubview:label];
    [label release];
    UIButton *chotloi_ = [UIButton buttonWithType:UIButtonTypeCustom];
    chotloi_.frame = label.frame;
    chotloi_.tag=indexPath.row;
    [chotloi_ addTarget:self action:@selector(chotloi_touch:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:chotloi_];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(self.f_thietLap.frame.origin.x, 0, self.f_thietLap.frame.size.width, utils.rowHeight-1)];
    label.backgroundColor = utils.cellBackgroundColor;
    [cell addSubview:label];
    [label release];
    
    UIButton *catlo = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect rect=  CGRectMake(self.f_thietLap.frame.origin.x+self.f_thietLap.frame.size.width/2-15, 2, 26, 26);
    catlo.frame = rect;
    
    [catlo setBackgroundImage:[UIImage imageNamed:@"chotloi-catlo.png"] forState:UIControlStateNormal];
    catlo.backgroundColor = [UIColor clearColor];
    catlo.tag = indexPath.row;
    [catlo addTarget:self action:@selector(update_touch:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell addSubview:catlo];
    [catlo release];
    
    return cell;
}

-(IBAction)catlo_touch:(id)sender
{
    VDSCMainViewController *mainView = (VDSCMainViewController*)self.delegate;
    VDSCObjectStockBalance *obj=((VDSCObjectStockBalance*)[array_sorted objectAtIndex:((UIButton*)sender).tag]);
    mainView.stockId =obj.MaCK;
    mainView.priceOrder = obj.CatLo;
    mainView.orderSide=@"S";
    UITableViewCell *cell = (UITableViewCell*)[((UIButton*)sender) superview];
    [mainView showOrderView:sender orderEntity:nil inView:cell];
}

-(IBAction)chotloi_touch:(id)sender
{
    VDSCMainViewController *mainView = (VDSCMainViewController*)self.delegate;
    VDSCObjectStockBalance *obj=((VDSCObjectStockBalance*)[array_sorted objectAtIndex:((UIButton*)sender).tag]);
    mainView.stockId =obj.MaCK;
    mainView.priceOrder = obj.ChotLoi;
    mainView.orderSide=@"S";
    UITableViewCell *cell = (UITableViewCell*)[((UIButton*)sender) superview];
    [mainView showOrderView:sender orderEntity:nil inView:cell];
}
-(IBAction)update_touch:(id)sender
{
    UITableViewCell *cell = (UITableViewCell*)[((UIButton*)sender) superview];
    VDSCObjectStockBalance *stock = [array_sorted objectAtIndex:((UIButton*)sender).tag];
    VDSCListSettingViewController*   popover_Vew = [[self.superview.window.rootViewController storyboard] instantiateViewControllerWithIdentifier:@"ListSetting"];
    
    popover_Vew.delegate=self;
    popover_Vew.stockEntity = stock;
    [popover_Vew initData];
    //if(self.popover==nil)
    self.popover = [[UIPopoverController alloc] initWithContentViewController:popover_Vew];
    UIButton *button = (UIButton*)sender;
    CGRect rect=CGRectMake(button.frame.origin.x, button.frame.origin.y, 50, 30);
    [self.popover presentPopoverFromRect:rect inView:cell permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
}

- (void)dealloc {
    [_f_maCK release];
    [_f_tongKL release];
    [_f_giaVon release];
    [_f_giaTT release];
    [_f_tien release];
    [_f_tiLe release];
    [_f_chotLoi release];
    [_f_catLo release];
    [_table_list release];
    [_f_tongCong release];
    [_f_giaTriLoiLo release];
    [_f_tiLeLoiLo release];
    [timer invalidate];
    timer = nil;
    [array_sorted release];
    
    [array release];
    [utils release];
    if(self.popover !=nil)
        [self.popover release];
    [_f_giaTriVon release];
    [_f_giaTriTT release];
    [_f_tongCongTT release];
    [_f_thietLap release];
    [_f_tongCong_text release];
    [super dealloc];
}
@end
