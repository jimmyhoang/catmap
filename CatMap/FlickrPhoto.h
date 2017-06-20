//
//  FlickrPhoto.h
//  CatMap
//
//  Created by Jimmy Hoang on 2017-06-20.
//  Copyright © 2017 Jimmy Hoang. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;
@import MapKit;

@interface FlickrPhoto : NSObject <MKAnnotation>

@property (nonatomic, strong) NSURL* url;
@property (nonatomic, strong) NSNumber* photoID;
@property (nonatomic, strong) UIImage* photo;
@property (nonatomic, copy) NSString* title;
@property (nonatomic) CLLocationCoordinate2D coordinate;


- (instancetype)initWithPhoto:(NSDictionary*)photo;

@end
