//
//  AddViewController.h
//  WateringHole
//
//  Created by Ben Thomson on 12/30/13.
//  Copyright (c) 2013 Gizmomake. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "GADBannerView.h"
#import <CoreLocation/CoreLocation.h>

@interface AddViewController : UIViewController {
    GADBannerView *bannerView_;

}
@property (nonatomic, strong) NSString *latitude;

@property (nonatomic, strong) NSString *longitude;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UISlider *taste;
@property (strong, nonatomic) IBOutlet UISlider *temp;
- (IBAction)submit:(id)sender;

@end
