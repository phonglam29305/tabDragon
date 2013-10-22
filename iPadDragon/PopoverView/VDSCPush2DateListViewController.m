//
//  VDSCPush2DateListViewController.m
//  iPadDragon
//
//  Created by vdsc on 4/14/13.
//  Copyright (c) 2013 VDSC. All rights reserved.
//

#import "VDSCPush2DateListViewController.h"
#import "VDSCCommonUtils.h"
#import "VDSCOrderView.h"
#import "VDSCEntitlementServices.h"
#import "VDSCEntitlementEntity.h"
#import "VDSCMarginTransServices.h"
#import "VDSCEditOrderViewController.h"
#import "VDSCAccountInfoView.h"

@interface VDSCPush2DateListViewController ()
{
    NSMutableArray *array;
    NSMutableArray *array_services;
    VDSCCommonUtils *utils;
    NSArray *arrServices;
}
@end

@implementation VDSCPush2DateListViewController

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
	// Do any additional setup after loading the view.
    
    array = [[NSMutableArray alloc] init];
    array_services = [[NSMutableArray alloc] init];
    utils = [[VDSCCommonUtils alloc] init];
    self.picker_dateList.dataSource = self;
    self.picker_dateList.delegate = self;
    [self loadData];
    
    if([self.delegate isKindOfClass:[VDSCMarginTransServices class]]||[self.delegate isKindOfClass:[VDSCAccountInfoView class]]){
        CGSize size = CGSizeMake(320, 216); // size of view in popover
        self.contentSizeForViewInPopover = size;
    }
}
- (void)viewWillAppear:(BOOL)animated {
    if([self.delegate isKindOfClass:[VDSCMarginTransServices class]]||[self.delegate isKindOfClass:[VDSCAccountInfoView class]]){
        CGSize size = CGSizeMake(320, 216); // size of view in popover
        self.contentSizeForViewInPopover = size;
        
        [super viewWillAppear:animated];
    }
}
-(void)loadData
{
    [self.picker_dateList setUserInteractionEnabled:YES];
    NSDictionary *allDataDictionary = nil;
    NSArray *arr =nil;
    @try{
        if([self.delegate isKindOfClass:[VDSCOrderView class]] ||[self.delegate isKindOfClass:[VDSCEditOrderViewController class]] )
        {
            arr = [[NSArray alloc] initWithObjects:@"KW_CLIENTSECRET",utils.clientInfo.secret
                   , @"KW_CLIENTID", utils.clientInfo.clientID
                   , nil];
            NSString *post = [utils postValueBuilder:arr];
            
            NSString *url = [[NSUserDefaults standardUserDefaults] stringForKey:@"getGtdList"];
            allDataDictionary = [[utils getDataFromUrl:url method:@"POST" postData:post] retain];
            if([[allDataDictionary objectForKey:@"success"] boolValue])
            {
                if(![[allDataDictionary objectForKey:@"list"] isEqual:[NSNull null]])
                {
                    for(NSString *item in [allDataDictionary objectForKey:@"list"])
                    {
                        [array addObject:item];
                    }
                    
                    [self.picker_dateList selectRow:1 inComponent:0 animated:NO];
                }
            }
        }
        else if([self.delegate isKindOfClass:[VDSCEntitlementServices class]])
        {
            arr = [[NSArray alloc] initWithObjects:@"KW_CLIENTSECRET",utils.clientInfo.secret
                   , @"KW_CLIENTID", utils.clientInfo.clientID
                   , nil];
            NSString *post = [utils postValueBuilder:arr];
            
            NSString *url = [[NSUserDefaults standardUserDefaults] stringForKey:@"entitlementInfo"];
            allDataDictionary = [utils getDataFromUrl:url method:@"POST" postData:post];
            if([[allDataDictionary objectForKey:@"success"] boolValue])
            {
                NSArray *list=[allDataDictionary objectForKey:@"stocks"];
                if(![list isEqual:[NSNull null]])
                {
                    VDSCEntitlementEntity *obj;
                    for(NSArray *arr in list)
                    {
                        obj = [[VDSCEntitlementEntity alloc] init];
                        obj.stockId =[arr objectAtIndex:0];
                        obj.stockName =[arr objectAtIndex:1];
                        obj.endDate =[arr objectAtIndex:3];
                        obj.startRegDate =[arr objectAtIndex:4];
                        obj.lastRegDate =[arr objectAtIndex:5];
                        obj.ratio =[arr objectAtIndex:6];
                        obj.currQty =[[arr objectAtIndex:7] intValue];
                        obj.roomQty =[[arr objectAtIndex:8] intValue];
                        obj.remainQty =[[arr objectAtIndex:9] intValue];
                        obj.buyPrice =[[arr objectAtIndex:10] floatValue];
                        obj.entitlementStock =[arr objectAtIndex:11];
                        obj.locationId =[arr objectAtIndex:12];
                        obj.marketId =[arr objectAtIndex:13];
                        obj.entitlementId =[arr objectAtIndex:14];
                        
                        [array addObject:obj];
                        [obj release];
                    }
                    if(array.count>0){
                        [self.picker_dateList selectRow:0 inComponent:0 animated:NO];
                        VDSCEntitlementServices *services = (VDSCEntitlementServices*)self.delegate;
                        services.entitlementEntity = [array objectAtIndex:0];
                        [services setData2Controls];
                    }
                    
                }
            }
            
            [self.picker_dateList setUserInteractionEnabled:array.count>0];
        }
        else if([self.delegate isKindOfClass:[VDSCMarginTransServices class]])
        {
            VDSCMarginTransServices *margin = (VDSCMarginTransServices*)self.delegate;
            if(margin.loaiGD1_listLoaiGD2_TKUQ3==1)
                arrServices = [NSArray arrayWithObjects:@"Chuyển sức mua",@"Tăng dư nợ",@"Giảm dư nợ",@"Gia hạn hợp đồng", nil];
            else
                if(margin.loaiGD1_listLoaiGD2_TKUQ3==2)
                    arrServices = [NSArray arrayWithObjects:@"Tất cả",@"Chuyển sức mua",@"Tăng dư nợ",@"Giảm dư nợ",@"Gia hạn hợp đồng", nil];
                //else arrServices = self.array_TKUQ;
            
            if(margin.loaiGD1_listLoaiGD2_TKUQ3!=3)
            {
                [array_services removeAllObjects];
            for(NSString *item in arrServices)
            {
                [array_services addObject:item];
            }
            }
            UIView *view;
            if(margin.loaiGD1_listLoaiGD2_TKUQ3==1)
                
                view = margin.btn_switchServices;
            else
                if(margin.loaiGD1_listLoaiGD2_TKUQ3==2)
                    view = margin.btn_LoaiGD;
                else
                {
                    view=margin.btn_TKUyQuyen;
                    if(self.array_TKUQ.count>0)
                    {
                        [margin.btn_TKUyQuyen setTitle:[[[self.array_TKUQ objectAtIndex:view.tag] objectAtIndex:2] substringWithRange:NSMakeRange(0, 7) ]forState:UIControlStateNormal];
                        
                        [margin getAmountOfAuthorized];
                    }
                }
            
            
            [self.picker_dateList reloadAllComponents];
            if(margin.loaiGD1_listLoaiGD2_TKUQ3==3)
                [self.picker_dateList setUserInteractionEnabled:self.array_TKUQ.count>0];
            else
                [self.picker_dateList selectRow:view.tag inComponent:0 animated:YES];
        }
        else{
            [self.picker_dateList selectRow:((VDSCAccountInfoView*)self.delegate).btn_agent.tag inComponent:0 animated:NO];
            
            [((VDSCAccountInfoView*)self.delegate) setData2Controls:[self.array_agent objectAtIndex:((VDSCAccountInfoView*)self.delegate).btn_agent.tag]];
        }
    }
    @catch (NSException *ex) {
        NSLog(ex.description);
    }
    @finally {
        if(allDataDictionary!=nil)
        {
            [allDataDictionary release];
            allDataDictionary=nil;
        }
        if(arr!=nil)
        {
            [arr release];
            arr = nil;
        }
        
    }
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 35;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger rows = [array count];
    if([self.delegate isKindOfClass:[VDSCMarginTransServices class]])
    {
        if(((VDSCMarginTransServices*)self.delegate).loaiGD1_listLoaiGD2_TKUQ3!=3)
            rows=arrServices.count;
        else
            rows = self.array_TKUQ.count;
    }
    else if([self.delegate isKindOfClass:[VDSCAccountInfoView class]])
        rows=self.array_agent.count;
    return rows;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *date;// = [array objectAtIndex:row];
    if([self.delegate isKindOfClass:[VDSCEntitlementServices class]])
    {
        date = ((VDSCEntitlementEntity*)[array objectAtIndex:row]).stockId;
    }
    else
        if([self.delegate isKindOfClass:[VDSCMarginTransServices class]]){
            if(((VDSCMarginTransServices*)self.delegate).loaiGD1_listLoaiGD2_TKUQ3!=3)
            {
                date = [array_services objectAtIndex:row];
            }
            else
            {
                date = [[self.array_TKUQ objectAtIndex:row] objectAtIndex:2];
            }
        }
        else if([self.delegate isKindOfClass:[VDSCAccountInfoView class]])
        {
            date = [[self.array_agent objectAtIndex:row] objectAtIndex:0];
        }
        else date = [array objectAtIndex:row];
    return date;
}
-(void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if([self.delegate isKindOfClass:[VDSCOrderView class]])
        ((VDSCOrderView*)self.delegate).txt_hieuLuc.text = [array objectAtIndex:row];
    else if([self.delegate isKindOfClass:[VDSCEditOrderViewController class]])
        ((VDSCEditOrderViewController*)self.delegate).txt_hieuLuc.text = [array objectAtIndex:row];
    else
        if([self.delegate isKindOfClass:[VDSCEntitlementServices class]]){
            if(array.count>0){
                VDSCEntitlementServices *services = (VDSCEntitlementServices*)self.delegate;
                services.entitlementEntity = [array objectAtIndex:row];
                [services setData2Controls];
            }
        }
        else if([self.delegate isKindOfClass:[VDSCAccountInfoView class]]){
            VDSCAccountInfoView *account = (VDSCAccountInfoView*)self.delegate;
            account.btn_agent.tag=row;
            [account setData2Controls:[self.array_agent objectAtIndex:row]];
        }
        else{
            VDSCMarginTransServices *margin = (VDSCMarginTransServices*)self.delegate;
            if(margin.loaiGD1_listLoaiGD2_TKUQ3==1)
            {
                [margin.btn_switchServices setTitle:[array_services objectAtIndex:row ] forState:UIControlStateNormal];
                margin.btn_switchServices.tag=row;
                [margin switchServices];
            }
            else if(margin.loaiGD1_listLoaiGD2_TKUQ3==2){
                [margin.btn_LoaiGD setTitle:[array_services objectAtIndex:row ] forState:UIControlStateNormal];
                margin.btn_LoaiGD.tag=row;
            }
            else
            {
                [margin.btn_TKUyQuyen setTitle:[[[self.array_TKUQ objectAtIndex:row] objectAtIndex:2]substringWithRange:NSMakeRange(0, 7) ]forState:UIControlStateNormal];
                margin.btn_TKUyQuyen.tag=row;
                [margin getAmountOfAuthorized];
            }
        }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_picker_dateList release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setPicker_dateList:nil];
    [super viewDidUnload];
}
@end
