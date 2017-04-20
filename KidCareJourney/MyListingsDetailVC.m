//
//  MyListingsDetailVC.m
//  KidCareJourney
//
//  Created by administrator on 3/26/17.
//  Copyright © 2017 Eddie. All rights reserved.
//

#import "MyListingsDetailVC.h"
#import "Comment.h"
@interface MyListingsDetailVC ()
@property (nonatomic, strong) NSArray *jsonArr;
@property (nonatomic) NSString *ratingValue;
@end

@implementation MyListingsDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mylistingName.text=self.mylistings.listingName;
    self.mylistingCategory.text=self.mylistings.listingCategory;
    self.mylistingAddress.text=self.mylistings.listingAddress;
    self.mylistingDistance.text=self.mylistings.listingDistance;
    self.mylistingPhone.text=self.mylistings.listingPhone;
    [[[SDWebImageManager sharedManager] imageCache] clearDisk];
    [self.mylistingImg sd_setImageWithURL:[NSURL URLWithString:self.mylistings.listingImgurl]placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    // Display rating image
    NSLog(@"rating : %@", self.mylistings.listingRating);
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    HCSStarRatingView *starRatingView = [[HCSStarRatingView alloc] initWithFrame:CGRectMake((screenSize.width*160)/375, (screenSize.height*560)/667, (screenSize.width*200)/375, (screenSize.height*21)/667)];
    starRatingView.maximumValue = 5;
    starRatingView.minimumValue = 0;
    starRatingView.value = 0;
    starRatingView.tintColor = [UIColor redColor];
    starRatingView.backgroundColor =[self colorWithHexString:@"F2EFF3"];
//    [starRatingView addTarget:self action:@selector(didChangeValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:starRatingView];
    starRatingView.allowsHalfStars = YES;
    if ([self.mylistings.listingCategory isEqualToString:@"CenterDaycare"]) {
        starRatingView.value =[self.mylistings.listingRating doubleValue];
    } else {
        [self GetComment];
        starRatingView.value = [self.ratingValue doubleValue]/commentArr.count;
    }
    starRatingView.accurateHalfStars = YES;
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
// Get Comment
- (void) GetComment {
    //Here YOUR URL
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://kidcarejourney.com/request.php?action=getcomments&"]];
    
    //create the Method "GET" or "POST"
    [request setHTTPMethod:@"POST"];
    //Pass The String to server(YOU SHOULD GIVE YOUR PARAMETERS INSTEAD OF MY PARAMETERS)
    NSString *userUpdate =[NSString stringWithFormat:@"daycarename=%@",self.mylistings.listingName,nil];
    
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
            comment.rating=dic[@"rating"];
            [commentArr addObject:comment];
            ratingValueElement = ratingValueElement + [comment.rating doubleValue];
        }
        self.ratingValue=[NSString stringWithFormat:@"%f", ratingValueElement];
    } else {
        [self showAlert:@"No Comment was found"];
    }
}
- (void)showAlert:(NSString *)sMessage{
    NSLog(@"Message : %@", sMessage);
}

- (IBAction)onClickedBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onClickedAddCommentBtn:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddCommentVC *vc=(AddCommentVC *)[storyboard instantiateViewControllerWithIdentifier:View_AddCommentVC];
    vc.userEmail=self.mylistings.listingEmail;
    vc.addEmail=self.mylistings.listingDaycareEmail;
    vc.daycareName=self.mylistings.listingName;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onClickedDeleteBtn:(id)sender {
    // display my listings
    [self.view endEditing:YES];//keyboard dismiss
    //Here YOUR URL
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://kidcarejourney.com/request.php?action=deletemylisting&"]];
    
    //create the Method "GET" or "POST"
    [request setHTTPMethod:@"POST"];
    
    //Pass The String to server(YOU SHOULD GIVE YOUR PARAMETERS INSTEAD OF MY PARAMETERS)
    
    NSString *userUpdate =[NSString stringWithFormat:@"email=%@&name=%@",self.mylistings.listingEmail, self.mylistings.listingName,nil];
    
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
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MyListingsVC *vc=(MyListingsVC *)[storyboard instantiateViewControllerWithIdentifier:View_MyListingsVC];
        vc.signinDetect=@"SignIn";
        vc.emailDetect=self.mylistings.listingEmail;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Please try again."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}
@end
