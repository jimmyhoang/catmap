//
//  SearchViewController.h
//  CatMap
//
//  Created by Jimmy Hoang on 2017-06-20.
//  Copyright © 2017 Jimmy Hoang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchViewControllerDelegate <NSObject>

-(void)userDidPressSave:(NSMutableArray*)photosArray;
-(void)userDidPressCancel;

@end

@interface SearchViewController : UIViewController

@property (nonatomic, weak) id <SearchViewControllerDelegate> delegate;

@end
