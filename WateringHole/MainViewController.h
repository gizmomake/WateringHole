//
//  MainViewController.h
//  WateringHole
//
//  Created by Ben Thomson on 12/29/13.
//  Copyright (c) 2013 Gizmomake. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MyLocation.h"
@interface MainViewController : UIViewController <MKMapViewDelegate>  {
    CLLocationManager *locationManager;
    MyLocation *ann;
}

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
- (IBAction)currentloc:(id)sender;
- (IBAction)add:(id)sender;
- (IBAction)refresh:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *label;

@end
