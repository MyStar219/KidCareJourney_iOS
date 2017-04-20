//
//  SettingVC.h
//  KidCareJourney
//
//  Created by administrator on 3/7/17.
//  Copyright © 2017 Eddie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface SettingVC : UIViewController<MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *settingLbl;
@property (weak, nonatomic) IBOutlet UIImageView *imgView_Password;
@property (weak, nonatomic) IBOutlet UIImageView *imgView_Facebook;
@property (weak, nonatomic) IBOutlet UIImageView *imgView_Twitter;
@property (weak, nonatomic) IBOutlet UIImageView *imgView_Feedback;
@property (weak, nonatomic) IBOutlet UIImageView *imgView_Logout;
@property (weak, nonatomic) IBOutlet UIButton *passwordBtn;
@property (weak, nonatomic) IBOutlet UIButton *facebookBtn;
@property (weak, nonatomic) IBOutlet UIButton *twitterBtn;
@property (weak, nonatomic) IBOutlet UIButton *feedbackBtn;
@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;
@property (strong, nonatomic) NSString *messageDetect;
- (IBAction)onClickedResetBtn:(id)sender;
- (IBAction)onClickedFacebookBtn:(id)sender;
- (IBAction)onClickedTwitterBtn:(id)sender;
- (IBAction)onClickedFeedbackBtn:(id)sender;
- (IBAction)onClickedLogoutBtn:(id)sender;
- (IBAction)onClickedBackBtn:(id)sender;


@end
