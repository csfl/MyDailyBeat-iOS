//
//  EVCFinanceViewController.m
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 8/29/15.
//  Copyright (c) 2015 eVerveCorp. All rights reserved.
//

#import "EVCFinanceViewController.h"

@interface EVCFinanceViewController ()

@end

@implementation EVCFinanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    EVCFinanceHomeViewController *search = [[EVCFinanceHomeViewController alloc] initWithNibName:@"EVCFinanceHomeViewController" bundle:nil];
    EVCResourceLinksTableViewController *favs = [[EVCResourceLinksTableViewController alloc] initWithNibName:@"EVCResourceLinksTableViewController" bundle:nil];
    
    UINavigationController *first = [[UINavigationController alloc] initWithRootViewController:search];
    UINavigationController *second = [[UINavigationController alloc] initWithRootViewController:favs];
    
    UITabBar *bar = self.tabBar;
    
    self.viewControllers = [NSArray arrayWithObjects:first, second, nil];
    
    UITabBarItem *matchItem = [bar.items objectAtIndex:0];
    UITabBarItem *partnersItem = [bar.items objectAtIndex:1];
    
    UIImage *firstIm = [EVCCommonMethods imageWithImage:[UIImage imageNamed:@"search-icon-green"] scaledToSize:CGSizeMake(30, 30)];
    UIImage *secondIm = [EVCCommonMethods imageWithImage:[UIImage imageNamed:@"search-icon-gray"] scaledToSize:CGSizeMake(30, 30)];
    
    matchItem.title = @"Search URLs";
    [matchItem setFinishedSelectedImage:firstIm withFinishedUnselectedImage:secondIm];
    
    firstIm = [EVCCommonMethods imageWithImage:[UIImage imageNamed:@"star-icon-green"] scaledToSize:CGSizeMake(30, 30)];
    secondIm = [EVCCommonMethods imageWithImage:[UIImage imageNamed:@"star-icon-gray"] scaledToSize:CGSizeMake(30, 30)];
    
    partnersItem.title = @"View Favorites";
    [partnersItem setFinishedSelectedImage:firstIm withFinishedUnselectedImage:secondIm];
    
    UIImage* image3 = [EVCCommonMethods imageWithImage:[UIImage imageNamed:@"hamburger-icon-green"] scaledToSize:CGSizeMake(30, 30)];
    CGRect frameimg = CGRectMake(0, 0, image3.size.width, image3.size.height);
    UIButton *someButton = [[UIButton alloc] initWithFrame:frameimg];
    [someButton setBackgroundImage:image3 forState:UIControlStateNormal];
    [someButton addTarget:self action:@selector(showMenu)
         forControlEvents:UIControlEventTouchUpInside];
    [someButton setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *menuButton =[[UIBarButtonItem alloc] initWithCustomView:someButton];
    
    self.navigationItem.rightBarButtonItem = menuButton;
    
    UIImage* image4 = [EVCCommonMethods imageWithImage:[UIImage imageNamed:@"profile-icon-green"] scaledToSize:CGSizeMake(30, 30)];
    CGRect frameimg2 = CGRectMake(0, 0, image4.size.width, image4.size.height);
    UIButton *someButton2 = [[UIButton alloc] initWithFrame:frameimg2];
    [someButton2 setBackgroundImage:image4 forState:UIControlStateNormal];
    [someButton2 addTarget:self action:@selector(showProfile)
          forControlEvents:UIControlEventTouchUpInside];
    [someButton2 setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *profileButton =[[UIBarButtonItem alloc] initWithCustomView:someButton2];
    self.navigationItem.leftBarButtonItem = profileButton;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) showMenu {
    [self.sideMenuViewController presentRightMenuViewController];
}

- (void) showProfile {
    [self.sideMenuViewController presentLeftMenuViewController];
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
