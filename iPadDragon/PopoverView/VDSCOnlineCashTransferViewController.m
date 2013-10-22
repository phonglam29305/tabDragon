//
//  VDSCOnlineCashTransferViewController.m
//  iPadDragon
//
//  Created by vdsc on 4/3/13.
//  Copyright (c) 2013 VDSC. All rights reserved.
//

#import "VDSCOnlineCashTransferViewController.h"
#import "VDSCCommonUtils.h"
#import "VDSCCashTranferServices.h"

@interface VDSCOnlineCashTransferViewController ()
{
    VDSCCommonUtils *utils;
    NSMutableArray *array;
}
@end

@implementation VDSCOnlineCashTransferViewController

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
    utils = [[VDSCCommonUtils alloc] init];
    array = [[NSMutableArray alloc] init];
    self.table_accList.delegate = self;
    self.table_accList.dataSource = self;
    [self performSelectorInBackground:@selector(loadData) withObject:nil];
}
-(void) loadData
{
    NSArray *arr = [[NSArray alloc] initWithObjects:@"KW_CLIENTSECRET",utils.clientInfo.secret, @"KW_CLIENTID", utils.clientInfo.clientID, nil];
    NSString *post = [utils postValueBuilder:arr];
    
    NSString *url = [[NSUserDefaults standardUserDefaults] stringForKey:@"onlineTranferList"];
    NSDictionary *allDataDictionary = [[utils getDataFromUrl:url method:@"POST" postData:post] retain];
    if([[allDataDictionary objectForKey:@"success"] boolValue])
    {
        if(![[allDataDictionary objectForKey:@"list"] isEqual:[NSNull null]])
            for(NSDictionary *arr in [allDataDictionary objectForKey:@"list"])
            {
                NSArray *obj = [[NSArray alloc] initWithObjects:[arr objectForKey:@"accountId"]
                                , [arr objectForKey:@"bankName"]
                                , [arr objectForKey:@"accountName"]
                                , [arr objectForKey:@"fee"]
                                , nil];
                [array addObject:obj];
                [obj release];
            }
        
        if(array.count>0)
            [self.table_accList reloadData];
    }
    [arr release];
    [allDataDictionary release];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSArray *dic = [array objectAtIndex:indexPath.row];
    //self.bankName= [dic objectForKey:@"bankName"];
    // self.accountId=[dic objectForKey:@"accountId"];
    //self.accountName=[dic objectForKey:@"accountName"];
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if(self.delegate !=nil)
    {
        [((VDSCCashTranferServices*)self.delegate).btn_taikhoannhan setTitle:[NSString stringWithFormat:@"%@",[dic objectAtIndex:0]] forState:UIButtonTypeCustom];
        ( (VDSCCashTranferServices*)self.delegate).txtChuTaiKhoan.text=[NSString stringWithFormat:@"%@",[dic objectAtIndex:2]];
        ( (VDSCCashTranferServices*)self.delegate).txtNganHang.text=[NSString stringWithFormat:@"%@",[dic objectAtIndex:1]];
        
        if([[dic objectAtIndex:3] isEqual:@"null"])
        {
            ((VDSCCashTranferServices*)self.delegate).txtMucPhiChuyenKhoan.text=@"-";
        }
        else
        {
            ((VDSCCashTranferServices*)self.delegate).txtMucPhiChuyenKhoan.text=[NSString stringWithFormat:@"%@%%",[dic objectAtIndex:3]];
        }
        [( (VDSCCashTranferServices*)self.delegate).popover dismissPopoverAnimated:YES];
    }
    else
    {
        ((VDSCCashTranferServices*)self.delegate).txtTaiKhoanNhan.text = @"-";
        ( (VDSCCashTranferServices*)self.delegate).btn_taikhoannhan.titleLabel.text=@"-";
        ( (VDSCCashTranferServices*)self.delegate).txtNganHang.text=@"-";
        ((VDSCCashTranferServices*)self.delegate).txtMucPhiChuyenKhoan.text=@"0";       // ( (VDSCCashTranferServices*)self.delegate).segNguoiTraPhi.enabled=YES;
    }
    
    
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{return 1;}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{return 25;}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return array.count;
}
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger i=indexPath.row;
    NSArray *dic = [array objectAtIndex:i];
    NSString *cellIndentifier = @"VDSCFullCellPrice";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellIndentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        [cell autorelease];
        
        //if([nsclass class]){return cell;}
        int x=5;
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(x, 0, 170, 24);
        label.text = [dic objectAtIndex:0];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont fontWithName:@"arial" size:13];
        label.textColor = [UIColor lightGrayColor];
        label.tag=10;
        [cell addSubview:label];
        [label release];
        
        x=label.frame.origin.x+5+label.frame.size.width;
        label = [[UILabel alloc] init];
        label.frame = CGRectMake(x, 0, 120, 24);
        label.text = [dic objectAtIndex:1];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont fontWithName:@"arial" size:13];
        label.tag=11;
        
        [cell addSubview:label];
        [label release];
        
        x=label.frame.origin.x+5+label.frame.size.width;
        label = [[UILabel alloc] init];
        label.frame = CGRectMake(x, 0, 296, 24);
        label.text = [dic objectAtIndex:2];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont fontWithName:@"arial" size:13];
        label.tag=12;
        [cell addSubview:label];
        [label release];
    }
    else{
        UILabel *label = (UILabel*)[cell viewWithTag:10];
        label.text = [dic objectAtIndex:0];
        
        label = (UILabel*)[cell viewWithTag:11];
        label.text = [dic objectAtIndex:1];
        
        label = (UILabel*)[cell viewWithTag:12];
        label.text = [dic objectAtIndex:2];    }
    
    return  cell;
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    [utils release];
    [array release];
    [_table_accList release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTable_accList:nil];
    [super viewDidUnload];
}
@end
