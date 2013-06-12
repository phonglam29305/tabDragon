//
//  VDSCOrderConfirmServices.m
//  iPadDragon
//
//  Created by vdsc on 4/4/13.
//  Copyright (c) 2013 VDSC. All rights reserved.
//

#import "VDSCOrderConfirmServices.h"
#import "VDSCCommonUtils.h"
#import "VDSCOrderConfirmServicesCell.h"
#import "VDSCObjectOrderComfirm.h"
#import "SSCheckBoxView.h"
#import "UIHelpers.h"
#import "VDSCOTPView.h"


@implementation VDSCOrderConfirmServices{
    VDSCCommonUtils *utils;
    NSMutableArray *array_Orders;
    UIWebView *loading;
    SSCheckBoxView *cbv;
    VDSCOTPView *otp;
}

@synthesize tabOrdersConfirmList=_tabOrdersConfirmList;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    @try{
        utils=[[VDSCCommonUtils alloc]init];
        [self InitControls];
        //[self registerForKeyboardNotifications];
        [self.view_confirm setHidden:YES];
    }
    @catch (NSException *exception) {
        NSLog(exception.description);
    }
}
-(void)InitControls
{
    
    otp = [[[NSBundle mainBundle] loadNibNamed:@"VDSCOTPView" owner:self options:nil] objectAtIndex:0];
    otp.frame = CGRectMake(0, 0, 360, 30);
    otp.backgroundColor = otp.superview.backgroundColor;
    [self.otpView addSubview:otp];
    
    array_Orders=[[NSMutableArray alloc]init];
    loading = [utils showLoading:self.tabOrdersConfirmList];
    [self performSelectorInBackground:@selector(LoadOrdersConfirm) withObject:nil];
    [self.tabOrdersConfirmList setDataSource:self];
    [self.tabOrdersConfirmList setDelegate:self];
    array_Orders=[[NSMutableArray alloc]init];
    
    CGRect frame = CGRectMake(940, 50, 30, 30);
    SSCheckBoxViewStyle style = (2 % kSSCheckBoxViewStylesCount);
    BOOL checked = YES;
    cbv = [[SSCheckBoxView alloc] initWithFrame:frame
                                          style:style
                                        checked:checked];
    
    [self addSubview:cbv];
    
    [cbv setStateChangedTarget:self
                      selector:@selector(checkBoxViewChangedState:)];
    
    //UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchesBegan:withEvent:)];
    //[self.tabOrdersConfirmList addGestureRecognizer:gestureRecognizer];
    
}

