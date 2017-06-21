//
//  DetailViewController.m
//  CatMap
//
//  Created by Jimmy Hoang on 2017-06-20.
//  Copyright © 2017 Jimmy Hoang. All rights reserved.
//

#import "DetailViewController.h"
#import "FlickrDownloadManager.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    FlickrDownloadManager* downloadManager = [[FlickrDownloadManager alloc] init];
    self.navigationItem.title = self.flickrPhoto.title;
    
    [downloadManager getPhotoLocation:self.flickrPhoto completion:^{
        CLLocationCoordinate2D photoLocation = self.flickrPhoto.coordinate;
        int radius = 1000;
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(photoLocation, radius*2, radius*2);
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
            [self.mapView setRegion:region];
            [self.mapView addAnnotation:self.flickrPhoto];
        }];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
