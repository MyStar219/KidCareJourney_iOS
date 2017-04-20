//
//  FacebookVC.m
//  KidCareJourney
//
//  Created by administrator on 3/12/17.
//  Copyright © 2017 Eddie. All rights reserved.
//

#import "FacebookVC.h"

@interface FacebookVC ()

@end

@implementation FacebookVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *fullURL = @"https://www.facebook.com/Kid-Care-Journey-1877994225805798/";
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.facebookWebview loadRequest:requestObj];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onClickedBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
