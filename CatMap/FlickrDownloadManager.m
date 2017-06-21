//
//  FlickrDownloadManager.m
//  CatMap
//
//  Created by Jimmy Hoang on 2017-06-20.
//  Copyright © 2017 Jimmy Hoang. All rights reserved.
//

#import "FlickrDownloadManager.h"

@implementation FlickrDownloadManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _downloadedPhotos = [NSMutableArray array];
    }
    return self;
}

-(NSURL*)getURLWithTags:(NSString *)tags {
    NSString* ammendedTags = [tags stringByReplacingOccurrencesOfString:@"," withString:@"%%2C"];

    NSURLComponents* components = [[NSURLComponents alloc] init];
    components.scheme = @"https";
    components.host = @"api.flickr.com";
    components.path = @"/services/rest/";
    components.query = [NSString stringWithFormat:@"method=flickr.photos.search&api_key=27bfb2c750d8d85682e0b6580398c7ab&tags=%@&has_geo=TRUE&extras=url_m&format=json&nojsoncallback=1",ammendedTags];
    
    NSURL* url = components.URL;

    return url;
}

-(NSURL*)getURLWithTags:(NSString*)tags andLocation:(CLLocation*)location {
    NSString* ammendedTags = [tags stringByReplacingOccurrencesOfString:@"," withString:@"%%2C"];
    
    NSURLComponents* components = [[NSURLComponents alloc] init];
    components.scheme = @"https";
    components.host = @"api.flickr.com";
    components.path = @"/services/rest/";
    components.query = [NSString stringWithFormat:@"method=flickr.photos.search&api_key=27bfb2c750d8d85682e0b6580398c7ab&tags=%@&accuracy=6&lat=%f&lon=%f&radius=20&extras=url_m&format=json&nojsoncallback=1",ammendedTags,location.coordinate.latitude,location.coordinate.longitude];
    
    NSURL* url = components.URL;
    
    return url;
}

-(void)fetchPhotos:(NSURL*)url completion:(void (^__nullable)(void))completion {
    NSURLRequest* urlRequest = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLSessionConfiguration* configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:configuration];
    
    NSURLSessionDataTask* downloadTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"fetch photos error: %@", error.localizedDescription);
        }
        
        NSError* jsonError;
        NSDictionary* photos = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        if (jsonError) {
            NSLog(@"fetch photos json error: %@",jsonError.localizedDescription);
            return;
        }
        
        NSDictionary* photos2 = [photos objectForKey:@"photos"];
        NSArray* photoArray = [photos2 objectForKey:@"photo"];
        
        for (NSDictionary* dictionary in photoArray) {
            [self.downloadedPhotos addObject:[[FlickrPhoto alloc] initWithPhoto:dictionary]];
        }
        
    }];
    [downloadTask resume];
}

-(void)fetchPhotosWithLocation:(CLLocation*)location andURL:(NSURL*)url completion:(void (^__nullable)(void))completion {
    NSURLRequest* urlRequest = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLSessionConfiguration* configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:configuration];
    
    NSURLSessionDataTask* downloadTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
       
        if (error) {
            NSLog(@"fetch photos with location error: %@",error.localizedDescription);
            return;
        }
        
        NSError* jsonError;
        NSDictionary* photos = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        if (jsonError) {
            NSLog(@"fetch photos with location json error: %@",jsonError.localizedDescription);
            return;
        }
        
        NSDictionary* photos2 = [photos objectForKey:@"photos"];
        NSArray* photoArray = [photos2 objectForKey:@"photo"];
        
        for (NSDictionary* dictionary in photoArray) {
            [self.downloadedPhotos addObject:[[FlickrPhoto alloc] initWithPhoto:dictionary]];
        }

    }];
    
    
    [downloadTask resume];
}

-(void)getPhotoLocation:(FlickrPhoto*)photo completion:(void (^__nullable)(void))completion {
    NSURLComponents* components = [[NSURLComponents alloc] init];
    components.scheme = @"https";
    components.host = @"api.flickr.com";
    components.path = @"/services/rest/";
    components.query = [NSString stringWithFormat:@"method=flickr.photos.geo.getLocation&api_key=27bfb2c750d8d85682e0b6580398c7ab&photo_id=%@&format=json&nojsoncallback=1",photo.photoID];
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
        
        photo.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    }];
    [getCoords resume];
}

@end
