//
//  LoginVC.m
//  KidCareJourney
//
//  Created by administrator on 3/8/17.
//  Copyright © 2017 Eddie. All rights reserved.
//

#import "LoginVC.h"

@interface LoginVC ()
@property(weak, nonatomic) NSString *status;
@property(nonatomic, strong) NSArray *jsonArr;
@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.viewControl isEqualToString:@"NotificationsVC"]) {
        self.signupBtn.hidden=YES;
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

// when you touch screen, keyboard is hidden.
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan) {
        [self.emailTField resignFirstResponder];
        [self.pswTField resignFirstResponder];
    }
}

-(void)dismissKeyboard
{
    [self.pswTField resignFirstResponder];
}
- (IBAction)onClickedLoginBtn:(id)sender {
    [self.view endEditing:YES];//keyboard dismiss
    //Here YOUR URL
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://kidcarejourney.com/request.php?action=signin&"]];
    
    //create the Method "GET" or "POST"
    [request setHTTPMethod:@"POST"];
    //Pass The String to server(YOU SHOULD GIVE YOUR PARAMETERS INSTEAD OF MY PARAMETERS)
    NSString *userUpdate =[NSString stringWithFormat:@"email=%@&password=%@",self.emailTField.text,self.pswTField.text,nil];
    
    //Check The Value what we passed
    NSLog(@"The data Details is =%@", userUpdate);
    
    //Convert the String to Data
    NSData *data1 = [userUpdate dataUsingEncoding:NSUTF8StringEncoding];
    
    //Apply the data to the body
    [request setHTTPBody:data1];
    
    //Create the response and Error
    NSError *err;
    NSURLResponse *response;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    
    NSString *resSrtSign = [[NSString alloc]initWithData:responseData encoding:NSASCIIStringEncoding];
    
    //This is for Response
    NSLog(@"got response==%@", resSrtSign);

    if(![resSrtSign isEqualToString:@"no"])
    {
        if ([self.addcenterdaycare.viewControl isEqualToString:@"DaycareDetailVC"]) {
            //Get user data from json file
            NSData *data2= [resSrtSign dataUsingEncoding:NSUTF8StringEncoding];
            id json = [NSJSONSerialization JSONObjectWithData:data2 options:0 error:nil];
            _jsonArr = [json objectForKey:@"results"];
            NSLog(@"jsonArr : %@",self.jsonArr);
            if (self.jsonArr.count>0) {
                jsonNotificationArr = [NSMutableArray new];
                for (NSDictionary *dic in _jsonArr) {
                    Notifications *notifications=[Notifications new];
                    notifications.getfirstname=dic[@"firstname"];
                    notifications.getlastname=dic[@"lastname"];
                    notifications.getname = [NSString stringWithFormat:@"%@%@", notifications.getfirstname, notifications.getlastname];
                    notifications.getemail=dic[@"email"];
                    notifications.getaddress=dic[@"address1"];
                    notifications.getphonenumber=dic[@"phonenumber"];

                    [jsonNotificationArr addObject:notifications];
                }
            }
            NSLog(@"OK");

            [self.view endEditing:YES];//keyboard dismiss
            //Here YOUR URL
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://kidcarejourney.com/request.php?action=addmylisting&"]];
            
            //create the Method "GET" or "POST"
            [request setHTTPMethod:@"POST"];
            //Pass The String to server(YOU SHOULD GIVE YOUR PARAMETERS INSTEAD OF MY PARAMETERS)
            NSString *userUpdate =[NSString stringWithFormat:@"email=%@&daycareemail=%@&categories=%@&name=%@&address=%@&latitude=%@&longitude=%@&phonenumber=%@&rating=%@&imageurl=%@",self.emailTField.text,self.addcenterdaycare.email,self.addcenterdaycare.categories,self.addcenterdaycare.name,self.addcenterdaycare.address,self.addcenterdaycare.daycareLatitude,self.addcenterdaycare.daycareLongitude,self.addcenterdaycare.phone,self.addcenterdaycare.rating,self.addcenterdaycare.imageUrl, nil];
            
            //Check The Value what we passed
            NSLog(@"The data Details is =%@", userUpdate);
            
            //Convert the String to Data
            NSData *data1 = [userUpdate dataUsingEncoding:NSUTF8StringEncoding];
            
            //Apply the data to the body
            [request setHTTPBody:data1];
            
            //Create the response and Error
            NSError *err;
            NSURLResponse *response;
            
            NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
            
            NSString *resSrt = [[NSString alloc]initWithData:responseData encoding:NSASCIIStringEncoding];
            
            //This is for Response
            NSLog(@"got response==%@", resSrt);
            if([resSrt isEqualToString:@"yes"])
            {
                //Notificaiton function
                
                //Here YOUR URL
                NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://kidcarejourney.com/request.php?action=detectnotification&"]];
                
                //create the Method "GET" or "POST"
                [request setHTTPMethod:@"POST"];
                //Pass The String to server(YOU SHOULD GIVE YOUR PARAMETERS INSTEAD OF MY PARAMETERS)
                for (int i=0; i<jsonNotificationArr.count; i++) {
                    Notifications *notifications=[jsonNotificationArr objectAtIndex:i];
                    self.getname = notifications.getname;
                    self.getaddress = notifications.getaddress;
                    self.getemail = notifications.getemail;
                    self.getphonenumber = notifications.getphonenumber;
                }
                NSString *userUpdate =[NSString stringWithFormat:@"getemail=%@&getaddress=%@&getphonenumber=%@&getname=%@&addemail=%@&addcategory=%@&adddaycarename=%@",self.getemail,self.getaddress,self.getphonenumber,self.getname,self.addcenterdaycare.email,self.addcenterdaycare.categories,self.addcenterdaycare.name, nil];

                //Check The Value what we passed
                NSLog(@"The data Details is =%@", userUpdate);
                
                //Convert the String to Data
                NSData *data1 = [userUpdate dataUsingEncoding:NSUTF8StringEncoding];
                
                //Apply the data to the body
                [request setHTTPBody:data1];
                
                //Create the response and Error
                NSError *err;
                NSURLResponse *response;
                
                NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
                
                NSString *resSrt = [[NSString alloc]initWithData:responseData encoding:NSASCIIStringEncoding];
                
                if ([resSrt isEqualToString:@"yes"]) {
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    MyListingsVC *vc =(MyListingsVC *)[storyboard instantiateViewControllerWithIdentifier:View_MyListingsVC];
                    vc.signinDetect=@"SignIn";
                    vc.emailDetect=self.emailTField.text;
                    vc.viewControl = @"LoginVC";
                    [self.navigationController pushViewController:vc animated:YES];
                } else {
                    
                }
            } else {
                NSLog(@"faield to connect");
                UIAlertView *erroralert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:@"Please try again."
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [erroralert show];
            }
        } else if([self.viewControl isEqualToString:@"MyListingsVC"]){
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MyListingsVC *vc =(MyListingsVC *)[storyboard instantiateViewControllerWithIdentifier:View_MyListingsVC];
            vc.signinDetect=@"SignIn";
            vc.emailDetect=self.emailTField.text;
            [self.navigationController pushViewController:vc animated:YES];
            
        } else if ([self.viewControl isEqualToString:@"AddLocationVC"]){
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            AddLocationVC *vc =(AddLocationVC *)[storyboard instantiateViewControllerWithIdentifier:View_AddLocationVC];
            vc.category=self.category;
            vc.emailDetect=self.emailTField.text;
            [self.navigationController pushViewController:vc animated:YES];
        } else if ([self.viewControl isEqualToString:@"SignUp"]){
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            SettingVC *vc =(SettingVC *)[storyboard instantiateViewControllerWithIdentifier:View_SettingVC];
            [self.navigationController pushViewController:vc animated:YES];
        } else if ([self.viewControl isEqualToString:@"NotificationsVC"]){
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            NotificationsVC *vc =(NotificationsVC *)[storyboard instantiateViewControllerWithIdentifier:View_NotificationsVC];
            vc.signinDetect=@"SignIn";
            vc.emailDetect=self.emailTField.text;
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else {
        NSLog(@"faield to connect");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Wrong Email and Password"
                                                        message:@"Please insert your email and password again."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)onClickedSignupBtn:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ProfileVC *vc =(ProfileVC *)[storyboard instantiateViewControllerWithIdentifier:View_ProfileVC];
    if ([self.addcenterdaycare.viewControl isEqualToString:@"DaycareDetailVC"]) {
        vc.viewControl=@"DaycareDetailVC";
        vc.addsignupcenterdaycare=self.addcenterdaycare;
    } else if([self.viewControl isEqualToString:@"MyListingsVC"]) {
        vc.viewControl=@"MyListingsVC";
    } else if ([self.viewControl isEqualToString:@"AddLocationVC"]) {
        vc.categoriesDetect=self.category;
        vc.viewControl=@"AddLocationVC";
    } else {
    }
    [self.navigationController pushViewController:vc animated:YES];
}


- (IBAction)onClickedBackBtn:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MainVC *vc =(MainVC *)[storyboard instantiateViewControllerWithIdentifier:View_MainVC];
    vc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
