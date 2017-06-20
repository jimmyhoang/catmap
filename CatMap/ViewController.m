//
//  ViewController.m
//  CatMap
//
//  Created by Jimmy Hoang on 2017-06-20.
//  Copyright © 2017 Jimmy Hoang. All rights reserved.
//

#import "ViewController.h"
#import "PhotoCollectionViewCell.h"
#import "DetailViewController.h"
#import "FlickrPhoto.h"

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) NSMutableArray* flickrPhotos;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) FlickrPhoto* currentlySelectedPhoto;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.flickrPhotos = [NSMutableArray array];
    [self fetchPhotos:[self getURL]];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setup
-(NSURL*)getURL {
    NSURLComponents* url = [[NSURLComponents alloc] initWithString:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=27bfb2c750d8d85682e0b6580398c7ab&tags=cat&has_geo=TRUE&extras=url_m&format=json&nojsoncallback=1"];
    
    return [url URL];
}

-(void)fetchPhotos:(NSURL*)url {
    
    NSURLRequest* urlRequest = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLSessionConfiguration* configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:configuration];
  
    NSURLSessionDataTask* downloadTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"error downloading data: %@", error.localizedDescription);
        }
        
        NSError* jsonError;
        NSDictionary* photos = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        if (jsonError) {
            NSLog(@"json error: %@",jsonError.localizedDescription);
            return;
        }
        
        NSDictionary* photos2 = [photos objectForKey:@"photos"];
        NSArray* photoArray = [photos2 objectForKey:@"photo"];
        
        for (NSDictionary* dictionary in photoArray) {
            [self.flickrPhotos addObject:[[FlickrPhoto alloc] initWithPhoto:dictionary]];
        }
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
            [self.collectionView reloadData];
        }];
    }];
    
    [downloadTask resume];
}

#pragma mark - Collection View
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.flickrPhotos.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photoCell" forIndexPath:indexPath];
    cell.photoImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    FlickrPhoto* photo = self.flickrPhotos[indexPath.row];
    
    if (!photo.photo) {
        NSData *data = [NSData dataWithContentsOfURL:photo.url];
        UIImage *downloadedPhoto = [UIImage imageWithData:data];
        photo.photo = downloadedPhoto;
        cell.photoImageView.image = downloadedPhoto;
    } else {
        cell.photoImageView.image = photo.photo;
    }
    
    cell.photoDescriptionLabel.text = photo.title;

    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.currentlySelectedPhoto = self.flickrPhotos[indexPath.row];
    [self performSegueWithIdentifier:@"showDetail" sender:self];
}

#pragma mark - Navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"showDetail"]) {
        DetailViewController* detailVC = (DetailViewController*)segue.destinationViewController;
        detailVC.flickrPhoto = self.currentlySelectedPhoto;
    }
    
}


@end
