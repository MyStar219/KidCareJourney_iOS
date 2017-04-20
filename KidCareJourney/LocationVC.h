//
//  LocationVC.h
//  KidCareJourney
//
//  Created by administrator on 3/7/17.
//  Copyright © 2017 Eddie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MainVC.h"
#import "AddDaycareVC.h"

//typedef  enum
//{
//    CENTERCARE_PIN,
//    HOMECARE_PIN,
//    BABYSITTER_PIN,
//    PEDIATRICIAN_PIN
//}PIN_TYPE;

@interface LocationVC : UIViewController<MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

//@property (nonatomic) PIN_TYPE pinType;

@property (weak, nonatomic) IBOutlet UIView *firstView;
@property (weak, nonatomic) IBOutlet UIView *secondView;
@property (weak, nonatomic) IBOutlet MKMapView *locationMapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
//@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (weak, nonatomic) IBOutlet UITextField *searchTField;
@property (weak, nonatomic) IBOutlet UIButton *listBtn;
@property (weak, nonatomic) IBOutlet UIButton *filterBtn;
@property (weak, nonatomic) IBOutlet UIView *filterView;
@property (weak, nonatomic) IBOutlet UIButton *addDaycareBtn;
@property (strong, nonatomic) NSString *messageDetect;
@property (strong, nonatomic) NSString *daycareName;


- (IBAction)onClickedFilterBtn:(id)sender;
- (IBAction)onClickedFilterCenterBtn:(id)sender;
- (IBAction)onClickedFilterHomeBtn:(id)sender;
- (IBAction)onClickedfilterBabyBtn:(id)sender;
- (IBAction)onClickedFilterPediaBtn:(id)sender;
- (IBAction)onClickedListBtn:(id)sender;
- (IBAction)onClickedFilterOnBtn:(id)sender;
- (IBAction)onClickedAddDaycareBtn:(id)sender;




@end
