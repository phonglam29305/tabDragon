//
//  VDSCLoginView.m
//  iPadDragon
//
//  Created by vdsc on 12/25/12.
//  Copyright (c) 2012 VDSC. All rights reserved.
//

#import "VDSCLoginView.h"
#import "VDSCViewController.h"
//#import "GDataXMLNode.h"
#import "VDSCCommonUtils.h"

@interface VDSCLoginView()
{
    NSString *currentElement;
    VDSCCommonUtils *utils;
}

@end
@implementation VDSCLoginView

@synthesize fieldMaTK;
@synthesize fieldMaBaoVe;
@synthesize fieldMatKhau;
@synthesize webData;
@synthesize array;
@synthesize scrollView;
@synthesize capcha;
@synthesize btnLogin;
@synthesize activeField;


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
 
 }
 */

-(void) awakeFromNib
{
    [super awakeFromNib];
    [self registerForKeyboardNotifications];
    self.fieldMatKhau.secureTextEntry=YES;
    utils = [[VDSCCommonUtils alloc] init];
}


- (IBAction)btnLogin:(id)sender {
    [self.fieldMatKhau resignFirstResponder];
    [self.fieldMaTK resignFirstResponder];
    NSString *post = [NSString stringWithFormat:@"info=KW_WS_EXECPWD:::%@@@@KW_CLIENTID:::%@@@@KW_CLIENTPWD:::%@",[NSString stringWithFormat:@"Abc123XYZ2013_%@", [utils.shortDateFormater stringFromDate: [NSDate date]]],self.fieldMaTK.text,self.fieldMatKhau.text];
    NSString *url = @"http://192.168.2.29/idragon/tab/tabLogin.action";
    NSDictionary *allDataDictionary = [utils getDataFromUrl:url method:@"POST" postData:post];
    //NSArray *data = [[allDataDictionary objectForKey:@"list"] copy];
    if([[allDataDictionary objectForKey:@"success"] boolValue])
    {
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setObject:[allDataDictionary objectForKey:@"name"] forKey:@"clientName"];
        [user setObject:self.fieldMaTK.text forKey:@"clientID"];
        [user setObject:[allDataDictionary objectForKey:@"secret"] forKey:@"secret"];
        [user setObject:[allDataDictionary objectForKey:@"tradingAccSeq"] forKey:@"tradingAccSeq"];
        [user setObject:[allDataDictionary objectForKey:@"accountType"] forKey:@"accountType"];
        [user setDouble:[[allDataDictionary objectForKey:@"orderFee"] doubleValue] forKey:@"tempFee"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [((VDSCViewController *)self.window.rootViewController) hideLoginView];
    }
    else
    {
        [self loginFail:[allDataDictionary objectForKey:@"errCode"]];
        return;
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [webData setLength:0];
}
-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Fail:********************");
}
-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [webData appendData:data];
}
-(void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"Done. received Bytes %d", [self.webData length]);
    if([self.webData length]==0)
    {
        [self loginFail:@""];
        return;
    }
    //NSString *json = [[NSString alloc] initWithBytes:[webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
    //NSLog(json);
    NSDictionary *allDataDictionary = [NSJSONSerialization JSONObjectWithData:webData options:0 error:nil];
    //NSArray *data = [[allDataDictionary objectForKey:@"list"] copy];
    if([[allDataDictionary objectForKey:@"success"] boolValue])
    {
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setObject:[allDataDictionary objectForKey:@"name"] forKey:@"clientName"];
        [user setObject:self.fieldMaTK.text forKey:@"clientID"];
        [user setObject:[allDataDictionary objectForKey:@"secret"] forKey:@"secret"];
        [user setObject:[allDataDictionary objectForKey:@"tradingAccSeq"] forKey:@"tradingAccSeq"];
        [user setObject:[allDataDictionary objectForKey:@"accountType"] forKey:@"accountType"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self.fieldMatKhau resignFirstResponder];
        [((VDSCViewController *)self.window.rootViewController) hideLoginView];
    }
    else
    {
        [self loginFail:[allDataDictionary objectForKey:@"errCode"]];
        return;
    }
}
-(void)loginFail:(NSString *)errorCode
{
    NSString *message = @"";
    
    if ([errorCode isEqualToString:@"HKSEF0034"])
        message = @"Sai thông tin đăng nhập";
    if ([errorCode isEqualToString:@"HKSEF0035"])
        message = @"Tài khoản bị khóa";
    if ([errorCode isEqualToString:@"CORE10155"])
        message = @"Không tồn tại TK này";
    if ([errorCode isEqualToString:@"ERRCODE_8888"])
        message = @"Web method bị exeception";
    if ([errorCode isEqualToString:@"ERRCODE_9999"])
        message = @"Pwd Data bị hết hạn";
    else
        message = @"Đăng nhập không thành công";
    
    
    [self.fieldMatKhau resignFirstResponder];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Đăng nhập hệ thống" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
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
    [UIView beginAnimations:@"nove" context:NULL];
    [UIView setAnimationDuration:0.25];
    self.frame= CGRectMake(self.frame.origin.x, self.frame.origin.y-150, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    //}
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    //if(activeField == fieldMaBaoVe)
    //{
    [UIView beginAnimations:@"nove" context:NULL];
    [UIView setAnimationDuration:0.25];
    self.frame= CGRectMake(self.frame.origin.x, self.frame.origin.y+150, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    //}
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = textField;
    //NSLog(textField);
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeField = nil;
}
- (void)dealloc {
    [scrollView release];
    [btnLogin release];
    [self unregisterForKeyboardNotifications];
    [super dealloc];
}
@end
