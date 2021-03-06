//
//  YPAPISample.h
//  YelpAPI
//

#import <Foundation/Foundation.h>
#import "NSURLRequest+OAuth.h"

/**
 Sample class for accessing the Yelp API V2.

 This class demonstrates the capability of the Yelp API version 2.0 by using the Search API to
 query for businesses by a search term and location, and the Business API to query additional
 information about the top result from the search query.

 See the Yelp Documentation http://www.yelp.com/developers/documentation for more info.
 */
@interface YPAPISample : NSObject

/**
 Query the Yelp API with a given term and location and displays the progress in the log
 
  */
- (void)queryTopBusinessInfoForTerm:(NSString *)term location:(NSString *)location completionHandler:(void (^)(NSArray *jsonResponse, NSError *error))completionHandler;

//- (void)queryNearbyRestaurantsInfoForTerm:(NSString *)term location:(NSString *)location cll:(NSString *)cll limit:(NSString *)limit sort:(NSString *)sort radius_filter:(NSString *)radius_filter completionHandler:(void (^)(NSDictionary *jsonResponse, NSError *error))completionHandler;

- (void)queryNearbyRestaurantsInfoForTerm:(NSString *)term ll:(NSString *)ll limit:(NSString *)limit sort:(NSString *)sort radius_filter:(NSString *)radius_filter completionHandler:(void (^)(NSArray *arrJSON, NSError *error))completionHandler;


@end
