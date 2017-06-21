//
//  ShowAllViewController.m
//  CatMap
//
//  Created by Jimmy Hoang on 2017-06-20.
//  Copyright © 2017 Jimmy Hoang. All rights reserved.
//

#import "ShowAllViewController.h"
#import "FlickrDownloadManager.h"

@interface ShowAllViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) FlickrDownloadManager* downloadManager;

@end

@implementation ShowAllViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"All Photo Locations";
    self.downloadManager = [[FlickrDownloadManager alloc] init];
    self.flickrPhotos = [NSMutableArray array];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setup
-(void)getGeoLocation {
    for (FlickrPhoto* photo in self.flickrPhotos) {
        [self.downloadManager getPhotoLocation:photo completion:nil];
    }
    
    [self.mapView addAnnotations:self.flickrPhotos];

}
    
@end
