//
//  NotificationsVC.h
//  KidCareJourney
//
//  Created by administrator on 3/7/17.
//  Copyright © 2017 Eddie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginVC.h"
#import "LocationVC.h"

@interface NotificationsVC : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *notificationTableView;
@property (weak, nonatomic) IBOutlet UILabel *notificationLbl;
@property (strong, nonatomic) NSString *signinDetect;
@property (strong, nonatomic) NSString *emailDetect;
@property (strong, nonatomic) NSString *nameDetect;

- (IBAction)onClickedNotificationBtn:(id)sender;
- (IBAction)onClickedBackBtn:(id)sender;

@end
