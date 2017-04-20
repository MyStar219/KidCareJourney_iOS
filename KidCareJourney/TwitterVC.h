//
//  TwitterVC.h
//  KidCareJourney
//
//  Created by administrator on 3/12/17.
//  Copyright © 2017 Eddie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TwitterVC : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *twitterWebview;

- (IBAction)onClickedBackBtn:(id)sender;

@end
