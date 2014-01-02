//
//  FountainDetail.m
//  WateringHole
//
//  Created by Ben Thomson on 12/30/13.
//  Copyright (c) 2013 Gizmomake. All rights reserved.
//

#import "FountainDetail.h"
#import "AddRating.h"

#define METERS_PER_MILE 1609.344

@interface FountainDetail ()
@property (nonatomic,strong) NSArray *taste_json;
@property (nonatomic,strong) NSArray *temp_json;

@end

@implementation FountainDetail
@synthesize latitude,longitude,address,taste,temp,mapView,taste_num,temp_num,taste_json,temp_json;
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
    bannerView_ = [[GADBannerView alloc] initWithFrame:CGRectMake(0.0,
                                                                  self.view.frame.size.height -
                                                                  GAD_SIZE_320x50.height,
                                                                  GAD_SIZE_320x50.width,
                                                                  GAD_SIZE_320x50.height)];
    // Specify the ad's "unit identifier". This is your AdMob Publisher ID.
    bannerView_.adUnitID = @"a152c4ce721c65a";
    
    // Let the runtime know which UIViewController to restore after taking
    // the user wherever the ad goes and add it to the view hierarchy.
    bannerView_.rootViewController = self;
    [self.view addSubview:bannerView_];
    
    // Initiate a generic request to load it with an ad.
    [bannerView_ loadRequest:[GADRequest request]];

    self.navigationItem.title = address;
    // 1
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = latitude.doubleValue;
    zoomLocation.longitude = longitude.doubleValue;
    // 2
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.03*METERS_PER_MILE, 0.03*METERS_PER_MILE);
    
    // 3
    [mapView setRegion:viewRegion animated:YES];
    
    ann = [[MyLocation alloc]initWithLocation:CLLocationCoordinate2DMake(latitude.doubleValue,longitude.doubleValue)];
    [mapView addAnnotation:ann];
    
    NSString  *url = [NSString stringWithFormat:@"http://twythm.com/gizmomake/wateringhole/ratings.php?latitude=%@&longitude=%@", latitude, longitude];
    NSURL *JSON  = [NSURL URLWithString:url];
    NSData* data = [NSData dataWithContentsOfURL: JSON];
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:data
                          
                          options:kNilOptions
                          error:&error];
    
    NSArray* json_users = [json objectForKey:@"Ratings"];
    
    
    NSMutableArray *taste_array = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *temp_array = [[NSMutableArray alloc] initWithCapacity:0];

    
    
    for (NSDictionary *table in json_users)
    {
        [taste_array insertObject:[table valueForKey:@"taste"] atIndex:0];
        [temp_array insertObject:[table valueForKey:@"temp"] atIndex:0];

        
        
    }
    self.taste_json = [taste_array copy];
    self.temp_json = [temp_array copy];
    
    temp_num = [self.taste_json objectAtIndex:0];
    taste_num = [self.temp_json objectAtIndex:0];

    
    taste.progress  = taste_num.floatValue;
    temp.progress   = temp_num.floatValue;
    
    }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)addrating:(id)sender {
    
    AddRating *dvc = [self.storyboard instantiateViewControllerWithIdentifier:@"AddRating"];
    dvc.latitude =  latitude;
    dvc.longitude = longitude;
    
    [self.navigationController pushViewController:dvc animated:YES];
}
@end
