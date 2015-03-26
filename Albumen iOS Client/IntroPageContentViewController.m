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

@end

@implementation IntroPageContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mainImageView.image = [UIImage imageNamed:self.imageFileName];
    self.titleLabel.text = self.titleText;
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
