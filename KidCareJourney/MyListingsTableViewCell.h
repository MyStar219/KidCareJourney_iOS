//
//  MyListingsTableViewCell.h
//  KidCareJourney
//
//  Created by administrator on 3/26/17.
//  Copyright © 2017 Eddie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyListingsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *subListingImg;
@property (weak, nonatomic) IBOutlet UILabel *subListingName;
@property (weak, nonatomic) IBOutlet UILabel *subListingAddress;
@property (weak, nonatomic) IBOutlet UILabel *subListingCategory;

@end