- (void) checkBoxViewChangedState:(SSCheckBoxView *)cbv
{
    for(VDSCObjectOrderComfirm *obj in array_Orders)
    {
        NSIndexPath *index = [NSIndexPath indexPathForRow:[array_Orders indexOfObject:obj] inSection:0];
        VDSCOrderConfirmServicesCell *cell= (VDSCOrderConfirmServicesCell*)[self.tabOrdersConfirmList cellForRowAtIndexPath:index];
        SSCheckBoxView *item = (SSCheckBoxView*)[cell viewWithTag:obj.fSTT];
        obj.checked=item.checked = cbv.checked;
    }
}
-(void)LoadOrdersConfirm
{
    NSArray *arr;
    NSDictionary *allDataDictionary;
    @try {
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *url = [NSString stringWithFormat:@"%@",[user stringForKey:@"order4Sign"]];
        arr = [[NSArray alloc] initWithObjects:
               @"KW_WS_EXECPWD",[NSString stringWithFormat:@"Abc123XYZ2013_%@",
                                 [utils.shortDateFormater stringFromDate: [NSDate date]]]
               ,@"KW_CLIENTSECRET",utils.clientInfo.secret
               ,@"KW_CLIENTID", utils.clientInfo.clientID
               ,nil
               ];
        NSString *post = [utils postValueBuilder:arr];
        allDataDictionary = [utils getDataFromUrl:url method:@"POST" postData:post];
        [array_Orders removeAllObjects];
        if([[allDataDictionary objectForKey:@"success"] boolValue])
        {
            VDSCObjectOrderComfirm *object=nil;
            NSArray *data=[allDataDictionary objectForKey:@"list"];
            
            if(![data isEqual:[NSNull null]]){
                int i=0;
                for(NSArray *arryOjEntity in data)
                {
                    i=i+1;
                    object=[[VDSCObjectOrderComfirm alloc]init];
                    object.fSTT=i;
                    object.fNgayGD= [arryOjEntity objectAtIndex:1];
                    object.fLenh=[arryOjEntity objectAtIndex:2];
                    object.fMuaBan=[arryOjEntity objectAtIndex:3];
                    object.fLoai=[arryOjEntity objectAtIndex:4];
                    object.fSan=[arryOjEntity objectAtIndex:5];
                    object.fMaCK=[arryOjEntity objectAtIndex:6];
                    object.fKLDat=[[arryOjEntity objectAtIndex:7] doubleValue];
                    object.fGiaDat=[[arryOjEntity objectAtIndex:8]doubleValue];
                    object.fKLHuy=[[arryOjEntity objectAtIndex:9] doubleValue];
                    object.fOrderID=[arryOjEntity objectAtIndex:0];
                    object.checked=YES;
                    [array_Orders addObject:object];
                    [object release];
                }
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(exception.description);
    }
    @finally {
        if(loading !=nil)
        {
            [loading removeFromSuperview];
            [loading release];
            loading = nil;
        }
        
        [self.view_confirm setHidden:array_Orders.count==0];
        
        [self.tabOrdersConfirmList reloadData];
        [arr release];
        [allDataDictionary release];
    }
    
    
}

//----4444444444444444444444444------------------------

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return utils.rowHeight;
}

//------555555555555555---------------------------------
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return array_Orders.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIndentifier = @"VDSCOrderConfirmServicesCell";
    VDSCOrderConfirmServicesCell *cell = [tableView dequeueReusableCellWithIdentifier: cellIndentifier];
    @try
    {
        //------5.11111111111111111
        if(cell == nil)
        {
            cell = [[VDSCOrderConfirmServicesCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        }
        //------5.22222222222222222
        
        if (array_Orders != nil && array_Orders.count>0)
        {
            VDSCObjectOrderComfirm *obj=[array_Orders objectAtIndex:indexPath.row];
            cell.Entity=obj;
            [cell setData2Cell];
            
            //SSCheckBoxView *item = (SSCheckBoxView*)[cell viewWithTag:obj.fSTT];
            //item.checked = obj.checked;
        }
        
        //--------------------------
    }
    @catch (NSException *exception)
    {
        // NSLog([NSString stringWithFormat:@"%@", exception.description]);
    }
    @finally
    {
        //updating = NO;
    }
    return cell;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [otp.otp_number1Value resignFirstResponder];
    [otp.otp_number2Value resignFirstResponder];
    [super touchesBegan:touches withEvent:event];
}

- (void)dealloc {
    [_tabOrdersConfirmList release];
    [self unregisterForKeyboardNotifications];
    [_otpView release];
    [_btn_confirm release];
    [_view_confirm release];
    [super dealloc];
}
- (IBAction)btn_confirm_touch:(id)sender {
    
    NSString *DanhSachLenhCanXacNhan=@"0";
    if(array_Orders!=nil && array_Orders.count>0){
        
        for(VDSCObjectOrderComfirm *obj in array_Orders)
        {
            
            if(obj.checked)
                DanhSachLenhCanXacNhan= [NSString stringWithFormat:@"%@,%@",DanhSachLenhCanXacNhan,obj.fOrderID];
            
        }
        
        if([DanhSachLenhCanXacNhan isEqualToString:@"0"])
        {
            [utils showMessage:[utils.dic_language objectForKey:@"ipad.services.orderConfirm.chooseOrders"] messageContent:nil];
            return;
        }
        if(![[NSUserDefaults standardUserDefaults] boolForKey:@"saveOTP"])
        {
            if([otp checkInput]){
                BOOL result = [utils otpCherker:otp.otp_number1.text OTPPosition2:otp.otp_number2.text OTPPosition1_Value:otp.otp_number1Value.text OTPPosition2_value:otp.otp_number2Value.text isSave:NO];
                if(!result)
                {
                    [utils showMessage:[utils.dic_language objectForKey:@"ipad.otp.saveFail"] messageContent:nil dismissAfter:1];
                    return;
                }
            }
            else return;
        }
        
        NSString *DSLenhHopLe=[DanhSachLenhCanXacNhan substringWithRange:NSMakeRange(2, [DanhSachLenhCanXacNhan length]-2)];
        
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *url = [NSString stringWithFormat:@"%@",[user stringForKey:@"signOrders"]];
        NSArray *arr_otp = [utils getOPTPosition:otp.otp_number1.text OTPPosition2:otp.otp_number2.text];
        NSArray *arr = [[NSArray alloc] initWithObjects:
                        @"KW_WS_EXECPWD",[NSString stringWithFormat:@"Abc123XYZ2013_%@",
                                          [utils.shortDateFormater stringFromDate: [NSDate date]]]
                        ,@"KW_CLIENTSECRET",utils.clientInfo.secret
                        ,@"KW_CLIENTID", utils.clientInfo.clientID
                        ,@"KW_ORDERID_LIST",DSLenhHopLe
                        , @"KW_OTP_ROWIDX",[NSString stringWithFormat:@"%@",[arr_otp objectAtIndex:0]]
                        , @"KW_OTP_COLIDX",[NSString stringWithFormat:@"%@",[arr_otp objectAtIndex:1]]
                        , @"KW_OTP_VALUE",[NSString stringWithFormat:@"%@,%@",otp.otp_number1Value.text,otp.otp_number2Value.text]
                        ,nil
                        ];
        NSString *post = [utils postValueBuilder:arr];
        NSDictionary *allDataDictionary = [utils getDataFromUrl:url method:@"POST" postData:post];
        
        if([[allDataDictionary objectForKey:@"success"] boolValue])
        {
            loading =[utils showLoading:self.tabOrdersConfirmList];
            [self performSelectorInBackground:@selector(LoadOrdersConfirm) withObject:nil ];
            [utils showMessage:[utils.dic_language objectForKey:@"ipad.services.orderConfirm.confirmSuccess"] messageContent:nil dismissAfter: 1];
            [otp resetOtpPosition];
        }
        else{
            [utils showMessage:@"Xác nhận lệnh không thành công" messageContent:nil];
            
        }
        [arr release];
        [allDataDictionary release];
    }
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[self touchesBegan:0 withEvent:nil];
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

-(void)unregisterForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)keyboardWillShown:(NSNotification*)aNotification
{
    //if(fieldMaBaoVe.editing)
    //{
    /*[UIView beginAnimations:@"nove" context:NULL];
    [UIView setAnimationDuration:0.25];
    [self bringSubviewToFront:self.view_confirm];
    self.frame= CGRectMake(self.frame.origin.x, self.frame.origin.y-160, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];*/
    //}
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    //if(activeField == fieldMaBaoVe)
    //{
   /* [UIView beginAnimations:@"nove" context:NULL];
    [UIView setAnimationDuration:0.25];
    [self bringSubviewToFront:self.view_confirm];
    self.frame= CGRectMake(self.frame.origin.x, self.frame.origin.y+160, self.view_confirm.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];*/
    //}
}

@end
