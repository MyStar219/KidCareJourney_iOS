//
//  LocationVC.m
//  KidCareJourney
//
//  Created by administrator on 3/7/17.
//  Copyright © 2017 Eddie. All rights reserved.
//

#import "LocationVC.h"
#import "CenterDaycare.h"
#import "DaycareTableViewCell.h"
#import "DaycareDetailVC.h"
#import <GooglePlaces/GooglePlaces.h>

@interface LocationVC ()<MFMailComposeViewControllerDelegate, CLLocationManagerDelegate, GMSAutocompleteViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) CLLocation *searchLocation;
@property (strong, nonatomic) NSString *province;
@property (nonatomic, strong) NSArray *jsonArr;


@end

@implementation LocationVC
@synthesize locationMapView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.locationMapView.delegate=self;
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.searchTField.delegate=self;
//    self.tabBarController.delegate = self;
    self.tabBarController.selectedIndex=0;
    [self.filterView setHidden:YES];
    [self.addDaycareBtn setHidden:YES];
    
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
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showAlert:(NSString *)sMessage{
    NSLog(@"Message : %@", sMessage);
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
    self.searchTField.text=place.name;
    self.province=place.formattedAddress;
    self.searchLocation=[[CLLocation alloc] initWithLatitude:place.coordinate.latitude longitude:place.coordinate.longitude];
    self.currentLocation=self.searchLocation;
    if ([self.filterBtn.titleLabel.text isEqualToString:@"Filter: On"]) {
        [self.locationMapView removeAnnotations:self.locationMapView.annotations];
        [self dummyMethod];
    } else if ([self.filterBtn.titleLabel.text isEqualToString:@"CenterDaycare"]) {
        [self.locationMapView removeAnnotations:self.locationMapView.annotations];
        [self CenterDaycare];
    } else if ([self.filterBtn.titleLabel.text isEqualToString:@"HomeDaycare"]) {
        [self.locationMapView removeAnnotations:self.locationMapView.annotations];
        [self HomeDaycareAPI];
    } else if ([self.filterBtn.titleLabel.text isEqualToString:@"Babysitter"]) {
        [self.locationMapView removeAnnotations:self.locationMapView.annotations];
        [self BabysitterAPI];
    } else if ([self.filterBtn.titleLabel.text isEqualToString:@"Pediatrician"]) {
        [self.locationMapView removeAnnotations:self.locationMapView.annotations];
        [self PediatricianAPI];
    }
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

- (IBAction)onClickedListBtn:(id)sender {
    NSLog(@"%@", self.listBtn.titleLabel.text);
    if ([self.listBtn.titleLabel.text isEqualToString:@"List"]) {
        [self.listBtn setTitle:@"Map" forState:UIControlStateNormal]; // To set the title
        [self.listBtn setEnabled:YES];
        NSLog(@"%@", self.listBtn.titleLabel.text);
        [self.firstView setHidden:YES];
        [self.secondView setHidden:NO];
        
    } else {
        [self.listBtn setTitle:@"List" forState:UIControlStateNormal]; // To set the title
        [self.listBtn setEnabled:YES];
        [self.firstView setHidden:NO];
        [self.secondView setHidden:YES];
    }
}
- (IBAction)onClickedFilterBtn:(id)sender {
    [self.filterView setHidden:NO];
}

- (IBAction)onClickedFilterOnBtn:(id)sender {
    [self.filterView setHidden:YES];
    [self.filterBtn setTitle:@"Filter: On" forState:UIControlStateNormal];
    [self.locationMapView removeAnnotations:self.locationMapView.annotations];
    [self dummyMethod];
}

- (IBAction)onClickedAddDaycareBtn:(id)sender {
    // Send message to email from iPhone
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        mail.mailComposeDelegate = self;
        [mail setSubject:@"Sample Subject"];
        [mail setMessageBody:@"Here is some main text in the email!" isHTML:NO];
        [mail setToRecipients:@[@"support@kidcarejourney.com"]];
        
        [self presentViewController:mail animated:YES completion:NULL];
    }
    else
    {
        NSLog(@"This device cannot send email");
    }
}

- (IBAction)onClickedFilterCenterBtn:(id)sender {
    [self.filterView setHidden:YES];
    [self.filterBtn setTitle:@"CenterDaycare" forState:UIControlStateNormal];
    [self.locationMapView removeAnnotations:self.locationMapView.annotations];
    [self CenterDaycare];
    
}

