//
//  ViewController.m
//  eatapp
//
//  Created by Kui_Ye on 14-7-2.
//  Copyright (c) 2014年 Kui_Ye. All rights reserved.
//

#import "ViewController.h"
#import "WsqMD5Util.h"
#import "MKNetworkEngine.h"
#import "MKNetworkKit.h"
#import "MKNetworkOperation.h"
#import "SBJson.h"
#import "SBJsonParser.h"
#import "SBJsonStreamParser.h"
#import "SBJsonStreamWriter.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *pwd;
@property (weak, nonatomic) IBOutlet UILabel *test;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)end:(id)sender {
    [sender resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)button:(id)sender {
    NSString *myname=_name.text;
    NSString *mypwd=_pwd.text;
   // NSString *fileMD5 = [WsqMD5Util getFileMD5WithPath:@"11"];
    NSLog(myname);
    NSString* fileMD5 = [WsqMD5Util getmd5WithString:mypwd];
    NSLog(mypwd);
                  //       NSLog(fileMD5);
    NSString* url=@"login.php?uname=";
    NSString *c = [url stringByAppendingString:myname];
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:@"10.1.13.107/www/app/app"
                                                    customHeaderFields:nil];
    MKNetworkOperation *op = [engine operationWithPath:c params:nil httpMethod:@"GET"];
        [op onCompletion:^(MKNetworkOperation *operation){
        NSLog(@"request string: %@",[op responseString]);
        NSString* pwdget=[op responseString];
        SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
        NSMutableDictionary *dict = [jsonParser objectWithString:pwdget];
        NSDictionary *Info = [dict objectForKey:@"resoult"];
        NSString* ppwd=[Info objectForKey:@"user_pwd"];
        bool b=[fileMD5 isEqualToString:ppwd];
        if(b){
            _test.text=@"登录成功";
        }else{
            _test.text=@"密码或用户名错误";

        }
   }
             onError:^(NSError *error){  
                  _test.text=@"密码或用户名错误";
             
             }];
  
    
    [engine enqueueOperation:op];
    
    //string to dictionary
   //  NSString *resultStr = @"{\"name\": \"admin\",\"list\": [\"one\",\"two\",\"three\"]}";
    
}

@end
