//
//  OrderFormationViewController.h
//  Albumen iOS Client
//
//  Created by Bakytzhan Baizhikenov on 2/18/15.
//  Copyright (c) 2015 intellection. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Album.h"
#import "Photo.h" 


@protocol OrderFormationViewControllerDelegate <NSObject>
-(void) orderFormationDidCancel;
-(void) orderFormationDidPlace;
@end

@interface OrderFormationViewController : UIViewController

@property (weak) id <OrderFormationViewControllerDelegate> delegate;
@property (strong, nonatomic) Album *album;

@end
