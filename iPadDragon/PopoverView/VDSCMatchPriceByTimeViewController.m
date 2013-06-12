//
//  VDSCOnlineCashTransferViewController.m
//  iPadDragon
//
//  Created by vdsc on 4/3/13.
//  Copyright (c) 2013 VDSC. All rights reserved.
//

#import "VDSCMatchPriceByTimeViewController.h"
#import "VDSCCommonUtils.h"

@interface VDSCMatchPriceByTimeViewController ()
{
    VDSCCommonUtils *utils;
}
@end

@implementation VDSCMatchPriceByTimeViewController

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
    self.table_accList.delegate = self;
    self.table_accList.dataSource = self;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{return 1;}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{return 25;}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIndentifier = @"VDSCFullCellPrice";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    
    NSInteger i=indexPath.row;
    NSArray *dic = [self.dataSource objectAtIndex:i];
    
    //if([nsclass class]){return cell;}
    int x=0;
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(x, 0, 121, 24);
    label.text = [dic objectAtIndex:0];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:utils.fontFamily size:utils.fontSize];
    label.textAlignment = UITextAlignmentCenter;
    [cell addSubview:label];
    [label release];
    
    x=label.frame.origin.x+label.frame.size.width;
    label = [[UILabel alloc] init];
    label.frame = CGRectMake(x, 0, 121, 24);
    double d=[[dic objectAtIndex:1] doubleValue];
    label.text = [NSString stringWithFormat:@"%@", [utils.numberFormatter1Digits stringFromNumber:[NSNumber numberWithDouble:d]]];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:utils.fontFamily size:utils.fontSize];
    label.textAlignment = UITextAlignmentRight;
    [cell addSubview:label];
    [label release];
    
    x=label.frame.origin.x+label.frame.size.width;
    label = [[UILabel alloc] init];
    label.frame = CGRectMake(x, 0, 121, 24);
    d=[[dic objectAtIndex:2] doubleValue];
    label.text = [NSString stringWithFormat:@"%@", [utils.numberFormatter stringFromNumber:[NSNumber numberWithDouble:d]]];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:utils.fontFamily size:utils.fontSize];
    label.textAlignment = UITextAlignmentRight;
    [cell addSubview:label];
    [label release];
    
    x=label.frame.origin.x+label.frame.size.width;
    label = [[UILabel alloc] init];
    label.frame = CGRectMake(x, 0, 120, 24);
    d=[[dic objectAtIndex:3] doubleValue];
    label.text = [NSString stringWithFormat:@"%@", [utils.numberFormatter stringFromNumber:[NSNumber numberWithDouble:d]]];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:utils.fontFamily size:utils.fontSize];
    label.textAlignment = UITextAlignmentRight;
    [cell addSubview:label];
    [label release];
    //}
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
    [_dataSource release];
    [_table_accList release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTable_accList:nil];
    [super viewDidUnload];
}
@end
