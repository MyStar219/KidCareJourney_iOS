//
//  MainVC.h
//  KidCareJourney
//
//  Created by administrator on 3/7/17.
//  Copyright © 2017 Eddie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainVC : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imgView_Main;
@property (weak, nonatomic) IBOutlet UILabel *welcomeLbl;
@property (weak, nonatomic) IBOutlet UIImageView *imgView_Center;
@property (weak, nonatomic) IBOutlet UIImageView *imgView_Home;
@property (weak, nonatomic) IBOutlet UIImageView *imgView_Baby;
@property (weak, nonatomic) IBOutlet UIImageView *imgView_Pedia;

@property (weak, nonatomic) IBOutlet UILabel *findLbl;

- (IBAction)onClickedStartBtn:(id)sender;




@end
