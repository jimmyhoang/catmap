//
//  ShowAllViewController.h
//  CatMap
//
//  Created by Jimmy Hoang on 2017-06-20.
//  Copyright © 2017 Jimmy Hoang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlickrPhoto.h"
@import MapKit;

@interface ShowAllViewController : UIViewController

@property (nonatomic, strong) FlickrPhoto* flickrPhoto;
@property (nonatomic, strong) NSMutableArray<FlickrPhoto *>* flickrPhotos;

@end
