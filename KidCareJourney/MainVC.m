//
//  MainVC.m
//  KidCareJourney
//
//  Created by administrator on 3/7/17.
//  Copyright © 2017 Eddie. All rights reserved.
//

#import "MainVC.h"
#import "LocationVC.h"
@interface MainVC ()

@end

@implementation MainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    

    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
//    if ([segue.identifier isEqualToString:View_Segue_TabBarVC])
//    {
//        UITabBarController *tabbarVC = (UITabBarController *)segue.destinationViewController;
//        LocationVC *locationVC = (LocationVC *)[(UINavigationController *)[tabbarVC.viewControllers objectAtIndex:0] topViewController];
//        locationVC.pinType = [sender intValue];
//    }
}

//- (IBAction)onClickedCenterBtn:(id)sender {
//        [self performSegueWithIdentifier:View_Segue_TabBarVC sender:@(CENTERCARE_PIN)];
//}
//
//- (IBAction)onClickedHomeBtn:(id)sender {
//        [self performSegueWithIdentifier:View_Segue_TabBarVC sender:@(HOMECARE_PIN)];
//}
//
//- (IBAction)onClickedBabyBtn:(id)sender {
//        [self performSegueWithIdentifier:View_Segue_TabBarVC sender:@(BABYSITTER_PIN)];
//}
//- (IBAction)onClickedPediaBtn:(id)sender {
//        [self performSegueWithIdentifier:View_Segue_TabBarVC sender:@(PEDIATRICIAN_PIN)];
//}
- (IBAction)onClickedStartBtn:(id)sender {
    [self performSegueWithIdentifier:View_Segue_TabBarVC sender:nil];
}
@end
