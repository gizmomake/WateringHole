//
//  AddRating.h
//  WateringHole
//
//  Created by Ben Thomson on 1/1/14.
//  Copyright (c) 2014 Gizmomake. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GADBannerView.h"
@interface AddRating : UIViewController {
    GADBannerView *bannerView_;

}

@property (strong, nonatomic) IBOutlet UISlider *taste;
@property (strong, nonatomic) IBOutlet UISlider *temp;

@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;

- (IBAction)submit:(id)sender;

@end
