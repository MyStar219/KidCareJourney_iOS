//
//  TwitterVC.m
//  KidCareJourney
//
//  Created by administrator on 3/12/17.
//  Copyright © 2017 Eddie. All rights reserved.
//

#import "TwitterVC.h"

@interface TwitterVC ()

@end

@implementation TwitterVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    NSString *fullURL = @"https://twitter.com/KidCareJourney";
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.twitterWebview loadRequest:requestObj];
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
