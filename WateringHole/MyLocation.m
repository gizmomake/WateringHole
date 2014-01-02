//
//  MyLocation.m
//  WateringHole
//
//  Created by Ben Thomson on 12/29/13.
//  Copyright (c) 2013 Gizmomake. All rights reserved.
//

#import "MyLocation.h"
#import <AddressBook/AddressBook.h>

@interface MyLocation ()
@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) CLLocationCoordinate2D theCoordinate;
@end

@implementation MyLocation

@synthesize coordinate;
@synthesize title;
@synthesize subtitle;
@synthesize string;
@synthesize latitude,longitude;
@synthesize taste,temp;

- (id)initWithLocation:(CLLocationCoordinate2D)coord {
    self = [super init];
    if (self) {
        coordinate = coord;
    }
    return self;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
    coordinate = newCoordinate;
}



- (MKMapItem*)mapItem {
    
    NSDictionary *addressDict = @{(NSString*)kABPersonAddressStreetKey : _address};
    
    MKPlacemark *placemark = [[MKPlacemark alloc]
                              initWithCoordinate:self.coordinate
                              addressDictionary:addressDict];
    
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    mapItem.name = self.title;
    
    return mapItem;
}
@end