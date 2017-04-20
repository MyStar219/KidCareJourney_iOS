//
//  MyListingsDetailVC.h
//  KidCareJourney
//
//  Created by administrator on 3/26/17.
//  Copyright © 2017 Eddie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyListings.h"
#import "AddCommentVC.h"
#import "MyListingsVC.h"

@interface MyListingsDetailVC : UIViewController

@property (strong, nonatomic) MyListings *mylistings;
@property (weak, nonatomic) IBOutlet UILabel *mylistingName;
@property (weak, nonatomic) IBOutlet UIImageView *mylistingImg;
@property (weak, nonatomic) IBOutlet UILabel *mylistingCategory;
@property (weak, nonatomic) IBOutlet UILabel *mylistingAddress;
@property (weak, nonatomic) IBOutlet UILabel *mylistingDistance;
@property (weak, nonatomic) IBOutlet UILabel *mylistingPhone;
- (IBAction)onClickedBackBtn:(id)sender;
- (IBAction)onClickedAddCommentBtn:(id)sender;
- (IBAction)onClickedDeleteBtn:(id)sender;


@end
