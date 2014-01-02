//
//  AddRating.m
//  WateringHole
//
//  Created by Ben Thomson on 1/1/14.
//  Copyright (c) 2014 Gizmomake. All rights reserved.
//

#import "AddRating.h"
#import "FountainDetail.h"
@interface AddRating ()

@end

@implementation AddRating
@synthesize taste,temp;

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

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submit:(id)sender {
    
    NSString *taste_num = [NSString stringWithFormat:@"%f", taste.value];
    NSString *temp_num = [NSString stringWithFormat:@"%f", temp.value];
    
    
    NSString *strUrl=@"http://Twythm.com/gizmomake/wateringhole/addrating.php";
    NSURL *url=[NSURL URLWithString:strUrl];
    
    NSMutableURLRequest *request = [NSMutableURLRequest  requestWithURL:url
                                                            cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                        timeoutInterval:130.0];

    
    
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
    

    
    
    
    
    [ request setHTTPMethod: @"POST" ];
    
    [ request setHTTPBody: myRequestData ];
    NSURLResponse *response;
    NSError *error;
    NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse:&response error:&error];
    NSLog(@"%@",returnData);
    
    FountainDetail *dvc = [self.storyboard instantiateViewControllerWithIdentifier:@"FountainDetail"];
    dvc.latitude =  self.latitude;
    dvc.longitude = self.longitude;
    
[self.navigationController popToRootViewControllerAnimated:YES];
}

@end
