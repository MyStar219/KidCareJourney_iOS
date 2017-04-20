//
//  NotificationsTableViewCell.h
//  KidCareJourney
//
//  Created by administrator on 3/31/17.
//  Copyright © 2017 Eddie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *subImg;
@property (weak, nonatomic) IBOutlet UILabel *subCategory;
@property (weak, nonatomic) IBOutlet UILabel *subName;
@property (weak, nonatomic) IBOutlet UILabel *subUserName;
@property (weak, nonatomic) IBOutlet UILabel *subUserEmail;
@property (weak, nonatomic) IBOutlet UILabel *subUserAddress;
@property (weak, nonatomic) IBOutlet UILabel *subUserPhoneNumber;

@end
