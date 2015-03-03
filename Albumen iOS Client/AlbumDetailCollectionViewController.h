//
//  AlbumDetailCollectionViewController.h
//  Albumen iOS Client
//
//  Created by Bakytzhan Baizhikenov on 2/16/15.
//  Copyright (c) 2015 intellection. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Album.h"

@interface AlbumDetailCollectionViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *photos;
@property (strong, nonatomic) Album *album;

@end
