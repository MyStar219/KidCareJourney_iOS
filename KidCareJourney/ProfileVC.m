//
//  ProfileVC.m
//  KidCareJourney
//
//  Created by administrator on 3/7/17.
//  Copyright © 2017 Eddie. All rights reserved.
//

#import "ProfileVC.h"
#import "MyListingsVC.h"
#import "AddLocationVC.h"
#import "ProvinceVC.h"

@interface ProfileVC ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) NSString *signupDetect;
@property(nonatomic, strong) NSString *getname;

@end

@implementation ProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.countryTextField.delegate=self;
    self.provinceTextField.delegate=self;
    self.cityTextField.delegate=self;
    self.passwordTextField.delegate=self;
    self.confirmPasswordTextField.delegate=self;
    self.firstNameTextField.text=self.firstName;
    self.lastNameTextField.text=self.lastName;
    self.emailTextField.text=self.email;
    self.phoneNumberTextField.text=self.phoneNumber;
    self.address1TextField.text=self.address1;
    self.address2TextField.text=self.address2;
    self.countryTextField.text=self.selectedCountry;
    self.provinceTextField.text=self.selectedProvince;
    self.cityTextField.text=self.city;
    self.passwordTextField.text=self.password;
    self.confirmPasswordTextField.text=self.confirmPassword;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected)];
    singleTap.numberOfTapsRequired = 1;
    [self.imgView_Profile setUserInteractionEnabled:YES];
    [self.imgView_Profile addGestureRecognizer:singleTap];

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


//Move View Up when Keyboard appears
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag == 0) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:.3];
        [UIView setAnimationBeginsFromCurrentState:TRUE];
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y -200, self.view.frame.size.width, self.view.frame.size.height);
    
        [UIView commitAnimations];
    } else if (textField.tag == 1) {
        [self showCountryVC];
    } else if (textField.tag == 2) {
        if ([self.countryTextField.text isEqualToString:@""]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Please select your country at first."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        } else {
            [self showProvinceVC];
        }
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.3];
    [UIView setAnimationBeginsFromCurrentState:TRUE];
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y +200, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
}
// Show CountryVC
-(void) showCountryVC {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CountryVC *vc =(CountryVC *)[storyboard instantiateViewControllerWithIdentifier:View_CountryVC];
    vc.firstName=self.firstNameTextField.text;
    vc.lastName=self.lastNameTextField.text;
    vc.email=self.emailTextField.text;
    vc.phoneNumber=self.phoneNumberTextField.text;
    vc.address1=self.address1TextField.text;
    vc.address2=self.address2TextField.text;
    vc.city=self.cityTextField.text;
    vc.password=self.passwordTextField.text;
    vc.confirmPassword=self.confirmPasswordTextField.text;
    vc.viewControl=self.viewControl;
    vc.addsignupcenterdaycare=self.addsignupcenterdaycare;
    vc.categoriesDetect=self.categoriesDetect;
    vc.profileImg=self.profileImg;
    vc.hidesBottomBarWhenPushed =YES;
    [self.navigationController pushViewController:vc animated:YES];
}
// Show ProvinceVC
-(void) showProvinceVC {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ProvinceVC *vc =(ProvinceVC *)[storyboard instantiateViewControllerWithIdentifier:View_ProvinceVC];
    vc.firstName=self.firstNameTextField.text;
    vc.lastName=self.lastNameTextField.text;
    vc.email=self.emailTextField.text;
    vc.phoneNumber=self.phoneNumberTextField.text;
    vc.address1=self.address1TextField.text;
    vc.address2=self.address2TextField.text;
    vc.selectedCountry=self.selectedCountry;
    vc.city=self.cityTextField.text;
    vc.password=self.passwordTextField.text;
    vc.confirmPassword=self.confirmPasswordTextField.text;
    vc.viewControl=self.viewControl;
    vc.addsignupcenterdaycare=self.addsignupcenterdaycare;
    vc.categoriesDetect=self.categoriesDetect;
    vc.profileImg=self.profileImg;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

// when you touch screen, keyboard is hidden.
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan) {
        [self.firstNameTextField resignFirstResponder];
        [self.lastNameTextField resignFirstResponder];
        [self.emailTextField resignFirstResponder];
        [self.phoneNumberTextField resignFirstResponder];
        [self.address1TextField resignFirstResponder];
        [self.address2TextField resignFirstResponder];
        [self.countryTextField resignFirstResponder];
        [self.provinceTextField resignFirstResponder];
        [self.cityTextField resignFirstResponder];
        [self.passwordTextField resignFirstResponder];
        [self.confirmPasswordTextField resignFirstResponder];
    }
}
-(void)tapDetected{
    NSLog(@"single Tap on imageview");
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}
// This method is called when an image has been chosen from the library or taken from the camera.
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    self.imgView_Profile.image=image;
    self.profileImg=image;
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)onClickedSettingBtn:(id)sender {
    if ([self.signupDetect isEqualToString:@"yes"]) {
        UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SettingVC *vc=(SettingVC *)[storyboard instantiateViewControllerWithIdentifier:View_SettingVC];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        NSLog(@"got response");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                        message:@"Please Login at first."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }

}

