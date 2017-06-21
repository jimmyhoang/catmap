//
//  SearchViewController.m
//  CatMap
//
//  Created by Jimmy Hoang on 2017-06-20.
//  Copyright © 2017 Jimmy Hoang. All rights reserved.
//

#import "SearchViewController.h"
#import "FlickrDownloadManager.h"
#import "FlickrPhoto.h"

@import CoreLocation;

@interface SearchViewController () <CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *tagsTextField;
@property (weak, nonatomic) IBOutlet UISwitch *switchButton;
@property (nonatomic, strong) FlickrDownloadManager* flickrDownloadManager;
@property (nonatomic, strong) CLLocationManager* locationManager;
@property (nonatomic, strong) CLLocation* currentLocation;
@property (nonatomic, strong) NSMutableArray* flickrPhotos;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.flickrDownloadManager = [[FlickrDownloadManager alloc] init];
    self.locationManager = [[CLLocationManager alloc] init];
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [self.view addGestureRecognizer:tapGesture];
    
    self.locationManager.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions
- (IBAction)saveButtonPressed:(id)sender {
    NSString* tag = self.tagsTextField.text;
    
    if (self.switchButton.on) {
        [self searchWithUserLocation:tag];
    } else {
        [self searchNormal:tag];
    }
    
    [self.delegate userDidPressSave:self.flickrPhotos];
}
- (IBAction)cancelButtonPressed:(id)sender {
    [self.delegate userDidPressCancel];
}

#pragma mark - Gesture Recognizer
-(void)dismissKeyboard:(UITapGestureRecognizer*)sender {
    [self.view endEditing:YES];
}

#pragma mark - Fetch Images
-(void)searchWithUserLocation:(NSString*)searchTag {
    [self getUserLocation];
    [self.flickrDownloadManager fetchPhotosWithLocation:self.currentLocation andURL:[self.flickrDownloadManager getURLWithTags:searchTag andLocation:self.currentLocation] completion:^{
        self.flickrPhotos = self.flickrDownloadManager.downloadedPhotos;
    }];
}

-(void)searchNormal:(NSString*)searchTag {
    [self.flickrDownloadManager fetchPhotos:[self.flickrDownloadManager getURLWithTags:searchTag] completion:^{
        self.flickrPhotos = self.flickrDownloadManager.downloadedPhotos;
    }];
}

#pragma mark - Location
-(void)getUserLocation {
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager requestLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    if (self.currentLocation != locations[0]) {
        self.currentLocation = locations[0];
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Error getting location: %@",error.localizedDescription);
}

@end
