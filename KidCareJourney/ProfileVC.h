//
//  ProfileVC.h
//  KidCareJourney
//
//  Created by administrator on 3/7/17.
//  Copyright © 2017 Eddie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingVC.h"
#import "MainVC.h"
#import "CenterDaycare.h"
#import "CountryVC.h"
#import "ProvinceVC.h"
#import "LoginVC.h"

@interface ProfileVC : UIViewController<UITextFieldDelegate>

@property (strong, nonatomic) CenterDaycare *addsignupcenterdaycare;
@property (strong, nonatomic) NSString *categoriesDetect;
@property (strong, nonatomic) NSString *viewControl;
@property (strong, nonatomic) NSString *selectedCountry;
@property (strong, nonatomic) NSString *selectedProvince;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *phoneNumber;
@property (strong, nonatomic) NSString *address1;
@property (strong, nonatomic) NSString *address2;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *confirmPassword;
@property (weak, nonatomic) IBOutlet UIImageView *imgView_Profile;
@property (strong, nonatomic) UIImage *profileImg;
@property (weak, nonatomic) IBOutlet UILabel *firstNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *lastNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *emailLbl;
@property (weak, nonatomic) IBOutlet UILabel *phoneLbl;
@property (weak, nonatomic) IBOutlet UILabel *address1Lbl;
@property (weak, nonatomic) IBOutlet UILabel *address2Lbl;
@property (weak, nonatomic) IBOutlet UILabel *countryLbl;
@property (weak, nonatomic) IBOutlet UILabel *provinceLbl;
@property (weak, nonatomic) IBOutlet UILabel *cityLbl;
@property (weak, nonatomic) IBOutlet UILabel *passwordLbl;
@property (weak, nonatomic) IBOutlet UILabel *confirmPasswordLbl;
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *address1TextField;
@property (weak, nonatomic) IBOutlet UITextField *address2TextField;
@property (weak, nonatomic) IBOutlet UITextField *countryTextField;
@property (weak, nonatomic) IBOutlet UITextField *provinceTextField;
@property (weak, nonatomic) IBOutlet UITextField *cityTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;

@property (weak, nonatomic) IBOutlet UIButton *settingBtn;

- (IBAction)onClickedSettingBtn:(id)sender;
- (IBAction)onClickedBackBtn:(id)sender;
- (IBAction)onClickedSignupBtn:(id)sender;
- (IBAction)onClickedLoginBtn:(id)sender;


@end
