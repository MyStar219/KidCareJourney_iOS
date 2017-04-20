//
//  LoginVC.h
//  KidCareJourney
//
//  Created by administrator on 3/8/17.
//  Copyright © 2017 Eddie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileVC.h"
#import "MyListingsVC.h"
#import "CenterDaycare.h"
#import "AddLocationVC.h"
#import "Notifications.h"
#import "NotificationsVC.h"

@interface LoginVC : UIViewController

@property(nonatomic, strong) NSString *viewControl;
@property (nonatomic, strong) NSString *category;
@property (strong, nonatomic) CenterDaycare *addcenterdaycare;
@property (weak, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet UILabel *loginLbl;
@property (weak, nonatomic) IBOutlet UILabel *emailLbl;
@property (weak, nonatomic) IBOutlet UILabel *pswLbl;
@property (weak, nonatomic) IBOutlet UITextField *emailTField;
@property (weak, nonatomic) IBOutlet UITextField *pswTField;

@property (strong, nonatomic) NSString *getemail;
@property (strong, nonatomic) NSString *getaddress;
@property (strong, nonatomic) NSString *getname;
@property (strong, nonatomic) NSString *getphonenumber;
@property (weak, nonatomic) IBOutlet UIButton *signupBtn;

- (IBAction)onClickedLoginBtn:(id)sender;
- (IBAction)onClickedSignupBtn:(id)sender;
- (IBAction)onClickedBackBtn:(id)sender;


@end
