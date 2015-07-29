//
//  PhotoController.h
//  Albumen iOS Client
//
//  Created by Bakytzhan Baizhikenov on 6/29/15.
//  Copyright (c) 2015 intellection. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Photo.h"
#import <UIKit/UIKit.h>

@interface PhotoController : NSObject

+(void) getPhoto:(Photo *) photo withCompletedBlock:(void(^)(UIImage *image))completed;

@end
