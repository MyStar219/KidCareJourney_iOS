//
//  ProvinceVC.h
//  KidCareJourney
//
//  Created by administrator on 3/29/17.
//  Copyright © 2017 Eddie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CenterDaycare.h"

@interface ProvinceVC : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSString *selectedCountry;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *phoneNumber;
@property (strong, nonatomic) NSString *address1;
@property (strong, nonatomic) NSString *address2;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *confirmPassword;
@property (strong, nonatomic) NSString *viewControl;
@property (strong, nonatomic) CenterDaycare *addsignupcenterdaycare;
@property (strong, nonatomic) NSString *categoriesDetect;
@property (strong, nonatomic) UIImage *profileImg;
@end
