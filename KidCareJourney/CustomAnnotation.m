//
//  CustomAnnotation.m
//  KidCareJourney
//
//  Created by administrator on 3/27/17.
//  Copyright © 2017 Eddie. All rights reserved.
//

#import "CustomAnnotation.h"

@implementation CustomAnnotation
#pragma mark init methods

//---------------------------------------------------------------

- (id) initWithTitle:(NSString *)newTitle location:(CLLocationCoordinate2D)location {
    self = [super init];
    if (self) {
        _title = newTitle;
        self.coordinate = location;
    }
    return self;
}

//---------------------------------------------------------------

- (id) initWithTitle:(NSString *)newTitle subTitle:(NSString *)newSubTitle detailURL:(NSURL *)url location:(CLLocationCoordinate2D)location {
    self = [super init];
    if (self) {
        _title = newTitle;
        _subtitle = newSubTitle;
        self.coordinate = location;
    }
    return self;
}

//---------------------------------------------------------------

- (MKAnnotationView *) annotationView {
    MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"CustomAnnotation"];
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    annotationView.image = [UIImage imageNamed:@"mapannotation.png"];
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [annotationView setCenterOffset:CGPointMake(0, -32)];
    return annotationView;
}

@end
