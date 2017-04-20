//
//  PasswordResetVC.m
//  KidCareJourney
//
//  Created by administrator on 3/12/17.
//  Copyright © 2017 Eddie. All rights reserved.
//

#import "PasswordResetVC.h"

@interface PasswordResetVC ()

@end

@implementation PasswordResetVC

- (void)viewDidLoad {
    [super viewDidLoad];
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
        [self.oldPswTField resignFirstResponder];
        [self.resetPswTField resignFirstResponder];
    }
}
- (IBAction)onClickedResetBtn:(id)sender {
    if ([self.emailTField.text length] !=0 && [self.oldPswTField.text length]!=0 && [self.resetPswTField.text length]!=0) {
        [self.view endEditing:YES];//keyboard dismiss
        //Here YOUR URL
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://kidcarejourney.com/request.php?action=passwordreset&"]];
        
        //create the Method "GET" or "POST"
        [request setHTTPMethod:@"POST"];
        //Pass The String to server(YOU SHOULD GIVE YOUR PARAMETERS INSTEAD OF MY PARAMETERS)
        NSString *userUpdate =[NSString stringWithFormat:@"email=%@&oldpassword=%@&newpassword=%@",self.emailTField.text,self.oldPswTField.text,self.resetPswTField.text, nil];
        
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
        if ([resSrt isEqualToString:@"yes"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                            message:@"Your password have been reseted."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Please email and password again."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Please email and password correctly."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
}

- (IBAction)onClickedBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
