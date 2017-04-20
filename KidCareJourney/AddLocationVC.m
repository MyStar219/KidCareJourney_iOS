//
//  AddLocationVC.m
//  KidCareJourney
//
//  Created by administrator on 3/26/17.
//  Copyright © 2017 Eddie. All rights reserved.
//

#import "AddLocationVC.h"
#import <GooglePlaces/GooglePlaces.h>

@interface AddLocationVC ()<GMSAutocompleteViewControllerDelegate>
@property(strong, nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) CLLocation *searchLocation;
@property (nonatomic, strong) CustomAnnotation      *fixAnnotation;
@property (nonatomic, strong) UIImageView           *annotationImage;
@property CLLocationCoordinate2D tappedCoord;
@property NSString *tappedLatitude;
@property NSString *tappedLongitude;
@end

@implementation AddLocationVC
@synthesize addMapView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.addMapView.delegate=self;
    self.searchTextField.delegate=self;
    self.daycareNameLbl.text=self.category;
        if([CLLocationManager locationServicesEnabled]) {
            if(!self.locationManager) {
                self.locationManager=[[CLLocationManager alloc] init];
            }
            self.locationManager.delegate=self;
            self.locationManager.distanceFilter=kCLDistanceFilterNone;
            self.locationManager.desiredAccuracy=kCLLocationAccuracyBest;
            if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                [_locationManager requestAlwaysAuthorization];//above ios 8.0 locationmanager Authorization
            }
            self.currentLocation=[[CLLocation alloc]init];
            [self.locationManager startUpdatingLocation];
        } else {
            NSLog(@"Location services are not enabled");
        }
//    [self.addMapView setShowsUserLocation:YES];
    // Fix annotation
    _fixAnnotation = [[CustomAnnotation alloc] initWithTitle:@"Annotation" subTitle:@"Select Location" detailURL:nil location:self.addMapView.userLocation.coordinate];
    [self.addMapView addAnnotation:self.fixAnnotation];
    
    // Annotation image.
    CGFloat width = 64;
    CGFloat height = 64;
    CGFloat margiX = self.addMapView.center.x-(width/2);
    CGFloat margiY = (self.addMapView.center.y+(height/2))/2;
    NSLog(@"margix : %f", margiX);
    NSLog(@"margiy : %f", margiY);
    // 32 is half size for navigationbar and status bar height to set exact location for image.
    
    _annotationImage = [[UIImageView alloc] initWithFrame:CGRectMake(margiX, margiY, width, height)];
    [self.annotationImage setImage:[UIImage imageNamed:@"mapannotation.png"]];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    self.addMapView.pitchEnabled = YES;
//    [self.addMapView setShowsBuildings:YES];
    [self mapView:self.addMapView regionDidChangeAnimated:YES];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark MKMApViewdelegate

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
    NSLog(@"Region will changed...");
    [self.addMapView removeAnnotation:self.fixAnnotation];
    [self.addMapView addSubview:self.annotationImage];
    
}


- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    NSLog(@"Region did changed...");
    [self.annotationImage removeFromSuperview];
    CLLocationCoordinate2D center = [mapView centerCoordinate];
    self.fixAnnotation.coordinate = center;
    [self.addMapView addAnnotation:self.fixAnnotation];
}

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    if ([annotation isKindOfClass:[CustomAnnotation class]]) {
        CustomAnnotation *customAnnotation = (CustomAnnotation *) annotation;
        
        MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomAnnotation"];
        
        if (annotationView == nil)
            annotationView = customAnnotation.annotationView;
        else
            annotationView.annotation = annotation;
        annotationView.canShowCallout=YES;
        return annotationView;
    } else
        return nil;
}
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    MKPointAnnotation *annotation=(MKPointAnnotation*)view.annotation;
    self.tappedCoord=annotation.coordinate;
    self.tappedLatitude=[NSString stringWithFormat:@"%.7f", self.tappedCoord.latitude];
    self.tappedLongitude=[NSString stringWithFormat:@"%.7f", self.tappedCoord.longitude];
    NSLog(@"Selected location latitude: %@", self.tappedLatitude);
    NSLog(@"Selected location longitude: %@", self.tappedLongitude);
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddDaycareVC *vc=(AddDaycareVC *)[storyboard instantiateViewControllerWithIdentifier:View_AddDaycareVC];
    vc.hidesBottomBarWhenPushed=YES;
    vc.selectedLatitude=self.tappedLatitude;
    vc.selectedLongitude=self.tappedLongitude;
    vc.category=self.category;
    vc.emailDetect=self.emailDetect;
    [self.navigationController pushViewController:vc animated:YES];
    // Use your appropriate segue identifier
}


