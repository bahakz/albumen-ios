//
//  AlbumDetailCollectionViewController.m
//  Albumen iOS Client
//
//  Created by Bakytzhan Baizhikenov on 2/16/15.
//  Copyright (c) 2015 intellection. All rights reserved.
//

#import "AlbumDetailCollectionViewController.h"
#import "PhotoCollectionViewCell.h"
#import "Photo.h"
#import "OrderFormationViewController.h"
#import "SinglePhotoViewController.h"
#import "ELCImagePickerController.h"
#import "OrderConfirmationViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "PhotoController.h"


@interface AlbumDetailCollectionViewController () <ELCImagePickerControllerDelegate, OrderFormationViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UINavigationItem *topNavigationItem;
@property (strong, nonatomic) IBOutlet UILabel *leftPhotosLabel;
@property (strong, nonatomic) IBOutlet UIButton *orderButton;

@end

@implementation AlbumDetailCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.topNavigationItem.title = self.album.title;
    
    NSSet *unorderedPhotos = self.album.photos;
    
    NSSortDescriptor *dateDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
    NSArray *sortedPhotos = [unorderedPhotos sortedArrayUsingDescriptors:@[dateDescriptor]];
    self.photos = [sortedPhotos mutableCopy];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    self.leftPhotosLabel.text = [NSString stringWithFormat:@"Осталось фотографии: %u", [self.album.capacity intValue] - [self.photos count]];
    
    // Register cell classes
    [self.collectionView registerClass:[PhotoCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
}


-(void)viewWillAppear:(BOOL)animated
{
    NSSet *unorderedPhotos = self.album.photos;
    
    NSSortDescriptor *dateDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
    NSArray *sortedPhotos = [unorderedPhotos sortedArrayUsingDescriptors:@[dateDescriptor]];
    self.photos = [sortedPhotos mutableCopy];
    
    [self.collectionView reloadData];
    
    if ([self.photos count] == 0) {
        self.orderButton.enabled = NO;
    } else {
        self.orderButton.enabled = YES; 
    }
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

 #pragma mark - Navigation
 
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     
     
     if ([segue.destinationViewController isKindOfClass:[OrderFormationViewController class]]) {
         OrderFormationViewController *nextController = segue.destinationViewController;
         nextController.album = self.album;
         nextController.delegate = self;
     }
     
     if ([segue.destinationViewController isKindOfClass:[SinglePhotoViewController class]]) {
         NSIndexPath *indexPath = sender;
         SinglePhotoViewController *nextController = segue.destinationViewController;
         nextController.photo = self.photos[indexPath.row];
     }
     
 }

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"toSinglePhotoVC" sender:indexPath];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.photos count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    Photo *photo = self.photos[indexPath.row];
    [PhotoController getPhoto:photo withCompletedBlock:^(UIImage *image) {
        cell.imageView.image = image;
    }];
    
    return cell;
}

- (Photo *)photoFromImageURL:(NSURL *)imageURL
{
    Photo *photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:[self.album managedObjectContext]];
    photo.imageURL = [imageURL absoluteString];
    photo.date = [NSDate date];
    photo.albumBook = self.album;
    NSError *error = nil;
    if (![[photo managedObjectContext] save:&error]) {
        NSLog(@"something bad happend %@", error);
        return nil;
    }
    
    return photo;
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - order formation methods

-(void)orderFormationDidCancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)orderFormationDidPlace
{
    [self dismissViewControllerAnimated:YES completion:nil];
    OrderConfirmationViewController *nextController = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderConfirmationVC"];
    [self presentViewController:nextController animated:YES completion:nil];
}


#pragma mark ELCImagePickerController delegate methods
-(void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    for (int i=0; i < [info count]; i++) {
        NSDictionary *dict = info[i];
        
        NSURL *imageURL = dict[UIImagePickerControllerReferenceURL];
        [self.photos addObject:[self photoFromImageURL:imageURL]];
    }
    
    [self.collectionView reloadData];
    self.leftPhotosLabel.text = [NSString stringWithFormat:@"Осталось фотографии: %lu", (long)[self.album.capacity intValue] - [self.photos count]];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark button actions

- (IBAction)addPhotoButtonPressed:(UIBarButtonItem *)sender {
    
    ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
    elcPicker.maximumImagesCount = [self.album.capacity intValue] - [self.photos count]; //Set the maximum number of images to select, defaults to 4
    elcPicker.returnsOriginalImage = YES; //Only return the fullScreenImage, not the fullResolutionImage
    elcPicker.returnsImage = NO; //Return UIimage if YES. If NO, only return asset location information
    elcPicker.onOrder = YES; //For multiple image selection, display and return selected order of images
    elcPicker.imagePickerDelegate = self;
    
    //Present modally
    [self presentViewController:elcPicker animated:YES completion:nil];
    
    // Release if not using ARC
//    [elcPicker release];
    
    
//    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//    picker.delegate = self;
//    
//    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
//    } else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
//        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
//    }
//    
//    [self presentViewController:picker animated:YES completion:nil];

}


@end
