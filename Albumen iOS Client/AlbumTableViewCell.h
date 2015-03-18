//
//  AlbumTableViewCell.h
//  Albumen iOS Client
//
//  Created by Bakytzhan Baizhikenov on 3/3/15.
//  Copyright (c) 2015 intellection. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlbumTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;

@end
