//
//  AddViewController.m
//  WateringHole
//
//  Created by Ben Thomson on 12/30/13.
//  Copyright (c) 2013 Gizmomake. All rights reserved.
//

#import "AddViewController.h"
#import "MyLocation.h"
#define METERS_PER_MILE 1609.344

@interface AddViewController ()
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) CLPlacemark *placemark;

@end

@implementation AddViewController
@synthesize latitude,longitude,mapView,taste,temp,placemark;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    double lat = latitude.doubleValue;
    double lon = longitude.doubleValue;
    

    
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = lat;
    coordinate.longitude = lon;
    
    MyLocation *ann = [[MyLocation alloc]initWithLocation:CLLocationCoordinate2DMake(latitude.doubleValue,longitude.doubleValue)];
    [mapView addAnnotation:ann];
    
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = lat;
    zoomLocation.longitude = lon;

    
    // 2
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.05*METERS_PER_MILE, 0.05*METERS_PER_MILE);
    
    // 3
    [mapView setRegion:viewRegion animated:YES];
    
    CLGeocoder *ceo = [[CLGeocoder alloc]init];
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:latitude.doubleValue longitude:longitude.doubleValue];
    
    [ceo reverseGeocodeLocation: loc completionHandler:
     ^(NSArray *placemarks, NSError *error) {
         placemark = [placemarks objectAtIndex:0];
         NSLog(@"placemark %@",placemark);
         //String to hold address
         NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
         NSLog(@"addressDictionary %@", placemark.addressDictionary);
         
         NSLog(@"placemark %@",placemark.region);
         NSLog(@"placemark %@",placemark.country);  // Give Country Name
         NSLog(@"placemark %@",placemark.locality); // Extract the city name
         NSLog(@"location %@",placemark.name);
         NSLog(@"location %@",placemark.ocean);
         NSLog(@"location %@",placemark.postalCode);
         NSLog(@"location %@",placemark.subLocality);
         
         NSLog(@"location %@",placemark.location);
         //Print the location to console
         NSLog(@"I am currently at %@",locatedAt);
         
         
         
     }
     
     ];

    
    }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)submit:(id)sender {
    NSString *strUrl=@"http://Twythm.com/gizmomake/wateringhole/fountain.php";
    NSURL *url=[NSURL URLWithString:strUrl];
    
    NSMutableURLRequest *request = [NSMutableURLRequest  requestWithURL:url
                                                            cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                        timeoutInterval:130.0];
    
    NSString *taste_num = [NSString stringWithFormat:@"%f", taste.value];
    NSString *temp_num = [NSString stringWithFormat:@"%f", temp.value];
    NSString *address  = [NSString stringWithFormat:@"%@, %@", placemark.name, placemark.locality];

    
    NSMutableData *myRequestData = [[NSMutableData alloc] init];
    NSString *boundary = @"--";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    [myRequestData appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [myRequestData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"latitude\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [myRequestData appendData:[self.latitude dataUsingEncoding:NSUTF8StringEncoding]];
    
    [myRequestData appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [myRequestData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"longitude\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [myRequestData appendData:[self.longitude dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [myRequestData appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [myRequestData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"taste\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [myRequestData appendData:[taste_num dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [myRequestData appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [myRequestData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"temp\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [myRequestData appendData:[temp_num dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [myRequestData appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [myRequestData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"address\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [myRequestData appendData:[address dataUsingEncoding:NSUTF8StringEncoding]];
    

    
    
    [ request setHTTPMethod: @"POST" ];
    
    [ request setHTTPBody: myRequestData ];
    NSURLResponse *response;
    NSError *error;
    NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse:&response error:&error];
    NSLog(@"%@",returnData);
    
    

}
@end
