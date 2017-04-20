//
//  GlobalScope.m
//  Restaurant Roulette
//
//  Created by Wang Ri on 1/12/16.
//  Copyright © 2016 Wang Ri. All rights reserved.
//

#import "GlobalScope.h"

@implementation GlobalScope

NSString *APP_NAME = @"Restaurant Roulette";

NSString *distanceUnitStorageKey = @"com.dev.wangri.restaurantRoulette.unit";
CGFloat convertMileToKilometre = 1.60934;
NSArray *arrPriceLevels;
NSUserDefaults *defaults;
NSString *sPriceLevelStorageKey = @"com.dev.wangri.restaurantRoulette.priceLevel";
NSString *sDistanceLevelStorageKey = @"com.dev.wangri.restaurantRoulette.distanceLevel";
NSString *defaultLimit = @"100";
NSString *defaultSort = @"0";
NSString *defaultRadiusFilter = @"40000";
//CLLocation *currentLocation;
NSMutableArray *centerDaycareArr;
NSMutableArray *daycareAPIArr;
NSMutableArray *daycareBACKENDArr;
NSMutableArray *jsonListingArr;
NSMutableArray *jsonNotificationArr;
NSMutableArray *commentArr;
NSString *temp;
@end
