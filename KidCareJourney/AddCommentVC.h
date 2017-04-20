//
//  AddCommentVC.h
//  KidCareJourney
//
//  Created by administrator on 4/14/17.
//  Copyright © 2017 Eddie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddCommentVC : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *userNameLbl;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UILabel *ratingLbl;
@property (weak, nonatomic) IBOutlet UITextField *ratingTextField;
@property (weak, nonatomic) IBOutlet UILabel *commentLbl;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (strong, nonatomic) NSString *userEmail;
@property (strong, nonatomic) NSString *addEmail;
@property (strong, nonatomic) NSString *daycareName;

- (IBAction)onClickedBackBtn:(id)sender;
- (IBAction)onClickedSendCommentBtn:(id)sender;


@end
