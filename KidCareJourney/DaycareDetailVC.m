//
//  DaycareDetailVC.m
//  KidCareJourney
//
//  Created by administrator on 3/11/17.
//  Copyright © 2017 Eddie. All rights reserved.
//

#import "DaycareDetailVC.h"
#import "CenterDaycare.h"
#import "CommentTableViewCell.h"
#import "Comment.h"

@interface DaycareDetailVC ()<CLLocationManagerDelegate>
@property (strong, nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) MKPlacemark *destination;
@property (strong,nonatomic) MKPlacemark *source;
@property (nonatomic, strong) NSArray *jsonArr;
@property (nonatomic) NSString *ratingValue;
@end

@implementation DaycareDetailVC
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mapView.hidden=YES;
    self.mapView.delegate=self;
    self.commentTableView.delegate=self;
    self.commentTableView.dataSource=self;
    self.commentView.hidden=YES;
    self.centerdaycare.viewControl=@"DaycareDetailVC";
    self.nameLbl.text=self.centerdaycare.name;
    self.phone.text=self.centerdaycare.phone;  
    // Display rating image
    NSLog(@"rating : %@", self.centerdaycare.rating);
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    HCSStarRatingView *starRatingView = [[HCSStarRatingView alloc] initWithFrame:CGRectMake((screenSize.width*145)/375, (screenSize.height*520)/667, (screenSize.width*210)/375, (screenSize.height*40)/667)];
    starRatingView.maximumValue = 5;
    starRatingView.minimumValue = 0;
    starRatingView.value = 0;
    starRatingView.tintColor = [UIColor redColor];
    starRatingView.backgroundColor =[self colorWithHexString:@"F2EFF3"];
//    [starRatingView addTarget:self action:@selector(didChangeValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:starRatingView];
    starRatingView.allowsHalfStars = YES;
    if ([self.centerdaycare.categories isEqualToString:@"CenterDaycare"]) {
         starRatingView.value =[self.centerdaycare.rating doubleValue];
    } else {
        [self GetComment];
        starRatingView.value = [self.ratingValue doubleValue]/commentArr.count;
    }
    starRatingView.accurateHalfStars = YES;

    self.address.text=self.centerdaycare.address;
    NSLog(@"province data : %@", self.province);
    if (self.province.length == 0) {
        self.addressDetail.text=self.centerdaycare.address;
    } else {
        self.province=[@", " stringByAppendingString:self.province];
        NSLog(@"province data : %@", self.province);
        self.addressDetail.text=[self.centerdaycare.address stringByAppendingString:self.province];
    }
    [[[SDWebImageManager sharedManager] imageCache] clearDisk];
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.centerdaycare.imageUrl]placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    LoginVC *vc=(LoginVC *)segue.destinationViewController;
    vc.hidesBottomBarWhenPushed=YES;
    vc.addcenterdaycare=(CenterDaycare *)sender;
//    vc.viewcontrolpinType = [sender intValue];
//    NSLog(@"Add pintype: %u", vc.viewcontrolpinType);
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
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
        [self performSegueWithIdentifier:View_Segue_LoginVC sender:_centerdaycare];
    } else {
        UIAlertView *erroralert = [[UIAlertView alloc] initWithTitle:@"Mail failed"
                                                        message:@"Please try again."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [erroralert show];
    }
}


