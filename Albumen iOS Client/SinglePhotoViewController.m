//
//  SinglePhotoViewController.m
//  Albumen iOS Client
//
//  Created by Bakytzhan Baizhikenov on 2/20/15.
//  Copyright (c) 2015 intellection. All rights reserved.
//

#import "SinglePhotoViewController.h"

@interface SinglePhotoViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation SinglePhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.imageView.image = self.photo.image;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)deleteBarButtonItemPressed:(UIBarButtonItem *)sender {
    NSManagedObjectContext *context = [self.photo managedObjectContext];
    [context deleteObject:self.photo];
    
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"We have error. failed to save");
    }
    [self.navigationController popViewControllerAnimated:YES];
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
