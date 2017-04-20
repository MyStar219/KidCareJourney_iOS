//
//  AddLocationVC.h
//  KidCareJourney
//
//  Created by administrator on 3/26/17.
//  Copyright © 2017 Eddie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CustomAnnotation.h"
#import "AddDaycareVC.h"
#import "MainVC.h"



@interface AddLocationVC : UIViewController<MKMapViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate>

@property (strong, nonatomic) NSString *category;
@property (strong, nonatomic) NSString *emailDetect;
@property (weak, nonatomic) IBOutlet UILabel *daycareNameLbl;
@property (weak, nonatomic) IBOutlet MKMapView *addMapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) NSString *searchBtnClickedDetect;

- (IBAction)onClickedBackBtn:(id)sender;
- (IBAction)onClickedSearchBtn:(id)sender;

@end