- (IBAction)onClickedSaveBtn:(id)sender {
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

- (IBAction)onClickedBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)viewMapBtn:(id)sender {
    self.mapView.hidden=NO;
    self.imageView.hidden=YES;
    self.nameLbl.hidden=YES;
    self.mapView.showsUserLocation=NO;
    [self.mapView removeAnnotations:self.mapView.annotations];
    CustomAnnotation *viewMap = [[CustomAnnotation alloc] init];
    viewMap.title=self.centerdaycare.name;
    viewMap.coordinate=CLLocationCoordinate2DMake(self.centerdaycare.viewMapLatitude, self.centerdaycare.viewMapLongitude);
    if ([self.centerdaycare.categories isEqualToString:@"CenterDaycare"]) {
        viewMap.detectName = @"CenterDaycare";
    } else if ([self.centerdaycare.categories isEqualToString:@"Homedaycare"]) {
        viewMap.detectName = @"Homedaycare";
    } else if ([self.centerdaycare.categories isEqualToString:@"Babysitter"]){
        viewMap.detectName = @"Babysitter";
    } else if ([self.centerdaycare.categories isEqualToString:@"Pediatrician"]) {
        viewMap.detectName = @"Pediatrician";
    }
    [self.mapView addAnnotation:viewMap];
    [self.mapView setCenterCoordinate:viewMap.coordinate];
}

- (IBAction)directionsBtn:(id)sender {
    self.mapView.hidden=NO;
    self.imageView.hidden=YES;
    self.nameLbl.hidden=YES;
    self.mapView.showsUserLocation=NO;
    [self.mapView removeAnnotations:self.mapView.annotations];
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

- (IBAction)onClickedShowCommentViewBtn:(id)sender {
    self.commentView.hidden=NO;
    [self GetComment];
}
- (IBAction)onClickedHideCommentViewBtn:(id)sender {
    self.commentView.hidden=YES;
}

- (void)showAlert:(NSString *)sMessage{
    NSLog(@"Message : %@", sMessage);
}

// Get Comment
- (void) GetComment {
    //Here YOUR URL
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://kidcarejourney.com/request.php?action=getcomments&"]];
    
    //create the Method "GET" or "POST"
    [request setHTTPMethod:@"POST"];
    //Pass The String to server(YOU SHOULD GIVE YOUR PARAMETERS INSTEAD OF MY PARAMETERS)
    NSString *userUpdate =[NSString stringWithFormat:@"daycarename=%@",self.centerdaycare.name,nil];
    
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
        commentArr=[NSMutableArray new];
        float ratingValueElement=0;
        for (NSDictionary *dic in _jsonArr)
        {
            Comment *comment = [Comment new];
            comment.userName=dic[@"username"];
            comment.userEmail=dic[@"useremail"];
            comment.daycareName=dic[@"daycarename"];
            comment.addEmail=dic[@"addemail"];
            comment.rating=dic[@"rating"];
            comment.commentContent=dic[@"comments"];
            comment.displayComment=@"";
            comment.displayComment=[comment.commentContent stringByAppendingString:@" : "];
            comment.displayComment=[comment.displayComment stringByAppendingString:comment.userName];
            [commentArr addObject:comment];
            ratingValueElement = ratingValueElement + [comment.rating doubleValue];
        }
        self.ratingValue=[NSString stringWithFormat:@"%f", ratingValueElement];
        [self.commentTableView reloadData];
    } else {
        [self showAlert:@"No Comment was found"];
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
        } else if([((CustomAnnotation *)annotation).detectName isEqualToString: @"MyLocation"]) {
            annotationView.image=[UIImage imageNamed:@"mapannotation.png"];
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
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    MKCoordinateRegion region=MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];

    // Add an annotation
    MKPointAnnotation *point=[[MKPointAnnotation alloc] init];
    point.coordinate=userLocation.coordinate;
//    point.title=@"Where am I?";
//    point.subtitle=@"I am here!!!";

    [self.mapView addAnnotation:point];
}
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation: (CLLocation *)oldLocation {
    NSLog(@"Latitude : %f", newLocation.coordinate.latitude);
    NSLog(@"Longitude : %f", newLocation.coordinate.longitude);
    self.currentLocation=newLocation;
    [self GetDirection];
    [manager stopUpdatingLocation];
}

