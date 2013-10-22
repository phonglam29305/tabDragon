//
//  VDSCOnlineCashTransferViewController.m
//  iPadDragon
//
//  Created by vdsc on 4/3/13.
//  Copyright (c) 2013 VDSC. All rights reserved.
//

#import "VDSCOrderMatchPriceByTimeViewController.h"
#import "VDSCCommonUtils.h"

@interface VDSCOrderMatchPriceByTimeViewController ()
{
    VDSCCommonUtils *utils;
    NSMutableArray *array;
}
@end

@implementation VDSCOrderMatchPriceByTimeViewController

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
    NSArray *arr = [[NSArray alloc] initWithObjects:@"KW_CLIENTSECRET",utils.clientInfo.secret
                    , @"KW_CLIENTID", utils.clientInfo.clientID
                    , @"KW_ORDER_ID", self.orderEntity.orderId
                    , @"KW_ORDER_GROUPID", self.orderEntity.orderGroupId
                    , nil];
    NSString *post = [utils postValueBuilder:arr];
    
    NSString *url = [[NSUserDefaults standardUserDefaults] stringForKey:@"orderMatchPriceList"];
    NSDictionary *allDataDictionary = [[utils getDataFromUrl:url method:@"POST" postData:post] retain];
    if([[allDataDictionary objectForKey:@"success"] boolValue])
    {
        if(![[allDataDictionary objectForKey:@"list"] isEqual:[NSNull null]])
            for(NSArray *arr in [allDataDictionary objectForKey:@"list"])
            {
                [array addObject:arr];
            }
        
        if(array.count>0)
            [self.table_accList reloadData];
    }
    [arr release];
    [allDataDictionary release];
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
        int x=0;
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(x, 0, 171, 24);
        label.text = [dic objectAtIndex:2];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont fontWithName:utils.fontFamily size:utils.fontSize];
        label.tag=10;
        [cell addSubview:label];
        [label release];
        
        x=label.frame.origin.x+label.frame.size.width;
        label = [[UILabel alloc] init];
        label.frame = CGRectMake(x, 0, 93, 24);
        double d=[[dic objectAtIndex:1] doubleValue];
        label.text = [NSString stringWithFormat:@"%@", [utils.numberFormatter1Digits stringFromNumber:[NSNumber numberWithDouble:d]]];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont fontWithName:utils.fontFamily size:utils.fontSize];
        label.textAlignment = UITextAlignmentRight;
        label.tag=11;
        [cell addSubview:label];
        [label release];
        
        x=label.frame.origin.x+label.frame.size.width;
        label = [[UILabel alloc] init];
        label.frame = CGRectMake(x, 0, 99, 24);
         d=[[dic objectAtIndex:0] doubleValue];
        label.text = [NSString stringWithFormat:@"%@", [utils.numberFormatter1Digits stringFromNumber:[NSNumber numberWithDouble:d]]];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont fontWithName:utils.fontFamily size:utils.fontSize];
        label.textAlignment = UITextAlignmentRight;
        label.tag=12;
        [cell addSubview:label];
        [label release];
    }
    else{
        UILabel *label = (UILabel*)[cell viewWithTag:10];
        label.text = [dic objectAtIndex:2];
        
        label = (UILabel*)[cell viewWithTag:11];
        double d=[[dic objectAtIndex:1] doubleValue];
        label.text = [NSString stringWithFormat:@"%@", [utils.numberFormatter1Digits stringFromNumber:[NSNumber numberWithDouble:d]]];
        
        label = (UILabel*)[cell viewWithTag:12];
        d=[[dic objectAtIndex:0] doubleValue];
        label.text = [NSString stringWithFormat:@"%@", [utils.numberFormatter1Digits stringFromNumber:[NSNumber numberWithDouble:d]]];
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
