//
//  DaycareTableViewCell.h
//  KidCareJourney
//
//  Created by administrator on 3/19/17.
//  Copyright © 2017 Eddie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DaycareTableViewCell : UITableViewCell
@property (assign, nonatomic) IBOutlet UIImageView *subImg;
@property (assign, nonatomic) IBOutlet UILabel *subNameLbl;
@property (assign, nonatomic) IBOutlet UILabel *addressLbl;

@end
