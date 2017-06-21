//
//  FlickrDownloadManager.h
//  CatMap
//
//  Created by Jimmy Hoang on 2017-06-20.
//  Copyright © 2017 Jimmy Hoang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlickrPhoto.h"

@interface FlickrDownloadManager : NSObject

@property (nonatomic, strong) NSMutableArray* _Nonnull downloadedPhotos;

-(void)fetchPhotos:(NSURL*_Nonnull)url completion:(void (^__nullable)(void))completion;
-(void)fetchPhotosWithLocation:(CLLocation*_Nonnull)location andURL:(NSURL*_Nonnull)url completion:(void (^__nullable)(void))completion;
-(NSURL*_Nonnull)getURLWithTags:(NSString*_Nonnull)tags andLocation:(CLLocation*_Nonnull)location;
-(NSURL*_Nonnull)getURLWithTags:(NSString*_Nonnull)tags;
-(void)getPhotoLocation:(FlickrPhoto*_Nonnull)photo completion:(void (^__nullable)(void))completion;
@end
