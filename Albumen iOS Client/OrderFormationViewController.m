//
//  OrderFormationViewController.m
//  Albumen iOS Client
//
//  Created by Bakytzhan Baizhikenov on 2/18/15.
//  Copyright (c) 2015 intellection. All rights reserved.
//

#import "OrderFormationViewController.h"
#import <Parse/Parse.h>
#import "PhotoController.h"

@interface OrderFormationViewController ()
@property (strong, nonatomic) IBOutlet UIProgressView *photoUploadProgressView;
@property (strong, nonatomic) IBOutlet UIProgressView *singlePhotoUploadProgressView;
@property (strong, nonatomic) IBOutlet UITextField *phoneTextField;
@property (strong, nonatomic) IBOutlet UITextField *addressTextField;
@property (strong, nonatomic) IBOutlet UIButton *orderButton;
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) NSMutableArray *photos;
@property (strong, nonatomic) PFObject *albumObject;
@property (weak, nonatomic) IBOutlet UILabel *numberUploadedLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalNumberLabel;
@property (strong, nonatomic) IBOutlet UIImageView *currentPhotoImageView;

@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightImageViewConstraint;

@property (nonatomic) BOOL isCancelled;

@end

@implementation OrderFormationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.photoUploadProgressView.progress = 0.0;
    
    self.albumObject = [PFObject objectWithClassName:@"Album"];
    
    self.orderButton.enabled = NO;
    self.orderButton.alpha = 0.5;
    
    self.isCancelled = false;
    
    if ([UIScreen mainScreen].bounds.size.height == 480) {
        NSLog(@"iPhone 4");
        self.heightImageViewConstraint.constant = 0;
        self.singlePhotoUploadProgressView.hidden = YES;
    }
    
    [self getPrice];
    [self startUpload];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dismissKeyboard {
    [self.phoneTextField resignFirstResponder];
    [self.addressTextField resignFirstResponder];
    [self.nameTextField resignFirstResponder];
}

-(void) getPrice
{
    PFQuery *query = [PFQuery queryWithClassName:@"Const"];
    query.limit = 1;
    [query whereKey:@"key" equalTo:@"price"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error && ([objects count] > 0)) {
            PFObject *object = objects[0];
            NSLog(@"price is %@", [object objectForKey:@"intValue"]);
            self.priceLabel.text = [NSString stringWithFormat:@"%@ тг", [object objectForKey:@"intValue"]];
        }
    }];
}

-(void) uploadIndivPhotoAtIndex: (int) index
{
    Photo *photo = self.photos[index];
    
    [PhotoController getPhoto:photo withCompletedBlock:^(UIImage *image) {
            self.currentPhotoImageView.image = image;
            NSData *imageData = UIImageJPEGRepresentation(image, 100);
            PFFile *imageFile = [PFFile fileWithName:@"image.jpeg" data:imageData];
            self.singlePhotoUploadProgressView.progress = 0.0;
        
            [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (self.isCancelled) {
                    // stop uploading
                    NSLog(@"Cancelled order formation after uploading %d photos", index + 1);
                    return;
                }
                if (succeeded) {
                    double progress = (((index+1) * 1.0) / [self.photos count]);
                    self.photoUploadProgressView.progress = progress;
                    self.numberUploadedLabel.text = [NSString stringWithFormat:@"%d", index+1, nil];
                    [self.albumObject addObject:imageFile forKey:@"photos"];
                
                    if ((index+1) < [self.photos count]) {
                        [self uploadIndivPhotoAtIndex:index+1];
                    } else {
                        self.orderButton.enabled = YES;
                        self.orderButton.alpha = 1.0;
                    }
                } else {
                    NSLog(@"Some errors");
                }
            }progressBlock:^(int percentDone) {
                self.singlePhotoUploadProgressView.progress = percentDone * 1.0 / 100.0;
            }];

    }];
}

-(void) startUpload
{
    NSSet *unorderedPhotos = self.album.photos;
    
    NSSortDescriptor *dateDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
    NSArray *sortedPhotos = [unorderedPhotos sortedArrayUsingDescriptors:@[dateDescriptor]];
    self.photos = [sortedPhotos mutableCopy];
    
    self.totalNumberLabel.text = [NSString stringWithFormat:@"из %lu", (unsigned long)[self.album.photos count], nil];
    
    self.numberUploadedLabel.text = @"0";

    if ([self.photos count] > 0 ) {
        self.currentPhotoImageView.contentMode = UIViewContentModeScaleAspectFit;
        self.currentPhotoImageView.clipsToBounds = YES;
        [self uploadIndivPhotoAtIndex:0];
    }
}



- (IBAction)cancelButtonPressed:(UIBarButtonItem *)sender {
    self.isCancelled = true;
    [self.delegate orderFormationDidCancel];
}


- (IBAction)orderButtonPressed:(UIButton *)sender {
    
    NSString *name = self.nameTextField.text;
    NSString *phone = self.phoneTextField.text;
    NSString *address = self.addressTextField.text;
    
    if ([name isEqualToString:@""] || [phone isEqualToString:@""] || [address isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Пустые поля" message:@"Пожалуйста, заполните все поля." delegate:nil cancelButtonTitle: @"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    [self.albumObject setObject:self.album.title forKey:@"albumTitle"];
    [self.albumObject setObject:name forKey: @"clientName"];
    [self.albumObject setObject:phone forKey: @"clientPhone"];
    [self.albumObject setObject:address forKey: @"clientAddress"];
    
    [self.albumObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [self.delegate orderFormationDidPlace];
        }
    }];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
