//
//  Comment.h
//  KidCareJourney
//
//  Created by administrator on 4/12/17.
//  Copyright © 2017 Eddie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Comment : NSObject
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *userEmail;
@property (strong, nonatomic) NSString *daycareName;
@property (strong, nonatomic) NSString *addEmail;
@property (strong, nonatomic) NSString *rating;
@property (strong, nonatomic) NSString *commentContent;
@property (strong, nonatomic) NSString *displayComment;
@end
