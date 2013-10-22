//
//  VDSCListCashTranmfer_VC.m
//  iPadDragon
//
//  Created by Lion User on 08/04/2013.
//  Copyright (c) 2013 VDSC. All rights reserved.
//

#import "VDSCListCashTranfer_VC.h"
#import "VDSCCommonUtils.h"
@interface VDSCListCashTranfer_VC ()
{
    VDSCCommonUtils *utils;
    NSMutableArray *array;
}
@end


@implementation VDSCListCashTranfer_VC


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
    [self loadData];
    
}

-(void) loadData
{
    NSArray *arr = [[NSArray alloc] initWithObjects:@"KW_CLIENTSECRET",utils.clientInfo.secret, @"KW_CLIENTID", utils.clientInfo.clientID, nil];
    NSString *post = [utils postValueBuilder:arr];
    
    NSString *url = [[NSUserDefaults standardUserDefaults] stringForKey:@"onlineTranferList"];
    NSDictionary *allDataDictionary = [utils getDataFromUrl:url method:@"POST" postData:post];
    if([[allDataDictionary objectForKey:@"success"] boolValue])
    {
        for(NSArray *arr in [allDataDictionary objectForKey:@"list"])
        {
            [array addObject:arr];
            [arr release];
        }
        
        if(array.count>0)
            [self.table_accList reloadData];
    }
    [arr release];
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
    NSDictionary *dic = [array objectAtIndex:indexPath.row];
    NSString *cellIndentifier = @"VDSCFullCellPrice";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellIndentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        [cell autorelease];
    //NSInteger i=indexPath.row;
    if(dic.count==0){return cell;}
    int x=5;
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(x, 0, 170, 24);
    label.text = [dic objectForKey:@"accountId"];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"arial" size:13];
        label.tag=10;
    [cell addSubview:label];
    [label release];
    
    x=label.frame.origin.x+5+label.frame.size.width;
    label = [[UILabel alloc] init];
    label.frame = CGRectMake(x, 0, 120, 24);
    label.text = [dic objectForKey:@"bankName"];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"arial" size:13];
        label.tag=11;
    [cell addSubview:label];
    [label release];
    
    x=label.frame.origin.x+5+label.frame.size.width;
    label = [[UILabel alloc] init];
    label.frame = CGRectMake(x, 0, 145, 24);
    label.text = [dic objectForKey:@"accountName"];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"arial" size:13];
        label.tag=12;
    [cell addSubview:label];
    [label release];
    
    }
    else{
        UILabel *label = (UILabel*)[cell viewWithTag:10];
        label.text = [dic objectForKey:@"accountId"];
        
        label = (UILabel*)[cell viewWithTag:11];
        label.text = [dic objectForKey:@"bankName"];
        
        label = (UILabel*)[cell viewWithTag:12];
        label.text = [dic objectForKey:@"accountName"];
    }
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
