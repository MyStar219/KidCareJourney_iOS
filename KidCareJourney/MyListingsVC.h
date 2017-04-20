//
//  MyListingsVC.h
//  KidCareJourney
//
//  Created by administrator on 3/21/17.
//  Copyright © 2017 Eddie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationVC.h"
#import "CenterDaycare.h"
#import <CoreLocation/CoreLocation.h>

@interface MyListingsVC : UIViewController<UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate>
@property(nonatomic, strong) NSString *signinDetect;
@property(nonatomic, strong) NSString *emailDetect;
@property (nonatomic, strong) NSString *nameDetect;
@property (nonatomic, strong) NSString *viewControl;
@property (strong, nonatomic) CLLocationManager *locationManager;
- (IBAction)onClickedBackBtn:(id)sender;

@end
