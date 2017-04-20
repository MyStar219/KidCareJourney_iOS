//
//  FacebookVC.h
//  KidCareJourney
//
//  Created by administrator on 3/12/17.
//  Copyright © 2017 Eddie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FacebookVC : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *facebookWebview;

- (IBAction)onClickedBackBtn:(id)sender;

@end
