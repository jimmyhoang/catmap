//
//  FlickrPhoto.m
//  CatMap
//
//  Created by Jimmy Hoang on 2017-06-20.
//  Copyright © 2017 Jimmy Hoang. All rights reserved.
//

#import "FlickrPhoto.h"

@implementation FlickrPhoto

- (instancetype)initWithPhoto:(NSDictionary *)photo{
    self = [super init];
    if (self) {
        _title = photo[@"title"];
        _url = [[NSURL alloc] initWithString:photo[@"url_m"]];
        _photoID = photo[@"id"];
    }
    return self;
}


@end
