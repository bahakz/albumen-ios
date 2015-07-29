//
//  EntranceViewController.m
//  Albumen iOS Client
//
//  Created by Bakytzhan Baizhikenov on 3/18/15.
//  Copyright (c) 2015 intellection. All rights reserved.
//

#import "EntranceViewController.h"
#import "IntroPageContentViewController.h"
#import "Konsts.h"

@interface EntranceViewController () <UIPageViewControllerDataSource>

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageTitles;
@property (strong, nonatomic) NSArray *pageImages;

@end

@implementation EntranceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.pageTitles = @[@"Создайте Альбом для особенного случая или периода вашей жизни", @"Добавляйте до 30-ти фотографии в альбом", @"Нажмите кнопку заказать и пока фотографии загружаются, вводите данные для доставки", @"В течении недели, мы доставим альбом к Вам домой"];
    self.pageImages = @[@"intro_page1.png", @"intro_page2.png", @"intro_page3.png", @"intro_page4.png"];
    
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"introPageVC"];
    self.pageViewController.dataSource = self;
    
    IntroPageContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    self.pageViewController.view.frame = CGRectMake(0, CGRectGetHeight([UIApplication sharedApplication].statusBarFrame), self.view.frame.size.width, self.view.frame.size.height - 60 - CGRectGetHeight([UIApplication sharedApplication].statusBarFrame));
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
}


-(void)viewDidAppear:(BOOL)animated
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults boolForKey:DEFAULTS_INTRO_IS_SEEN]) {
        [self openAppAnimated: NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Page View Controller Data Source

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((IntroPageContentViewController *) viewController).pageIndex;
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((IntroPageContentViewController *) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageTitles count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (IntroPageContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.pageTitles count] == 0) || (index >= [self.pageTitles count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    IntroPageContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"introContentVC"];
    pageContentViewController.imageFileName = self.pageImages[index];
    pageContentViewController.titleText = self.pageTitles[index];
    pageContentViewController.pageIndex = index;
    
    return pageContentViewController;
}

-(NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.pageTitles count];
}

-(NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

-(void) openAppAnimated: (BOOL) animated
{
    IntroPageContentViewController *startAppController = [self.storyboard instantiateViewControllerWithIdentifier:@"startNavigationVC"];
    [self presentViewController:startAppController animated:animated completion:nil];
}

- (IBAction)doneButtonPressed:(UIButton *)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@YES forKey:DEFAULTS_INTRO_IS_SEEN];
    [defaults synchronize];
    [self openAppAnimated:YES];
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
