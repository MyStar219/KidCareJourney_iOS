//
//  AddDaycareVC.h
//  KidCareJourney
//
//  Created by administrator on 3/22/17.
//  Copyright © 2017 Eddie. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AddDaycareVC : UIViewController<UITextFieldDelegate>

@property NSString *selectedLatitude;
@property NSString *selectedLongitude;
@property (strong, nonatomic) NSString *category;
@property (strong, nonatomic) NSString *emailDetect;
@property (weak, nonatomic) IBOutlet UILabel *addTitleLbl;
@property (weak, nonatomic) IBOutlet UIImageView *uploadImg;
@property (strong, nonatomic) UIImage *daycareImg;
@property (weak, nonatomic) IBOutlet UIView *editingView;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *addressLbl;
@property (weak, nonatomic) IBOutlet UILabel *phonenumberLbl;
@property (weak, nonatomic) IBOutlet UITextField *nameTField;
@property (weak, nonatomic) IBOutlet UITextField *addressTField;
@property (weak, nonatomic) IBOutlet UITextField *phonenumberTField;
- (IBAction)onClickedBackBtn:(id)sender;
- (IBAction)onClickedAddBtn:(id)sender;


@end
