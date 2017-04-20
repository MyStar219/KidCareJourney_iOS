//
//  CenterDaycare.h
//  KidCareJourney
//
//  Created by administrator on 3/19/17.
//  Copyright © 2017 Eddie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface CenterDaycare : NSObject
@property (nonatomic, strong) NSString *viewControl;
@property (nonatomic, strong) NSString *categories;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSNumber *rating;
@property (nonatomic, strong) NSNumber *daycareLatitude;
@property (nonatomic, strong) NSNumber *daycareLongitude;
@property (nonatomic, strong) NSString *email;
@property float viewMapLatitude;
@property float viewMapLongitude;
@end
