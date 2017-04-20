//
//  CustomAnnotation.h
//  KidCareJourney
//
//  Created by administrator on 3/27/17.
//  Copyright © 2017 Eddie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CustomAnnotation : NSObject <MKAnnotation>

@property (nonatomic, copy) NSString            *title;
@property (nonatomic, copy) NSString            *subtitle;
@property (nonatomic, copy) NSString            *detectName;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, copy) NSURL               *detialURL;
@property (nonatomic) CLLocationCoordinate2D    coordinate;

- (id) initWithTitle:(NSString *)newTitle location:(CLLocationCoordinate2D)location;
- (id) initWithTitle:(NSString *)newTitle subTitle:(NSString *)newSubTitle detailURL:(NSURL *)url location:(CLLocationCoordinate2D)location;
- (MKAnnotationView *) annotationView;

@end
