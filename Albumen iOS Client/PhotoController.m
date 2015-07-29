//
//  PhotoController.m
//  Albumen iOS Client
//
//  Created by Bakytzhan Baizhikenov on 6/29/15.
//  Copyright (c) 2015 intellection. All rights reserved.
//

#import "PhotoController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation PhotoController

+(void)getPhoto:(Photo *)photo withCompletedBlock:(void (^)(UIImage *))completed
{
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
    {
        CGImageRef iref = [myasset aspectRatioThumbnail];
        if (iref) {
            UIImage *image = [UIImage imageWithCGImage:iref];
            dispatch_async(dispatch_get_main_queue(), ^{
                //UIMethod trigger...
                completed(image);
            });
            iref = nil;
        }
    };
    
    ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
    {
        NSLog(@"Can't get image - %@",[myerror localizedDescription]);
    };
    
    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
    [assetslibrary assetForURL:[NSURL URLWithString:photo.imageURL]
                   resultBlock:resultblock
                  failureBlock:failureblock];
}

@end
