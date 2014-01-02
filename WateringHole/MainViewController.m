//
//  MainViewController.m
//  WateringHole
//
//  Created by Ben Thomson on 12/29/13.
//  Copyright (c) 2013 Gizmomake. All rights reserved.
//

#import "MainViewController.h"
#import "AddViewController.h"
#import "FountainDetail.h"
#import "ASIHTTPRequest.h"


#define METERS_PER_MILE 1609.344

@interface MainViewController ()
@property (strong, nonatomic) NSArray *latitude;
@property (strong, nonatomic) NSArray *longitude;
@property (strong, nonatomic) NSArray *name;

@end

@implementation MainViewController
@synthesize mapView,label;
- (void)viewDidLoad
{
    [super viewDidLoad];
    


    locationManager = [[CLLocationManager alloc] init];
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [locationManager startUpdatingLocation];

    
    // 1
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = locationManager.location.coordinate.latitude;
    zoomLocation.longitude = locationManager.location.coordinate.longitude;
    
    // 2
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 2*METERS_PER_MILE, 2*METERS_PER_MILE);
    
    // 3
    [mapView setRegion:viewRegion animated:YES];
    
    // 1
    MKCoordinateRegion mapRegion = [mapView region];
    CLLocationCoordinate2D centerLocation = mapRegion.center;

    // 2
    NSString *jsonFile = [[NSBundle mainBundle] pathForResource:@"command" ofType:@"json"];
    NSString *formatString = [NSString stringWithContentsOfFile:jsonFile encoding:NSUTF8StringEncoding error:nil];
   NSString *json = [NSString stringWithFormat:formatString,centerLocation.latitude, centerLocation.longitude, 0.5*METERS_PER_MILE];
 
    // 3
    NSURL *url = [NSURL URLWithString:@"http://twythm.com/gizmomake/wateringhole/json.php"];
    
    // 4
    ASIHTTPRequest *_request = [ASIHTTPRequest requestWithURL:url];
    __weak ASIHTTPRequest *request = _request;
    
    request.requestMethod = @"POST";
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request appendPostData:[json dataUsingEncoding:NSUTF8StringEncoding]];
    // 5
    [request setDelegate:self];
    [request setCompletionBlock:^{
        NSString *responseString = [request responseString];
        NSLog(@"Response: %@", responseString);
        [self plotPoints:request.responseData];

    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        NSLog(@"Error: %@", error.localizedDescription);
    }];
    
    // 6
    [request startAsynchronous];
 
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}
- (void)plotPoints:(NSData *)responseData {
    for (id<MKAnnotation> annotation in mapView.annotations) {
        [mapView removeAnnotation:annotation];
    }
    
    NSDictionary *root = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
    NSArray *data = [root objectForKey:@"Fountains"];
    for (NSArray *row in data) {

        NSString *latitude = [row valueForKey:@"latitude"];
        NSString *longitude = [row valueForKey:@"longitude"];
        NSString *address = [row valueForKey:@"address"];
        NSString *taste = [row valueForKey:@"taste"];
        NSString *temp = [row valueForKey:@"temp"];

        
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = latitude.doubleValue;
        coordinate.longitude = longitude.doubleValue;
        ann = [[MyLocation alloc]initWithLocation:CLLocationCoordinate2DMake(latitude.doubleValue,longitude.doubleValue)];
        ann.title = @"Water Fountain";
        ann.subtitle = address;
        ann.latitude = latitude;
        ann.longitude = longitude;
        ann.taste     = taste;
        ann.temp      = temp;
        [mapView addAnnotation:ann];
	}
}
- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

- (IBAction)currentloc:(id)sender {
    // 1
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = locationManager.location.coordinate.latitude;
    zoomLocation.longitude = locationManager.location.coordinate.longitude;
    NSLog(@"%f,%f",zoomLocation.latitude,zoomLocation.longitude);
    // 2
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 2*METERS_PER_MILE, 2*METERS_PER_MILE);
    
    // 3
    [mapView setRegion:viewRegion animated:YES];
    
    [super viewDidLoad];
}
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    static NSString *identifier = @"MyLocation";
    if ([annotation isKindOfClass:[MyLocation class]]) {
        
        MKAnnotationView *annotationView = (MKAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
            annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            annotationView.image = [UIImage imageNamed:@"pin.png"];//here we use a nice image instead of the default pins
        } else {
            annotationView.annotation = annotation;
        }
        
        return annotationView;
    }
    
    return nil;
}

- (IBAction)add:(id)sender {

    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
    CLLocation *location = [locationManager location];
    // Configure the new event with information from the location
    CLLocationCoordinate2D coordinate = [location coordinate];
    NSString *latitude = [NSString stringWithFormat:@"%f", coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f", coordinate.longitude];
    
    [mapView removeAnnotations:mapView.annotations];

    
    AddViewController *dvc = [self.storyboard instantiateViewControllerWithIdentifier:@"AddViewController"];
    dvc.latitude =  latitude;
    dvc.longitude = longitude;
    [self.navigationController pushViewController:dvc animated:YES];
}

- (IBAction)refresh:(id)sender {
    
    // 1
    MKCoordinateRegion mapRegion = [mapView region];
    CLLocationCoordinate2D centerLocation = mapRegion.center;
    
    // 2
    NSString *jsonFile = [[NSBundle mainBundle] pathForResource:@"command" ofType:@"json"];
    NSString *formatString = [NSString stringWithContentsOfFile:jsonFile encoding:NSUTF8StringEncoding error:nil];
    NSString *json = [NSString stringWithFormat:formatString,centerLocation.latitude, centerLocation.longitude, 0.5*METERS_PER_MILE];
    
    // 3
    NSURL *url = [NSURL URLWithString:@"http://twythm.com/gizmomake/wateringhole/json.php"];
    
    // 4
    ASIHTTPRequest *_request = [ASIHTTPRequest requestWithURL:url];
    __weak ASIHTTPRequest *request = _request;
    
    request.requestMethod = @"POST";
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request appendPostData:[json dataUsingEncoding:NSUTF8StringEncoding]];
    // 5
    [request setDelegate:self];
    [request setCompletionBlock:^{
        NSString *responseString = [request responseString];
        NSLog(@"Response: %@", responseString);
        [self plotPoints:request.responseData];
        
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        NSLog(@"Error: %@", error.localizedDescription);
    }];
    
    // 6
    [request startAsynchronous];

}

- (void)mapView:(MKMapItem *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
    MyLocation *location = (MyLocation*)view.annotation;
    NSString *lat = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
    NSString *lon = [NSString stringWithFormat:@"%f",location.coordinate.longitude];

    FountainDetail *dvc = [self.storyboard instantiateViewControllerWithIdentifier:@"FountainDetail"];
    dvc.latitude =  lat;
    dvc.longitude = lon;
    
    [self.navigationController pushViewController:dvc animated:YES];
}


@end
