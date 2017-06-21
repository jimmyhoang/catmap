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
#import "SearchViewController.h"
#import "ShowAllViewController.h"
#import "FlickrPhoto.h"
#import "FlickrDownloadManager.h"

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource,SearchViewControllerDelegate>
@property (nonatomic, strong) NSMutableArray* flickrPhotos;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) FlickrPhoto* currentlySelectedPhoto;
@property (nonatomic, strong) NSString* searchTag;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.flickrPhotos = [NSMutableArray array];
    self.navigationItem.title = @"Cat Maps";
    [self performSegueWithIdentifier:@"search" sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

    cell.photoImageView.image = photo.photo;
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
    
    if([segue.identifier isEqualToString:@"search"]) {
        SearchViewController* searchVC = (SearchViewController*)segue.destinationViewController;
        searchVC.delegate = self;
    }
    
    if([segue.identifier isEqualToString:@"showAll"]) {
        ShowAllViewController* showAllVC = (ShowAllViewController*)segue.destinationViewController;
        showAllVC.flickrPhotos = self.flickrPhotos;
    }
    
}

#pragma mark - SearchViewControllerDelegate
-(void)userDidPressCancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)userDidPressSave:(NSMutableArray*)photosArray {
    self.flickrPhotos = photosArray;
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