- (IBAction)onClickedFilterHomeBtn:(id)sender {
    [self.filterView setHidden:YES];
    [self.addDaycareBtn setHidden:NO];
    [self.filterBtn setTitle:@"HomeDaycare" forState:UIControlStateNormal];
    self.daycareName=@"Home Daycares";
    [self.locationMapView removeAnnotations:self.locationMapView.annotations];
    [self HomeDaycareAPI];
}

- (IBAction)onClickedfilterBabyBtn:(id)sender {
    [self.filterView setHidden:YES];
    [self.addDaycareBtn setHidden:NO];
    [self.filterBtn setTitle:@"Babysitter" forState:UIControlStateNormal];
    self.daycareName=@"Babysitters";
    [self.locationMapView removeAnnotations:self.locationMapView.annotations];
    [self BabysitterAPI];
}

- (IBAction)onClickedFilterPediaBtn:(id)sender {
    [self.filterView setHidden:YES];
    [self.addDaycareBtn setHidden:NO];
    [self.filterBtn setTitle:@"Pediatrician" forState:UIControlStateNormal];
    self.daycareName=@"Pediatrician";
    [self.locationMapView removeAnnotations:self.locationMapView.annotations];
    [self PediatricianAPI];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultSent:
            NSLog(@"You sent the email.");
            self.messageDetect=@"You sent the email.";
            break;
        case MFMailComposeResultSaved:
            NSLog(@"You saved a draft of this email");
            break;
        case MFMailComposeResultCancelled:
            NSLog(@"You cancelled sending this email.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed:  An error occurred when trying to compose this email");
            break;
        default:
            NSLog(@"An error occurred when trying to compose this email");
            break;
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
    if ([self.messageDetect isEqualToString:@"You sent the email."]) {
        UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginVC *vc=(LoginVC *)[storyboard instantiateViewControllerWithIdentifier:View_LoginVC];
        vc.hidesBottomBarWhenPushed=YES;
        vc.viewControl=@"AddLocationVC";
        vc.category=self.daycareName;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        UIAlertView *erroralert = [[UIAlertView alloc] initWithTitle:@"Mail failed"
                                                             message:@"Please try again."
                                                            delegate:self
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
        [erroralert show];
    }
}
#pragma mark - API call part
// obtain daycare center data Yelp API (Center Daycare) and home daycare, pediatricians, babysitters
- (void)dummyMethod{
//    [SVProgressHUD showWithStatus:@"Searching..."];

    @autoreleasepool {
        NSString *term = @"Daycare Center";
//        NSString *location = self.location;
        NSString *location = [NSString stringWithFormat:@"%f,%f", _currentLocation.coordinate.latitude, _currentLocation.coordinate.longitude];
        NSLog(@"location :%@", location);
        YPAPISample *APISample = [[YPAPISample alloc] init];
        
        dispatch_group_t requestGroup = dispatch_group_create();
        
        dispatch_group_enter(requestGroup);
        
        [APISample queryTopBusinessInfoForTerm:term location:location completionHandler:^(NSArray *nearByRestaurantsJSON, NSError *error) {
            
            if (error) {
                [SVProgressHUD dismiss];
                [self showAlert:[NSString stringWithFormat:@"An error happened during the request: %@", error]];
            } else if (nearByRestaurantsJSON.count > 0) {
                [self showAlert:@"success"];
                
                NSMutableArray *annotationArr = [NSMutableArray new];
                centerDaycareArr=[NSMutableArray new];
                // Parsing json data on map view
                NSMutableArray *annotationAPIArr = [NSMutableArray new];
                daycareAPIArr=[NSMutableArray new];
                for (NSDictionary  *dic in nearByRestaurantsJSON)
                {
                    CenterDaycare *centerdaycare = [CenterDaycare new];
                    CustomAnnotation *annotation = [CustomAnnotation new];
                    CLLocationCoordinate2D coordinate;
                    coordinate.latitude = [[[dic[@"location"] objectForKey:@"coordinate"] objectForKey:@"latitude"] doubleValue];
                    coordinate.longitude =  [[[dic[@"location"] objectForKey:@"coordinate"] objectForKey:@"longitude"] doubleValue];
                    centerdaycare.viewMapLatitude=coordinate.latitude;
                    centerdaycare.viewMapLongitude=coordinate.longitude;
                    centerdaycare.categories=@"CenterDaycare";
                    centerdaycare.name=dic[@"name"];
                    centerdaycare.daycareLatitude=@(coordinate.latitude);
                    centerdaycare.daycareLongitude=@(coordinate.longitude);
                    NSArray *arr = [dic[@"location"] objectForKey:@"address"];
                    if (arr.count > 0)
                        centerdaycare.address=[arr objectAtIndex:0];
                    centerdaycare.imageUrl=dic[@"image_url"];
                    if (centerdaycare.imageUrl==nil) {
                        centerdaycare.imageUrl=dic[@"snippet_image_url"];
                    }
                    centerdaycare.phone=dic[@"phone"];
                    if (centerdaycare.phone==nil) {
                        centerdaycare.phone=@"";
                    }
                    centerdaycare.rating=dic[@"rating"];
                    if (centerdaycare.rating==nil) {
                        centerdaycare.rating=0;
                    }
                    [daycareAPIArr addObject:centerdaycare];
                    annotation.coordinate = coordinate;
                    annotation.detectName = @"CenterDaycare";
                    annotation.title = centerdaycare.name;
                    annotation.subtitle =centerdaycare.address;
                    [annotationAPIArr addObject:annotation];
                }
                //Here YOUR URL
                NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://kidcarejourney.com/request.php?action=getkidcare&"]];
                
                //create the Method "GET" or "POST"
                [request setHTTPMethod:@"POST"];
                //Pass The String to server(YOU SHOULD GIVE YOUR PARAMETERS INSTEAD OF MY PARAMETERS)
                NSString *userUpdate =[NSString stringWithFormat:@"categories=%@",@"All",nil];
                
                //Check The Value what we passed
                NSLog(@"The data Details is =%@", userUpdate);
                
                //Convert the String to Data
                NSData *data1 = [userUpdate dataUsingEncoding:NSUTF8StringEncoding];
                
                //Apply the data to the body
                [request setHTTPBody:data1];
                
                //Create the response and Error
                NSError *err;
                NSURLResponse *response;
                
                NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
                
                NSString *resSrt = [[NSString alloc]initWithData:responseData encoding:NSASCIIStringEncoding];
                
                //This is for Response
                NSLog(@"got response==%@", resSrt);
                NSData *data2= [resSrt dataUsingEncoding:NSUTF8StringEncoding];
                id json = [NSJSONSerialization JSONObjectWithData:data2 options:0 error:nil];
                _jsonArr = [json objectForKey:@"results"];
                NSLog(@"jsonArr : %@",self.jsonArr);
                if (_jsonArr.count > 0) {
                    NSMutableArray *annotationBACKENDArr = [NSMutableArray new];
                    daycareBACKENDArr=[NSMutableArray new];
                    for (NSDictionary *dic in _jsonArr)
                    {
                        CenterDaycare *centerdaycare = [CenterDaycare new];
                        CustomAnnotation *annotation = [CustomAnnotation new];
                        CLLocationCoordinate2D coordinate;
                        coordinate.latitude = [dic[@"latitude"] doubleValue];
                        coordinate.longitude= [dic[@"longitude"] doubleValue];
                        
                        // Calculate distance between two point
                        CLLocation *daycareLocation = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
                        CLLocationDistance distance = [_currentLocation distanceFromLocation:daycareLocation];
                        NSLog(@"Distance : %f", distance);
                        if (distance < 40000) {
                            centerdaycare.viewMapLatitude=coordinate.latitude;
                            centerdaycare.viewMapLongitude=coordinate.longitude;
                            centerdaycare.categories=dic[@"categories"];
                            centerdaycare.name=dic[@"name"];
                            centerdaycare.daycareLatitude=@(coordinate.latitude);
                            centerdaycare.daycareLongitude=@(coordinate.longitude);
                            centerdaycare.address=dic[@"address"];
                            centerdaycare.email=dic[@"email"];
                            centerdaycare.phone=dic[@"phonenumber"];
                            centerdaycare.rating=dic[@"rating"];
                            //Get Daycare Image url
                            NSString *strImageName;
                            NSString *strValue=@"";
                            strValue = [centerdaycare.email stringByReplacingOccurrencesOfString:@"@" withString:@""];
                            strValue = [strValue stringByReplacingOccurrencesOfString:@"." withString:@""];
                            strValue = [strValue stringByAppendingString:@"-"];
                            strValue = [strValue stringByAppendingString:centerdaycare.categories];
                            strValue = [strValue stringByAppendingString:@"-"];
                            strValue = [strValue stringByAppendingString:centerdaycare.name];
                            strValue = [strValue stringByAppendingString:@".png"];
                            strValue = [strValue stringByReplacingOccurrencesOfString:@" " withString:@""];
                            strImageName = strValue;
                            centerdaycare.imageUrl=[NSString stringWithFormat:@"http://kidcarejourney.com/image/%@", strImageName];
                            [daycareBACKENDArr addObject:centerdaycare];
                            annotation.coordinate = coordinate;
                            if ([centerdaycare.categories isEqualToString:@"Homedaycare"]) {
                                annotation.detectName = @"Homedaycare";
                            } else if ([centerdaycare.categories isEqualToString:@"Babysitter"]){
                                annotation.detectName = @"Babysitter";
                            } else if ([centerdaycare.categories isEqualToString:@"Pediatrician"]) {
                                annotation.detectName = @"Pediatrician";
                            }
                            annotation.title = centerdaycare.name;
                            annotation.subtitle =centerdaycare.address;
                            [annotationBACKENDArr addObject:annotation];
                        }
                        
                    }
                    centerDaycareArr = [NSMutableArray arrayWithArray:daycareAPIArr];
                    [centerDaycareArr addObjectsFromArray: daycareBACKENDArr];
                    annotationArr = [NSMutableArray arrayWithArray:annotationAPIArr];
                    [annotationArr addObjectsFromArray: annotationBACKENDArr];
//                    NSMutableArray *pins = [[NSMutableArray alloc] initWithArray:[self.locationMapView annotations]];
//                    [self.locationMapView removeAnnotations:pins];
                    [self.locationMapView showAnnotations:annotationArr animated:YES];
                    
                    [_tableView reloadData];
                } else {
                    centerDaycareArr = [NSMutableArray arrayWithArray:daycareAPIArr];
                    annotationArr = [NSMutableArray arrayWithArray:annotationAPIArr];
//                    NSMutableArray *pins = [[NSMutableArray alloc] initWithArray:[self.locationMapView annotations]];
//                    [self.locationMapView removeAnnotations:pins];
                    [self.locationMapView showAnnotations:annotationArr animated:YES];
                    
                    [_tableView reloadData];
                }
            } else {
                [SVProgressHUD dismiss];
                [self showAlert:@"No Center Daycare was found"];
            }
            
            dispatch_group_leave(requestGroup);
        }];
        
//        dispatch_group_wait(requestGroup, DISPATCH_TIME_FOREVER); // This avoids the program exiting before all our asynchronous callbacks have been made.
    }
}

//Parsing Centerdaycare from yelp api
- (void)CenterDaycare{
    //    [SVProgressHUD showWithStatus:@"Searching..."];
    
    @autoreleasepool {
        NSString *term = @"Daycare Center";
        //        NSString *location = self.location;
        NSString *location = [NSString stringWithFormat:@"%f,%f", _currentLocation.coordinate.latitude, _currentLocation.coordinate.longitude];
        NSLog(@"location :%@", location);
        YPAPISample *APISample = [[YPAPISample alloc] init];
        
        dispatch_group_t requestGroup = dispatch_group_create();
        
        dispatch_group_enter(requestGroup);
        
        [APISample queryTopBusinessInfoForTerm:term location:location completionHandler:^(NSArray *nearByRestaurantsJSON, NSError *error) {
            
            if (error) {
                [SVProgressHUD dismiss];
                [self showAlert:[NSString stringWithFormat:@"An error happened during the request: %@", error]];
            } else if (nearByRestaurantsJSON.count > 0) {
                [self showAlert:@"success"];
                
                
                // Parsing json data on map view
                NSMutableArray *annotationArr = [NSMutableArray new];
                centerDaycareArr=[NSMutableArray new];
                for (NSDictionary  *dic in nearByRestaurantsJSON)
                {
                    CenterDaycare *centerdaycare = [CenterDaycare new];
                    CustomAnnotation *annotation = [CustomAnnotation new];
                    CLLocationCoordinate2D coordinate;
                    coordinate.latitude = [[[dic[@"location"] objectForKey:@"coordinate"] objectForKey:@"latitude"] doubleValue];
                    coordinate.longitude =  [[[dic[@"location"] objectForKey:@"coordinate"] objectForKey:@"longitude"] doubleValue];
                    centerdaycare.viewMapLatitude=coordinate.latitude;
                    centerdaycare.viewMapLongitude=coordinate.longitude;
                    centerdaycare.categories=@"CenterDaycare";
                    centerdaycare.name=dic[@"name"];
                    centerdaycare.daycareLatitude=@(coordinate.latitude);
                    centerdaycare.daycareLongitude=@(coordinate.longitude);
                    NSArray *arr = [dic[@"location"] objectForKey:@"address"];
                    if (arr.count > 0)
                        centerdaycare.address=[arr objectAtIndex:0];
                    centerdaycare.imageUrl=dic[@"image_url"];
                    if (centerdaycare.imageUrl==nil) {
                        centerdaycare.imageUrl=dic[@"snippet_image_url"];
                    }
                    centerdaycare.phone=dic[@"phone"];
                    if (centerdaycare.phone==nil) {
                        centerdaycare.phone=@"";
                    }
                    centerdaycare.rating=dic[@"rating"];
                    if (centerdaycare.rating==nil) {
                        centerdaycare.rating=0;
                    }
                    [centerDaycareArr addObject:centerdaycare];
                    annotation.coordinate = coordinate;
                    annotation.detectName = @"CenterDaycare";
                    annotation.title = centerdaycare.name;
                    annotation.subtitle =centerdaycare.address;
                    [annotationArr addObject:annotation];
                }
//                NSMutableArray *pins = [[NSMutableArray alloc] initWithArray:[self.locationMapView annotations]];
//                [self.locationMapView removeAnnotations:pins];
                [self.locationMapView showAnnotations:annotationArr animated:YES];
                
                [_tableView reloadData];
            } else {
                [SVProgressHUD dismiss];
                [self showAlert:@"No Center Daycare was found"];
            }
            
            dispatch_group_leave(requestGroup);
        }];
        
        //        dispatch_group_wait(requestGroup, DISPATCH_TIME_FOREVER); // This avoids the program exiting before all our asynchronous callbacks have been made.
    }
}
// Home Daycare

- (void) HomeDaycareAPI {
    //Here YOUR URL
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://kidcarejourney.com/request.php?action=getkidcare&"]];
    
    //create the Method "GET" or "POST"
    [request setHTTPMethod:@"POST"];
    //Pass The String to server(YOU SHOULD GIVE YOUR PARAMETERS INSTEAD OF MY PARAMETERS)
    NSString *userUpdate =[NSString stringWithFormat:@"categories=%@",@"Homedaycare",nil];
    
    //Check The Value what we passed
    NSLog(@"The data Details is =%@", userUpdate);
    
    //Convert the String to Data
    NSData *data1 = [userUpdate dataUsingEncoding:NSUTF8StringEncoding];
    
    //Apply the data to the body
    [request setHTTPBody:data1];
    
    //Create the response and Error
    NSError *err;
    NSURLResponse *response;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    
    NSString *resSrt = [[NSString alloc]initWithData:responseData encoding:NSASCIIStringEncoding];
    
    //This is for Response
    NSLog(@"got response==%@", resSrt);
    NSData *data2= [resSrt dataUsingEncoding:NSUTF8StringEncoding];
    id json = [NSJSONSerialization JSONObjectWithData:data2 options:0 error:nil];
    _jsonArr = [json objectForKey:@"results"];
    NSLog(@"jsonArr : %@",self.jsonArr);
    if (_jsonArr.count > 0) {
    NSMutableArray *annotationArr = [NSMutableArray new];
    centerDaycareArr=[NSMutableArray new];
        for (NSDictionary *dic in _jsonArr)
        {
            CenterDaycare *centerdaycare = [CenterDaycare new];
            CustomAnnotation *annotation = [CustomAnnotation new];
            CLLocationCoordinate2D coordinate;
            coordinate.latitude = [dic[@"latitude"] doubleValue];
            coordinate.longitude= [dic[@"longitude"] doubleValue];
            
            // Calculate distance between two point
            CLLocation *daycareLocation = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
            CLLocationDistance distance = [_currentLocation distanceFromLocation:daycareLocation];
            NSLog(@"Distance : %f", distance);
            if (distance < 40000) {
                centerdaycare.viewMapLatitude=coordinate.latitude;
                centerdaycare.viewMapLongitude=coordinate.longitude;
                centerdaycare.categories=dic[@"categories"];
                centerdaycare.name=dic[@"name"];
                centerdaycare.daycareLatitude=@(coordinate.latitude);
                centerdaycare.daycareLongitude=@(coordinate.longitude);
                centerdaycare.address=dic[@"address"];
                centerdaycare.email=dic[@"email"];
                centerdaycare.phone=dic[@"phonenumber"];
                centerdaycare.rating=dic[@"rating"];
                //Get Daycare Image url
                NSString *strImageName;
                NSString *strValue=@"";
                strValue = [centerdaycare.email stringByReplacingOccurrencesOfString:@"@" withString:@""];
                strValue = [strValue stringByReplacingOccurrencesOfString:@"." withString:@""];
                strValue = [strValue stringByAppendingString:@"-"];
                strValue = [strValue stringByAppendingString:centerdaycare.categories];
                strValue = [strValue stringByAppendingString:@"-"];
                strValue = [strValue stringByAppendingString:centerdaycare.name];
                strValue = [strValue stringByAppendingString:@".png"];
                strValue = [strValue stringByReplacingOccurrencesOfString:@" " withString:@""];
                strImageName = strValue;
                centerdaycare.imageUrl=[NSString stringWithFormat:@"http://kidcarejourney.com/image/%@", strImageName];
                [centerDaycareArr addObject:centerdaycare];
                annotation.coordinate = coordinate;
                annotation.detectName = @"Homedaycare";
                annotation.title = centerdaycare.name;
                annotation.subtitle =centerdaycare.address;
                [annotationArr addObject:annotation];
            }

        }
//        NSMutableArray *pins = [[NSMutableArray alloc] initWithArray:[self.locationMapView annotations]];
//        [self.locationMapView removeAnnotations:pins];
        [self.locationMapView showAnnotations:annotationArr animated:YES];
        
        [_tableView reloadData];
    } else {
        [SVProgressHUD dismiss];
        [self showAlert:@"No Home Daycare was found"];
    }

}

//Babysitter API

- (void) BabysitterAPI {
    //Here YOUR URL
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://kidcarejourney.com/request.php?action=getkidcare&"]];
    
    //create the Method "GET" or "POST"
    [request setHTTPMethod:@"POST"];
    //Pass The String to server(YOU SHOULD GIVE YOUR PARAMETERS INSTEAD OF MY PARAMETERS)
    NSString *userUpdate =[NSString stringWithFormat:@"categories=%@",@"Babysitter",nil];
    
    //Check The Value what we passed
    NSLog(@"The data Details is =%@", userUpdate);
    
    //Convert the String to Data
    NSData *data1 = [userUpdate dataUsingEncoding:NSUTF8StringEncoding];
    
    //Apply the data to the body
    [request setHTTPBody:data1];
    
    //Create the response and Error
    NSError *err;
    NSURLResponse *response;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    
    NSString *resSrt = [[NSString alloc]initWithData:responseData encoding:NSASCIIStringEncoding];
    
    //This is for Response
    NSLog(@"got response==%@", resSrt);
    NSData *data2= [resSrt dataUsingEncoding:NSUTF8StringEncoding];
    id json = [NSJSONSerialization JSONObjectWithData:data2 options:0 error:nil];
    _jsonArr = [json objectForKey:@"results"];
    NSLog(@"jsonArr : %@",self.jsonArr);
    if (_jsonArr.count > 0) {
        NSMutableArray *annotationArr = [NSMutableArray new];
        centerDaycareArr=[NSMutableArray new];
        for (NSDictionary *dic in _jsonArr)
        {
            CenterDaycare *centerdaycare = [CenterDaycare new];
            CustomAnnotation *annotation = [CustomAnnotation new];
            CLLocationCoordinate2D coordinate;
            coordinate.latitude = [dic[@"latitude"] doubleValue];
            coordinate.longitude= [dic[@"longitude"] doubleValue];
            
            // Calculate distance between two point
            CLLocation *daycareLocation = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
            CLLocationDistance distance = [_currentLocation distanceFromLocation:daycareLocation];
            NSLog(@"Distance : %f", distance);
            if (distance < 40000) {
                centerdaycare.viewMapLatitude=coordinate.latitude;
                centerdaycare.viewMapLongitude=coordinate.longitude;
                centerdaycare.categories=dic[@"categories"];
                centerdaycare.name=dic[@"name"];
                centerdaycare.daycareLatitude=@(coordinate.latitude);
                centerdaycare.daycareLongitude=@(coordinate.longitude);
                centerdaycare.address=dic[@"address"];
                centerdaycare.email=dic[@"email"];
                centerdaycare.phone=dic[@"phonenumber"];
                centerdaycare.rating=dic[@"rating"];
                //Get Daycare Image url
                NSString *strImageName;
                NSString *strValue=@"";
                strValue = [centerdaycare.email stringByReplacingOccurrencesOfString:@"@" withString:@""];
                strValue = [strValue stringByReplacingOccurrencesOfString:@"." withString:@""];
                strValue = [strValue stringByAppendingString:@"-"];
                strValue = [strValue stringByAppendingString:centerdaycare.categories];
                strValue = [strValue stringByAppendingString:@"-"];
                strValue = [strValue stringByAppendingString:centerdaycare.name];
                strValue = [strValue stringByAppendingString:@".png"];
                strValue = [strValue stringByReplacingOccurrencesOfString:@" " withString:@""];
                strImageName = strValue;
                centerdaycare.imageUrl=[NSString stringWithFormat:@"http://kidcarejourney.com/image/%@", strImageName];
                [centerDaycareArr addObject:centerdaycare];
                annotation.coordinate = coordinate;
                annotation.detectName = @"Babysitter";
                annotation.title = centerdaycare.name;
                annotation.subtitle =centerdaycare.address;
                [annotationArr addObject:annotation];
            }
        }
//        NSMutableArray *pins = [[NSMutableArray alloc] initWithArray:[self.locationMapView annotations]];
//        [self.locationMapView removeAnnotations:pins];
        [self.locationMapView showAnnotations:annotationArr animated:YES];
        
        [_tableView reloadData];
    } else {
        [SVProgressHUD dismiss];
        [self showAlert:@"No Babysitters was found"];
    }
}

- (void) PediatricianAPI {
    //Here YOUR URL
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://kidcarejourney.com/request.php?action=getkidcare&"]];
    
    //create the Method "GET" or "POST"
    [request setHTTPMethod:@"POST"];
    //Pass The String to server(YOU SHOULD GIVE YOUR PARAMETERS INSTEAD OF MY PARAMETERS)
    NSString *userUpdate =[NSString stringWithFormat:@"categories=%@",@"Pediatrician",nil];
    
    //Check The Value what we passed
    NSLog(@"The data Details is =%@", userUpdate);
    
    //Convert the String to Data
    NSData *data1 = [userUpdate dataUsingEncoding:NSUTF8StringEncoding];
    
    //Apply the data to the body
    [request setHTTPBody:data1];
    
    //Create the response and Error
    NSError *err;
    NSURLResponse *response;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    
    NSString *resSrt = [[NSString alloc]initWithData:responseData encoding:NSASCIIStringEncoding];
    
    //This is for Response
    NSLog(@"got response==%@", resSrt);
    NSData *data2= [resSrt dataUsingEncoding:NSUTF8StringEncoding];
    id json = [NSJSONSerialization JSONObjectWithData:data2 options:0 error:nil];
    _jsonArr = [json objectForKey:@"results"];
    NSLog(@"jsonArr : %@",self.jsonArr);
    if (_jsonArr.count > 0) {
        NSMutableArray *annotationArr = [NSMutableArray new];
        centerDaycareArr=[NSMutableArray new];
        for (NSDictionary *dic in _jsonArr)
        {
            CenterDaycare *centerdaycare = [CenterDaycare new];
            CustomAnnotation *annotation = [CustomAnnotation new];
            CLLocationCoordinate2D coordinate;
            coordinate.latitude = [dic[@"latitude"] doubleValue];
            coordinate.longitude= [dic[@"longitude"] doubleValue];
            
            // Calculate distance between two point
            CLLocation *daycareLocation = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
            CLLocationDistance distance = [_currentLocation distanceFromLocation:daycareLocation];
            NSLog(@"Distance : %f", distance);
            if (distance < 40000) {
                centerdaycare.viewMapLatitude=coordinate.latitude;
                centerdaycare.viewMapLongitude=coordinate.longitude;
                centerdaycare.categories=dic[@"categories"];
                centerdaycare.name=dic[@"name"];
                centerdaycare.daycareLatitude=@(coordinate.latitude);
                centerdaycare.daycareLongitude=@(coordinate.longitude);
                centerdaycare.address=dic[@"address"];
                centerdaycare.email=dic[@"email"];
                centerdaycare.phone=dic[@"phonenumber"];
                centerdaycare.rating=dic[@"rating"];
                //Get Daycare Image url
                NSString *strImageName;
                NSString *strValue=@"";
                strValue = [centerdaycare.email stringByReplacingOccurrencesOfString:@"@" withString:@""];
                strValue = [strValue stringByReplacingOccurrencesOfString:@"." withString:@""];
                strValue = [strValue stringByAppendingString:@"-"];
                strValue = [strValue stringByAppendingString:centerdaycare.categories];
                strValue = [strValue stringByAppendingString:@"-"];
                strValue = [strValue stringByAppendingString:centerdaycare.name];
                strValue = [strValue stringByAppendingString:@".png"];
                strValue = [strValue stringByReplacingOccurrencesOfString:@" " withString:@""];
                strImageName = strValue;
                centerdaycare.imageUrl=[NSString stringWithFormat:@"http://kidcarejourney.com/image/%@", strImageName];
                [centerDaycareArr addObject:centerdaycare];
                annotation.coordinate = coordinate;
                annotation.detectName = @"Pediatrician";
                annotation.title = centerdaycare.name;
                annotation.subtitle =centerdaycare.address;
                
                [annotationArr addObject:annotation];
            }
        }
//        NSMutableArray *pins = [[NSMutableArray alloc] initWithArray:[self.locationMapView annotations]];
//        [self.locationMapView removeAnnotations:pins];
        [self.locationMapView showAnnotations:annotationArr animated:YES];
        [_tableView reloadData];
    } else {
        [SVProgressHUD dismiss];
        [self showAlert:@"No Pediatrician was found"];
    }
    
}

#pragma mark - Add the didUpdateUserLocation method : MKMApViewdelegate

// display on Mapview
- (nullable MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }

    if([annotation isKindOfClass:[CustomAnnotation class]]){
        //Try to get an unused annotation, similar to uitableviewcells
        MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"custompin"];
        //If one isn't available, create a new one
        //if(!annotationView){
            annotationView=[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"custompin"];
            annotationView.canShowCallout = YES;
        
            if([((CustomAnnotation *)annotation).detectName isEqualToString: @"CenterDaycare"]){
                annotationView.image=[UIImage imageNamed:@"center"];
            } else if([((CustomAnnotation *)annotation).detectName isEqualToString: @"Homedaycare"]){
                annotationView.image=[UIImage imageNamed:@"home"];
            } else if([((CustomAnnotation *)annotation).detectName isEqualToString: @"Babysitter"]){
                annotationView.image=[UIImage imageNamed:@"baby"];
            } else if([((CustomAnnotation *)annotation).detectName isEqualToString: @"Pediatrician"]){
                annotationView.image=[UIImage imageNamed:@"pedia"];
            }
            
            annotationView.calloutOffset=CGPointMake(0, 16);
            annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];

        //} else {
       //     annotationView.annotation=annotation;
      //  }
        return annotationView;
    }
    return nil;


}
//display detail of when selected pin of Map view
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    CustomAnnotation *selectedAnnotation = view.annotation;
    NSString *titletemp = selectedAnnotation.title;
    NSString *addresstemp = selectedAnnotation.subtitle;
    NSLog(@"titletemp : %@" , titletemp);
    NSLog(@"addresstemp : %@" , addresstemp);
    int i;
    for (i = 0; i < [centerDaycareArr count]; i++) {
        CenterDaycare *centerdaycare = [centerDaycareArr objectAtIndex:i];
        NSLog(@"myarrayNameElement : %@", centerdaycare.name);
        NSLog(@"myarrayAddressElement : %@", centerdaycare.address);
        if ([titletemp isEqualToString:centerdaycare.name]) {
            if ([addresstemp isEqualToString:centerdaycare.address]) {
                [self performSegueWithIdentifier:View_Segue_DaycareDetailVC sender:centerdaycare];
            }
        }
    }
}

//- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
//    MKCoordinateRegion region=MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
//    [self.locationMapView setRegion:[self.locationMapView regionThatFits:region] animated:YES];
//    
//    // Add an annotation
//    MKPointAnnotation *point=[[MKPointAnnotation alloc] init];
//    point.coordinate=userLocation.coordinate;
////    point.title=@"Where am I?";
////    point.subtitle=@"I am here!!!";
//    
//   // [self.locationMapView addAnnotation:point];
//}
#pragma mark - CLLocationManageDelegate

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    _currentLocation=nil;
    NSLog(@"Failed to get your location");
}


-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation: (CLLocation *)oldLocation {
    NSLog(@"Latitude : %f", newLocation.coordinate.latitude);
    NSLog(@"Longitude : %f", newLocation.coordinate.longitude);
    self.currentLocation=newLocation;
    [self dummyMethod];
    [manager stopUpdatingLocation];
}
// display on Tableview
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:View_Segue_DaycareDetailVC])
    {
        DaycareDetailVC *vc= (DaycareDetailVC *)segue.destinationViewController;
        vc.province=self.province;
        vc.centerdaycare=(CenterDaycare *)sender;

    } else if ([segue.identifier isEqualToString:View_Segue_AddDaycareVC]) {
//        AddDaycareVC *vc=(AddDaycareVC *)segue.destinationViewController;
//        vc.hidesBottomBarWhenPushed=YES;
//        vc.addpinType = [sender intValue];
//         NSLog(@"Add pintype: %u", vc.addpinType);
        
    }
}

#pragma mark - UITableViewDelegate, UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return centerDaycareArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DaycareTableViewCell *cell=(DaycareTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"daycareCell" forIndexPath:indexPath];
    CenterDaycare *centerdaycare=[centerDaycareArr objectAtIndex:indexPath.row];
    cell.subNameLbl.text=centerdaycare.name;
    cell.addressLbl.text=centerdaycare.address;
    NSLog(@"%@", centerdaycare.imageUrl);
    [[[SDWebImageManager sharedManager] imageCache] clearDisk];
    [cell.subImg sd_setImageWithURL:[NSURL URLWithString:centerdaycare.imageUrl]placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CenterDaycare *centerdaycare = [centerDaycareArr objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:View_Segue_DaycareDetailVC sender:centerdaycare];
}

@end