#pragma mark - Add the didUpdateUserLocation method : MKMApViewdelegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    if ([self.searchBtnClickedDetect isEqualToString:@"Location Search"]) {
        userLocation=(MKUserLocation *)self.currentLocation;
    } else {
    }
    MKCoordinateRegion region=MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    [self.addMapView setRegion:[self.addMapView regionThatFits:region] animated:YES];
    
    // Add an annotation
    MKPointAnnotation *point=[[MKPointAnnotation alloc] init];
    point.coordinate=userLocation.coordinate;

}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation: (CLLocation *)oldLocation {
    if ([self.searchBtnClickedDetect isEqualToString:@"Location Search"]) {
        self.currentLocation=self.searchLocation;
        NSLog(@"Latitude : %f", self.currentLocation.coordinate.latitude);
        NSLog(@"Longitude : %f", self.currentLocation.coordinate.longitude);
    } else {
        self.currentLocation=newLocation;
        NSLog(@"Latitude : %f", self.currentLocation.coordinate.latitude);
        NSLog(@"Longitude : %f", self.currentLocation.coordinate.longitude);
    }
    [manager stopUpdatingLocation];
}
- (IBAction)onClickedCenterBtn:(id)sender {
    [self.addMapView setCenterCoordinate:self.currentLocation.coordinate animated:YES];
}
- (IBAction)onClickedZoomOutBtn:(id)sender {
    MKCoordinateRegion zoomOut = self.addMapView.region;
    zoomOut.span.latitudeDelta *= 2;
    zoomOut.span.longitudeDelta *= 2;
    [self.addMapView setRegion:zoomOut animated:YES];
}
- (IBAction)onClickedZoomInBtn:(id)sender {
    MKCoordinateRegion zoomIn = self.addMapView.region;
    zoomIn.span.latitudeDelta *= 0.5;
    zoomIn.span.longitudeDelta *= 0.5;
    [self.addMapView setRegion:zoomIn animated:YES];
}

- (IBAction)onClickedBackBtn:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MainVC *vc =(MainVC *)[storyboard instantiateViewControllerWithIdentifier:View_MainVC];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onClickedSearchBtn:(id)sender {
    self.searchBtnClickedDetect=@"Location Search";
    [self.locationManager startUpdatingLocation];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    GMSAutocompleteViewController *acController = [[GMSAutocompleteViewController alloc] init];
    acController.delegate = self;
    [self presentViewController:acController animated:YES completion:nil];
    
}
// Handle the user's selection.
- (void)viewController:(GMSAutocompleteViewController *)viewController
didAutocompleteWithPlace:(GMSPlace *)place {
    [self dismissViewControllerAnimated:YES completion:nil];
    // Do something with the selected place.
    NSLog(@"Place name %@", place.name);
    NSLog(@"Place address %@", place.formattedAddress);
    NSLog(@"Place attributions %@", place.attributions.string);
    self.searchTextField.text=place.name;
    self.searchLocation=[[CLLocation alloc] initWithLatitude:place.coordinate.latitude longitude:place.coordinate.longitude];
    NSLog(@"Search Location :%f", self.searchLocation.coordinate.latitude);
    NSLog(@"Search Location :%f", self.searchLocation.coordinate.longitude);
}

- (void)viewController:(GMSAutocompleteViewController *)viewController
didFailAutocompleteWithError:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
    // TODO: handle the error.
    NSLog(@"Error: %@", [error description]);
}

// User canceled the operation.
- (void)wasCancelled:(GMSAutocompleteViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Turn the network activity indicator on and off again.
- (void)didRequestAutocompletePredictions:(GMSAutocompleteViewController *)viewController {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)didUpdateAutocompletePredictions:(GMSAutocompleteViewController *)viewController {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}
@end