- (IBAction)onClickedBackBtn:(id)sender {
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MainVC *vc=(MainVC *)[storyboard instantiateViewControllerWithIdentifier:View_MainVC];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onClickedSignupBtn:(id)sender {
    if ([self.firstNameTextField.text length] !=0 && [self.lastNameTextField.text length] !=0 && [self.emailTextField.text length] !=0 && [self.phoneNumberTextField.text length] !=0 && [self.address1TextField.text length] !=0 && [self.countryTextField.text length] !=0 && [self.provinceTextField.text length] !=0 && [self.cityTextField.text length] !=0 && [self.passwordTextField.text length] !=0 && [self.confirmPasswordTextField.text length] != 0) {
        if ([self.passwordTextField.text isEqualToString:self.confirmPasswordTextField.text]) {
    
            [self.view endEditing:YES];//keyboard dismiss
        
            //Here YOUR URL
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://kidcarejourney.com/request.php?action=signup&"]];
        
            //create the Method "GET" or "POST"
            [request setHTTPMethod:@"POST"];
            //Pass The String to server(YOU SHOULD GIVE YOUR PARAMETERS INSTEAD OF MY PARAMETERS)
            NSString *userUpdate =[NSString stringWithFormat:@"firstname=%@&lastname=%@&email=%@&phonenumber=%@&address1=%@&address2=%@&country=%@&province=%@&city=%@&password=%@",self.firstNameTextField.text,self.lastNameTextField.text,self.emailTextField.text,self.phoneNumberTextField.text,self.address1TextField.text,self.address2TextField.text,self.countryTextField.text,self.provinceTextField.text,self.cityTextField.text,self.passwordTextField.text,nil];
        
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
                // upload image to web server
                [self UserImageUpload];
            
                if ([self.viewControl isEqualToString:@"DaycareDetailVC"]) {
                
                    [self AddMyListings];

                    if([resSrt isEqualToString:@"yes"]) {
                        //Notificaiton function
                        if (![self.addsignupcenterdaycare.categories isEqualToString:@"CenterDaycare"]) {
                        
                            [self AddNotification];
                        
                            if([resSrt isEqualToString:@"yes"]) {
                                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                MyListingsVC *vc =(MyListingsVC *)[storyboard instantiateViewControllerWithIdentifier:View_MyListingsVC];
                                vc.signinDetect=@"SignIn";
                                vc.emailDetect=self.emailTextField.text;
                                vc.viewControl = @"LoginVC";
                                NSLog(@"email : %@", vc.emailDetect);
                                [self.navigationController pushViewController:vc animated:YES];
                            }
                        } else {
                            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                            MyListingsVC *vc =(MyListingsVC *)[storyboard instantiateViewControllerWithIdentifier:View_MyListingsVC];
                            vc.signinDetect=@"SignIn";
                            vc.emailDetect=self.emailTextField.text;
                            vc.viewControl = @"LoginVC";
                            NSLog(@"email : %@", vc.emailDetect);
                            [self.navigationController pushViewController:vc animated:YES];
                        }
                    } else {
                        NSLog(@"faield to connect");
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Wrong"
                                                                    message:@"Please try again."
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                        [alert show];
                    }
            
                }else if([self.viewControl isEqualToString:@"MyListingsVC"]){
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    MyListingsVC *vc =(MyListingsVC *)[storyboard instantiateViewControllerWithIdentifier:View_MyListingsVC];
                    vc.signinDetect=@"SignIn";
                    vc.emailDetect=self.emailTextField.text;
                    [self.navigationController pushViewController:vc animated:YES];
            
                } else if ([self.viewControl isEqualToString:@"AddLocationVC"]){
            
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    AddLocationVC *vc =(AddLocationVC *)[storyboard instantiateViewControllerWithIdentifier:View_AddLocationVC];
                    vc.category=self.categoriesDetect;
                    vc.emailDetect=self.emailTextField.text;
                    [self.navigationController pushViewController:vc animated:YES];
                } else {
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    SettingVC *vc =(SettingVC *)[storyboard instantiateViewControllerWithIdentifier:View_SettingVC];
                    vc.hidesBottomBarWhenPushed=YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
        
            } else {
                NSLog(@"faield to connect");
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Faield to connect"
                                                            message:@"Please try again."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
                [alert show];
            }
        } else {
            NSLog(@"Don't Correct Password");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Your password doesn't confirm. Please insert confirm password again."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Please your profile data correctly."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
}

//Upload Profile Image to Web server
-(void) UserImageUpload {
    //Here YOUR URL
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://kidcarejourney.com/request.php?action=uploadimage&"]];
    
    //create the Method "GET" or "POST"
    [request setHTTPMethod:@"POST"];
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *strImageName;
    NSString *strValue=@"";
    strValue = [self.emailTextField.text stringByReplacingOccurrencesOfString:@"@" withString:@""];
    strValue = [strValue stringByReplacingOccurrencesOfString:@"." withString:@""];
    strValue = [strValue stringByAppendingString:@".png"];
    strImageName=strValue;
    //image data post preparing
    NSString* dataContent = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userPhoto\"; filename=\"%@\"\r\n", strImageName];
    [body appendData:[dataContent dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *dataImage = UIImageJPEGRepresentation(self.profileImg,0.2);
    [body appendData:[NSData dataWithData:dataImage]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:body];
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(@"Response : %@",returnString);
}

// Add Notification Function Web server
-(void) AddNotification {
    //Here YOUR URL
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://kidcarejourney.com/request.php?action=detectnotification&"]];
    
    //create the Method "GET" or "POST"
    [request setHTTPMethod:@"POST"];
    self.getname=[NSString stringWithFormat:@"%@%@", self.firstNameTextField.text, self.lastNameTextField.text];
    //Pass The String to server(YOU SHOULD GIVE YOUR PARAMETERS INSTEAD OF MY PARAMETERS)
    NSString *userUpdate =[NSString stringWithFormat:@"getemail=%@&getaddress=%@&getphonenumber=%@&getname=%@&addemail=%@&addcategory=%@&adddaycarename=%@",self.emailTextField.text,self.address1TextField.text,self.phoneNumberTextField.text,self.getname,self.addsignupcenterdaycare.email,self.addsignupcenterdaycare.categories,self.addsignupcenterdaycare.name, nil];
    
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
    NSLog(@"Response : %@",resSrt);
}

// Add Mylistings to Web server
-(void) AddMyListings {
    //Here YOUR URL
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://kidcarejourney.com/request.php?action=addmylisting&"]];
    
    //create the Method "GET" or "POST"
    [request setHTTPMethod:@"POST"];
    //Pass The String to server(YOU SHOULD GIVE YOUR PARAMETERS INSTEAD OF MY PARAMETERS)
    NSString *userUpdate =[NSString stringWithFormat:@"email=%@&daycareemail=%@&categories=%@&name=%@&address=%@&latitude=%@&longitude=%@&phonenumber=%@&rating=%@&imageurl=%@",self.emailTextField.text,self.addsignupcenterdaycare.email,self.addsignupcenterdaycare.categories,self.addsignupcenterdaycare.name,self.addsignupcenterdaycare.address,self.addsignupcenterdaycare.daycareLatitude,self.addsignupcenterdaycare.daycareLongitude,self.addsignupcenterdaycare.phone,self.addsignupcenterdaycare.rating,self.addsignupcenterdaycare.imageUrl, nil];
    
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
}
- (IBAction)onClickedLoginBtn:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginVC *vc =(LoginVC *)[storyboard instantiateViewControllerWithIdentifier:View_LoginVC];
    vc.viewControl=@"SignUp";
    vc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
