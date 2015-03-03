//
//  Photo.h
//  Albumen iOS Client
//
//  Created by Bakytzhan Baizhikenov on 2/20/15.
//  Copyright (c) 2015 intellection. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Album;

@interface Photo : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) id image;
@property (nonatomic, retain) Album *albumBook;

@end
