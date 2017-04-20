//
//  DaycareDetailVC.h
//  KidCareJourney
//
//  Created by administrator on 3/11/17.
//  Copyright © 2017 Eddie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CenterDaycare.h"
#import "LoginVC.h"

@interface DaycareDetailVC : UIViewController<MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate, CLLocationManagerDelegate>
@property (strong, nonatomic) CenterDaycare *centerdaycare;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *addressDetail;
@property (weak, nonatomic) IBOutlet UILabel *hours;
@property (strong, nonatomic) NSString *province;
@property (weak, nonatomic) IBOutlet UIView *commentView;
@property (weak, nonatomic) IBOutlet UITableView *commentTableView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) NSString *messageDetect;

- (IBAction)onClickedSaveBtn:(id)sender;

- (IBAction)onClickedBackBtn:(id)sender;
- (IBAction)viewMapBtn:(id)sender;
- (IBAction)directionsBtn:(id)sender;
- (IBAction)onClickedShowCommentViewBtn:(id)sender;
- (IBAction)onClickedHideCommentViewBtn:(id)sender;

@end
