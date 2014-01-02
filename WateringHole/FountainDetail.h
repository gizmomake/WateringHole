//
//  FountainDetail.h
//  WateringHole
//
//  Created by Ben Thomson on 12/30/13.
//  Copyright (c) 2013 Gizmomake. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MyLocation.h"
@interface FountainDetail : UIViewController {
    MyLocation *ann;
}
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UIProgressView *taste;
@property (strong, nonatomic) IBOutlet UIProgressView *temp;


@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSNumber *taste_num;
@property (nonatomic, strong) NSNumber *temp_num;

- (IBAction)addrating:(id)sender;

@end
