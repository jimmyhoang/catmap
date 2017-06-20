//
//  DetailViewController.m
//  CatMap
//
//  Created by Jimmy Hoang on 2017-06-20.
//  Copyright © 2017 Jimmy Hoang. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) CLLocationCoordinate2D photoLocation;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.flickrPhoto.title;
    [self getGeoLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setup
-(void)getGeoLocation {
    NSURLComponents* components = [[NSURLComponents alloc] init];
    components.scheme = @"https";
    components.host = @"api.flickr.com";
    components.path = @"/services/rest/";
    components.query = [NSString stringWithFormat:@"method=flickr.photos.geo.getLocation&api_key=27bfb2c750d8d85682e0b6580398c7ab&photo_id=%@&format=json&nojsoncallback=1",self.flickrPhoto.photoID];
    NSURL* url = components.URL;
    
    NSURLRequest* urlRequest = [[NSURLRequest alloc] initWithURL:url];
    NSURLSessionConfiguration* configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:configuration];
    
    NSURLSessionDataTask* getCoords = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"error getting location: %@",error.localizedDescription);
            return;
        }
        
        NSError* jsonError = nil;
        
        NSDictionary* initialDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        NSDictionary* photoDictionary = initialDictionary[@"photo"];
        NSDictionary* locationDictionary = photoDictionary[@"location"];
        
        NSNumber* jsonLatitude = locationDictionary[@"latitude"];
        NSNumber* jsonLongitude = locationDictionary[@"longitude"];

        double latitude = [jsonLatitude doubleValue];
        double longitude = [jsonLongitude doubleValue];
        
        self.flickrPhoto.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        self.photoLocation = self.flickrPhoto.coordinate;
        [self setupMap];
    }];
    [getCoords resume];
}

-(void)setupMap {
    
    int radius = 1000;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.photoLocation, radius*2, radius*2);
    [self.mapView setRegion:region];
    [self.mapView addAnnotation:self.flickrPhoto];
}

@end