- (void) GetDirection {
    CLLocationCoordinate2D sourceCoords = [self.currentLocation coordinate];
    MKCoordinateRegion region;
    //Set Zoom level using Span
    MKCoordinateSpan span;
    region.center = sourceCoords;
    
    span.latitudeDelta = 1;
    span.longitudeDelta = 1;
    region.span=span;
    [self.mapView setRegion:region animated:TRUE];
    
    MKPlacemark *placemark  = [[MKPlacemark alloc] initWithCoordinate:sourceCoords addressDictionary:nil];
    
    CustomAnnotation *annotation = [[CustomAnnotation alloc] init];
    annotation.coordinate = sourceCoords;
    annotation.title = @"My Location";
    annotation.detectName = @"MyLocation";
    [self.mapView addAnnotation:annotation];
    //[self.myMapView addAnnotation:placemark];
    
    _destination = placemark;
    
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:_destination];
    
    CLLocationCoordinate2D destCoords = CLLocationCoordinate2DMake(self.centerdaycare.viewMapLatitude, self.centerdaycare.viewMapLongitude);
    MKPlacemark *placemark1  = [[MKPlacemark alloc] initWithCoordinate:destCoords addressDictionary:nil];
    
    CustomAnnotation *annotation1 = [[CustomAnnotation alloc] init];
    annotation1.coordinate = destCoords;
    annotation1.title = self.centerdaycare.name;
    if ([self.centerdaycare.categories isEqualToString:@"CenterDaycare"]) {
        annotation1.detectName = @"CenterDaycare";
    } else if ([self.centerdaycare.categories isEqualToString:@"Homedaycare"]) {
        annotation1.detectName = @"Homedaycare";
    } else if ([self.centerdaycare.categories isEqualToString:@"Babysitter"]){
        annotation1.detectName = @"Babysitter";
    } else if ([self.centerdaycare.categories isEqualToString:@"Pediatrician"]) {
        annotation1.detectName = @"Pediatrician";
    }
    [self.mapView addAnnotation:annotation1];
    
    //[self.myMapView addAnnotation:placemark1];
    
    _source = placemark1;
    
    MKMapItem *mapItem1 = [[MKMapItem alloc] initWithPlacemark:_source];
    
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    request.source = mapItem1;
    
    request.destination = mapItem;
    request.requestsAlternateRoutes = NO;
    
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    
    [directions calculateDirectionsWithCompletionHandler:
     ^(MKDirectionsResponse *response, NSError *error) {
         if (error) {
             NSLog(@"ERROR");
             NSLog(@"%@",[error localizedDescription]);
         } else {
             [self showRoute:response];
         }
     }];
}
-(void)showRoute:(MKDirectionsResponse *)response
{
    for (MKRoute *route in response.routes)
    {
        [self.mapView
         addOverlay:route.polyline level:MKOverlayLevelAboveRoads];
        
        for (MKRouteStep *step in route.steps)
        {
            NSLog(@"%@", step.instructions);
        }
    }
}
#pragma mark - MKMapViewDelegate methods

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
    renderer.strokeColor = [UIColor colorWithRed:0.0/255.0 green:171.0/255.0 blue:253.0/255.0 alpha:1.0];
    renderer.lineWidth = 10.0;
    return  renderer;
}

#pragma mark - UITableViewDelegate, UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return commentArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentTableViewCell *cell=(CommentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"commentCell" forIndexPath:indexPath];
    Comment *comment=[commentArr objectAtIndex:indexPath.row];
    cell.ratingValueLbl.text=comment.rating;
    cell.commentLbl.text=comment.displayComment;
    HCSStarRatingView *starRatingView = [[HCSStarRatingView alloc] initWithFrame:CGRectMake(5, 35, 100, 20)];
    starRatingView.maximumValue = 5;
    starRatingView.minimumValue = 0;
    starRatingView.value = 0;
    starRatingView.tintColor = [UIColor yellowColor];
    starRatingView.backgroundColor =[UIColor whiteColor];
    //    [starRatingView addTarget:self action:@selector(didChangeValue:) forControlEvents:UIControlEventValueChanged];
    [cell.contentView addSubview:starRatingView];
    starRatingView.allowsHalfStars = YES;
    starRatingView.value =[comment.rating doubleValue];
    starRatingView.accurateHalfStars = YES;
    return cell;
}
@end
