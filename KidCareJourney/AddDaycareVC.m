//
//  AddDaycareVC.m
//  KidCareJourney
//
//  Created by administrator on 3/22/17.
//  Copyright © 2017 Eddie. All rights reserved.
//

#import "AddDaycareVC.h"
#import "MyListingsVC.h"
@interface AddDaycareVC ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property(strong, nonatomic) NSString *categories;
@end

@implementation AddDaycareVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nameTField.delegate=self;
    self.addressTField.delegate=self;
    self.phonenumberTField.delegate=self;
    NSLog(@"Selected location latitude: %@", self.selectedLatitude);
    NSLog(@"Selected location longitude: %@", self.selectedLongitude);
    if([self.category isEqualToString:@"Home Daycares"]) {
        self.addTitleLbl.text=@"Add Home Daycares";
    } else if ([self.category isEqualToString:@"Babysitters"]) {
        self.addTitleLbl.text=@"Add Babysitters";
    } else if([self.category isEqualToString:@"Pediatricians"]) {
        self.addTitleLbl.text=@"Add Pediatricians";
    }
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected)];
    singleTap.numberOfTapsRequired = 1;
    [self.uploadImg setUserInteractionEnabled:YES];
    [self.uploadImg addGestureRecognizer:singleTap];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Move View Up when Keyboard appears
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.3];
    [UIView setAnimationBeginsFromCurrentState:TRUE];
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y -200, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
    
    
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
    self.uploadImg.image=image;
    self.daycareImg=image;
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.3];
    [UIView setAnimationBeginsFromCurrentState:TRUE];
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y +200, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
}

// when you touch screen, keyboard is hidden.
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan) {
        [self.nameTField resignFirstResponder];
        [self.addressTField resignFirstResponder];
        [self.phonenumberTField resignFirstResponder];
    }
}
//Upload Daycare Image to Web server
-(void) DaycareImageUpload {
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
    strValue = [self.emailDetect stringByReplacingOccurrencesOfString:@"@" withString:@""];
    strValue = [strValue stringByReplacingOccurrencesOfString:@"." withString:@""];
    strValue = [strValue stringByAppendingString:@"-"];
    strValue = [strValue stringByAppendingString:self.categories];
    strValue = [strValue stringByAppendingString:@"-"];
    strValue = [strValue stringByAppendingString:self.nameTField.text];
    strValue = [strValue stringByAppendingString:@".png"];
    strValue = [strValue stringByReplacingOccurrencesOfString:@" " withString:@""];
    strImageName = strValue;
    //image data post preparing
    NSString* dataContent = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userPhoto\"; filename=\"%@\"\r\n", strImageName];
    [body appendData:[dataContent dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *dataImage = UIImageJPEGRepresentation(self.daycareImg,0.2);
    [body appendData:[NSData dataWithData:dataImage]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:body];
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(@"Response : %@",returnString);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onClickedBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onClickedAddBtn:(id)sender {
    
    
    if ([self.nameTField.text length] !=0 && [self.addressTField.text length] !=0) {

        [self.view endEditing:YES];//keyboard dismiss
        //Here YOUR URL
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://kidcarejourney.com/request.php?action=addkidcare&"]];
        
        //create the Method "GET" or "POST"
        [request setHTTPMethod:@"POST"];
        if([self.category isEqualToString:@"Home Daycares"]) {
            self.categories=@"Homedaycare";
        } else if ([self.category isEqualToString:@"Babysitters"]) {
            self.categories=@"Babysitter";
        } else if([self.category isEqualToString:@"Pediatricians"]) {
            self.categories=@"Pediatrician";
        }
        
        //Pass The String to server(YOU SHOULD GIVE YOUR PARAMETERS INSTEAD OF MY PARAMETERS)
        NSString *userUpdate =[NSString stringWithFormat:@"email=%@&categories=%@&name=%@&address=%@&latitude=%@&longitude=%@&phonenumber=%@&rating=%@",self.emailDetect,self.categories,self.nameTField.text,self.addressTField.text,self.selectedLatitude,self.selectedLongitude,self.phonenumberTField.text,@"", nil];
        
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
            //Daycare Image Upload
            [self DaycareImageUpload];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message"
                                                            message:@"Success."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            
        } else
            {
                NSLog(@"faield to connect");
                UIAlertView *erroralert = [[UIAlertView alloc] initWithTitle:@"Faield to connect"
                                                                message:@"Please try again."
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [erroralert show];
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                             message:@"Please the daycare data correctly."
                                                            delegate:self
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
        [alert show];
    }
}
@end
