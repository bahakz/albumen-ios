//
//  OrderConfirmationViewController.m
//  Albumen iOS Client
//
//  Created by Bakytzhan Baizhikenov on 3/18/15.
//  Copyright (c) 2015 intellection. All rights reserved.
//

#import "OrderConfirmationViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface OrderConfirmationViewController ()
@property (strong, nonatomic) IBOutlet UIButton *okButton;
@end

@implementation OrderConfirmationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[self.okButton layer] setBorderWidth:0.5f];
    [[self.okButton layer] setBorderColor:[UIColor whiteColor].CGColor];
    [[self.okButton layer] setCornerRadius:8.0f];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)okButtonPressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
