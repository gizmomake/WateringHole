//
//  MyLocation.h
//  WateringHole
//
//  Created by Ben Thomson on 12/29/13.
//  Copyright (c) 2013 Gizmomake. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
@interface MyLocation : NSObject <MKAnnotation>


@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *string;
@property (nonatomic, strong) NSString *taste;
@property (nonatomic, strong) NSString *temp;
@property (nonatomic, assign) NSString *locationType;

- (MKMapItem*)mapItem;

- (id)initWithLocation:(CLLocationCoordinate2D)coord;
- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;

@end