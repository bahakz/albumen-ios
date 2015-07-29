//
//  IntroPageContentViewController.m
//  Albumen iOS Client
//
//  Created by Bakytzhan Baizhikenov on 3/18/15.
//  Copyright (c) 2015 intellection. All rights reserved.
//

#import "IntroPageContentViewController.h"

@interface IntroPageContentViewController ()
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *mainImageView;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topLabelConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topImageConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *leftImageConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *rightImageConstraint;
@end

@implementation IntroPageContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mainImageView.image = [UIImage imageNamed:self.imageFileName];
    self.titleLabel.text = self.titleText;
    
    if ([UIScreen mainScreen].bounds.size.height == 736) {
        NSLog(@"iPhone 6 Plus");
        self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:23];
    }
    
    if ([UIScreen mainScreen].bounds.size.height == 480) {
     
        NSLog(@"iPhone 4");
        self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
        self.topLabelConstraint.constant = 10;
        self.topImageConstraint.constant = 70;
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
