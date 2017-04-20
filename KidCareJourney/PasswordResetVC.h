//
//  PasswordResetVC.h
//  KidCareJourney
//
//  Created by administrator on 3/12/17.
//  Copyright © 2017 Eddie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PasswordResetVC : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *pswResetLbl;
@property (weak, nonatomic) IBOutlet UILabel *emailLbl;
@property (weak, nonatomic) IBOutlet UILabel *oldPswLbl;
@property (weak, nonatomic) IBOutlet UILabel *resetPswLbl;
@property (weak, nonatomic) IBOutlet UITextField *emailTField;
@property (weak, nonatomic) IBOutlet UITextField *oldPswTField;
@property (weak, nonatomic) IBOutlet UITextField *resetPswTField;

- (IBAction)onClickedResetBtn:(id)sender;
- (IBAction)onClickedBackBtn:(id)sender;




@end
