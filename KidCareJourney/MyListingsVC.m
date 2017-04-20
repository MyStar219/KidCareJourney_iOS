//
//  MyListingsVC.m
//  KidCareJourney
//
//  Created by administrator on 3/21/17.
//  Copyright © 2017 Eddie. All rights reserved.
//

#import "MyListingsVC.h"
#import "LoginVC.h"
#import "MyListings.h"
#import "MyListingsTableViewCell.h"
#import "MyListingsDetailVC.h"

@interface MyListingsVC ()
@property (weak, nonatomic) IBOutlet UITableView *listingsTableview;
@property (strong, nonatomic) CLLocation *currentLocation;
@property(nonatomic, strong) NSArray *jsonArr;
@end

@implementation MyListingsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.listingsTableview.delegate=self;
    self.listingsTableview.dataSource=self;
    NSLog(@"detect : %@",self.signinDetect);
    
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
    
    if ([self.signinDetect isEqualToString:@"SignIn"]) {
        
        // display my listings
        [self.view endEditing:YES];//keyboard dismiss
        //Here YOUR URL
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://kidcarejourney.com/request.php?action=getmylistings&"]];
        
        //create the Method "GET" or "POST"
        [request setHTTPMethod:@"POST"];

        //Pass The String to server(YOU SHOULD GIVE YOUR PARAMETERS INSTEAD OF MY PARAMETERS)
        
        NSString *userUpdate =[NSString stringWithFormat:@"email=%@",self.emailDetect,nil];
        
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
        if (self.jsonArr.count>0) {
            jsonListingArr = [NSMutableArray new];
            for (NSDictionary *dic in _jsonArr) {
                MyListings *mylistings=[MyListings new];
                mylistings.listingCategory=dic[@"categories"];
                mylistings.listingName=dic[@"name"];
                mylistings.listingDaycareEmail=dic[@"daycareemail"];
                mylistings.listingAddress=dic[@"address"];
                mylistings.listingLatitude=dic[@"latitude"];
                mylistings.listingLongitude=dic[@"longitude"];
                mylistings.listingPhone=dic[@"phonenumber"];
                mylistings.listingRating=dic[@"rating"];
                mylistings.listingEmail=self.emailDetect;
                if([mylistings.listingCategory isEqualToString:@"CenterDaycare"]){
                    mylistings.listingImgurl=dic[@"imageurl"];
                } else {
                    //Get Daycare Image url to web server
                    NSString *strImageName;
                    NSString *strValue=@"";
                    strValue = [mylistings.listingDaycareEmail stringByReplacingOccurrencesOfString:@"@" withString:@""];
                    strValue = [strValue stringByReplacingOccurrencesOfString:@"." withString:@""];
                    strValue = [strValue stringByAppendingString:@"-"];
                    strValue = [strValue stringByAppendingString:mylistings.listingCategory];
                    strValue = [strValue stringByAppendingString:@"-"];
                    strValue = [strValue stringByAppendingString:mylistings.listingName];
                    strValue = [strValue stringByAppendingString:@".png"];
                    strValue = [strValue stringByReplacingOccurrencesOfString:@" " withString:@""];
                    strImageName = strValue;
                    mylistings.listingImgurl=[NSString stringWithFormat:@"http://kidcarejourney.com/image/%@", strImageName];
                }
                // Calculate distance between two point
                CLLocationCoordinate2D coordinate;
                coordinate.latitude = [mylistings.listingLatitude doubleValue];
                coordinate.longitude= [mylistings.listingLongitude doubleValue];
                
                CLLocation *daycareLocation = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
                CLLocationDistance distance = [_currentLocation distanceFromLocation:daycareLocation];
                NSLog(@"Distance : %f", distance);
                mylistings.listingDistance=[NSString stringWithFormat:@"%f", distance];
                
                NSLog(@"Distance : %@", mylistings.listingDistance);

                [jsonListingArr addObject:mylistings];
            }
            [self.listingsTableview reloadData];
        } else {
            
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                        message:@"You need to sign in to use this feature."
                                                       delegate:self
                                              cancelButtonTitle:@"Yes"
                                              otherButtonTitles:@"No", nil];
        [alert show];
    }
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    // the user clicked OK
    if (buttonIndex == 0) { // OK
        UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginVC *vc=(LoginVC *)[storyboard instantiateViewControllerWithIdentifier:View_LoginVC];
        vc.hidesBottomBarWhenPushed=YES;
        vc.viewControl=@"MyListingsVC";

        [self.navigationController pushViewController:vc animated:nil];
        
    } else if (buttonIndex == 1) { // Cancel
        UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MainVC *vc=(MainVC *)[storyboard instantiateViewControllerWithIdentifier:View_MainVC];
        vc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MyListingsDetailVC *vc=(MyListingsDetailVC *)segue.destinationViewController;
    vc.hidesBottomBarWhenPushed=YES;
    vc.mylistings=(MyListings *)sender;
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
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
    [manager stopUpdatingLocation];
}

#pragma mark - UITableViewDelegate, UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return jsonListingArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyListingsTableViewCell *cell=(MyListingsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"mylistingscell" forIndexPath:indexPath];
    MyListings *mylistings=[jsonListingArr objectAtIndex:indexPath.row];
    cell.subListingName.text=mylistings.listingName;
    cell.subListingAddress.text=mylistings.listingAddress;
    cell.subListingCategory.text=mylistings.listingCategory;
    [[[SDWebImageManager sharedManager] imageCache] clearDisk];
    [cell.subListingImg sd_setImageWithURL:[NSURL URLWithString:mylistings.listingImgurl]placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MyListings *mylistings = [jsonListingArr objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:View_Segue_MyListingsDetailVC sender:mylistings];
}
- (IBAction)onClickedBackBtn:(id)sender {
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MainVC *vc=(MainVC *)[storyboard instantiateViewControllerWithIdentifier:View_MainVC];
    vc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vc animated:YES];

}
@end
