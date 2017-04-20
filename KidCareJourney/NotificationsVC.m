//
//  NotificationsVC.m
//  KidCareJourney
//
//  Created by administrator on 3/7/17.
//  Copyright © 2017 Eddie. All rights reserved.
//

#import "NotificationsVC.h"
#import "Notifications.h"
#import "NotificationsTableViewCell.h"
@interface NotificationsVC ()
@property(nonatomic, strong) NSArray *jsonArr;
@property (nonatomic, strong) NSString *getemail;
@property (nonatomic, strong) UIImage *getImg;
@property (nonatomic) NSString *alertDetect;
@property (nonatomic) NSString *getEmailDelete;
@property (nonatomic) NSString *addEmailDelete;
@end

@implementation NotificationsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.notificationTableView.delegate=self;
    self.notificationTableView.dataSource=self;
    if ([self.signinDetect isEqualToString:@"SignIn"]) {
        [self GetNotification];
    // Do any additional setup after loading the view.
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                        message:@"You need to sign in to use this feature."
                                                       delegate:self
                                              cancelButtonTitle:@"Yes"
                                              otherButtonTitles:@"No", nil];
        [alert show];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITableViewDelegate, UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return jsonNotificationArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NotificationsTableViewCell *cell=(NotificationsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"notificationcell" forIndexPath:indexPath];
    Notifications *notifications=[jsonNotificationArr objectAtIndex:indexPath.row];
    cell.subName.text=notifications.adddaycarename;
    cell.subCategory.text=notifications.addcategory;
    cell.subUserName.text=notifications.getname;
    cell.subUserEmail.text=notifications.getemail;
    cell.subUserAddress.text=notifications.getaddress;
    cell.subUserPhoneNumber.text=notifications.getphonenumber;
    [[[SDWebImageManager sharedManager] imageCache] clearDisk];
    [cell.subImg sd_setImageWithURL:[NSURL URLWithString:notifications.imgUrl]placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.alertDetect=@"Delete Notification";
    Notifications *notifications = [jsonNotificationArr objectAtIndex:indexPath.row];
    self.getEmailDelete=notifications.getemail;
    self.addEmailDelete=self.emailDetect;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                    message:@"Do you want to delete this notification?"
                                                   delegate:self
                                          cancelButtonTitle:@"Yes"
                                          otherButtonTitles:@"No", nil];
    [alert show];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
// Get Notifications
- (void) GetNotification {
    //Here YOUR URL
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://kidcarejourney.com/request.php?action=getnotification&"]];
    
    //create the Method "GET" or "POST"
    [request setHTTPMethod:@"POST"];
    
    //Pass The String to server(YOU SHOULD GIVE YOUR PARAMETERS INSTEAD OF MY PARAMETERS)
    NSString *userUpdate =[NSString stringWithFormat:@"addemail=%@",self.emailDetect,nil];
    
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
        jsonNotificationArr = [NSMutableArray new];
        for (NSDictionary *dic in _jsonArr) {
            Notifications *notifications=[Notifications new];
            notifications.getname =dic[@"getname"];
            notifications.getemail=dic[@"getemail"];
            self.getemail=notifications.getemail;  // Get email to get image
            notifications.getaddress=dic[@"getaddress"];
            notifications.getphonenumber=dic[@"getphonenumber"];
            notifications.addcategory=dic[@"addcategory"];
            notifications.adddaycarename=dic[@"adddaycarename"];
            NSString *strImageName;
            NSString *strValue=@"";
            strValue = [self.getemail stringByReplacingOccurrencesOfString:@"@" withString:@""];
            strValue = [strValue stringByReplacingOccurrencesOfString:@"." withString:@""];
            strValue = [strValue stringByAppendingString:@".png"];
            strImageName=strValue;
            notifications.imgUrl=[NSString stringWithFormat:@"http://kidcarejourney.com/image/%@", strImageName];
            [jsonNotificationArr addObject:notifications];
        }
        [self.notificationTableView reloadData];
    }
    
}
- (void) DeleteNotification {
    // display my listings
    [self.view endEditing:YES];//keyboard dismiss
    //Here YOUR URL
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://kidcarejourney.com/request.php?action=deletenotification&"]];
    
    //create the Method "GET" or "POST"
    [request setHTTPMethod:@"POST"];
    
    //Pass The String to server(YOU SHOULD GIVE YOUR PARAMETERS INSTEAD OF MY PARAMETERS)
    
    NSString *userUpdate =[NSString stringWithFormat:@"addemail=%@&getemail=%@",self.addEmailDelete, self.getEmailDelete,nil];
    
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
    if ([resSrt isEqualToString:@"yes"]) {
        [self GetNotification];
    }
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    // the user clicked OK
    if (buttonIndex == 0) { // OK
        if ([self.alertDetect isEqualToString:@"Delete Notification"]) {
            [self DeleteNotification];
        } else {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            LoginVC *vc =(LoginVC *)[storyboard instantiateViewControllerWithIdentifier:View_LoginVC];
            vc.viewControl=@"NotificationsVC";
            vc.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    } else if (buttonIndex == 1) { // Cancel
        if ([self.alertDetect isEqualToString:@"Delete Notification"]) {
            
        } else {
            UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MainVC *vc=(MainVC *)[storyboard instantiateViewControllerWithIdentifier:View_MainVC];
            vc.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
- (IBAction)onClickedNotificationBtn:(id)sender {
    [self GetNotification];
}

- (IBAction)onClickedBackBtn:(id)sender {
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MainVC *vc=(MainVC *)[storyboard instantiateViewControllerWithIdentifier:View_MainVC];
    vc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
