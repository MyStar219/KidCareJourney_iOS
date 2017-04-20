//
//  AddCommentVC.m
//  KidCareJourney
//
//  Created by administrator on 4/14/17.
//  Copyright © 2017 Eddie. All rights reserved.
//

#import "AddCommentVC.h"

@interface AddCommentVC ()<UITextViewDelegate>
@end

@implementation AddCommentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.commentTextView.text = @"Please insert the comment.";
    self.commentTextView.textColor = [UIColor lightGrayColor];
    self.commentTextView.delegate = self;
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
        [self.userNameTextField resignFirstResponder];
        [self.ratingTextField resignFirstResponder];
        [self.commentTextView resignFirstResponder];
    }
}

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    self.commentTextView.text = @"";
    self.commentTextView.textColor = [UIColor blackColor];
    return YES;
}

- (IBAction)onClickedBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onClickedSendCommentBtn:(id)sender {
    int zero =0;
    int five =5;
    if ([self.userNameTextField.text length] !=0 && [self.ratingTextField.text length] !=0 && [self.commentTextView.text length] !=0 && [self.ratingTextField.text doubleValue]<= five && [self.ratingTextField.text doubleValue]>= zero) {
        // display my listings
        [self.view endEditing:YES];//keyboard dismiss
        //Here YOUR URL
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://kidcarejourney.com/request.php?action=addcomments&"]];
    
        //create the Method "GET" or "POST"
        [request setHTTPMethod:@"POST"];
    
        //Pass The String to server(YOU SHOULD GIVE YOUR PARAMETERS INSTEAD OF MY PARAMETERS)
    
        NSString *userUpdate =[NSString stringWithFormat:@"username=%@&useremail=%@&daycarename=%@&addemail=%@&rating=%@&comments=%@",self.userNameTextField.text,self.userEmail,self.daycareName,self.addEmail,self.ratingTextField.text,self.commentTextView.text,nil];
    
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
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                            message:@"You have sent the comments successfully."
                                                        delegate:self
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
            [alert show];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Please try again."
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
@end
