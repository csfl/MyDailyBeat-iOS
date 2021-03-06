//
//  EVCPartnerMatchViewController.m
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 12/21/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import "EVCPartnerMatchViewController.h"

@interface EVCPartnerMatchViewController ()

@end

@implementation EVCPartnerMatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.partners = [[NSMutableArray alloc] init];
    [self retrievePartners];
}

- (void) retrievePartners {
    dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
    dispatch_async(queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToastActivity];
        });
        
        self.partners = [[NSMutableArray alloc] initWithArray:[[API getInstance] getFlingProfilesBasedOnPrefsOfUser:[[API getInstance] getCurrentUser]]];
        NSLog(@"Partners: %d", [self.partners count]);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view hideToastActivity];
            [self.tableView reloadData];
        });
    });
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.partners count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellIdentifier"];
    }
    
    if ([self.partners count] == 0) {
        cell.textLabel.text = @"No Results Found";
    } else {
        cell.textLabel.text = ((FlingProfile *)[self.partners objectAtIndex:indexPath.row]).screenName;
        cell.imageView.image = [self loadPictureForUser:((FlingProfile *)[self.partners objectAtIndex:indexPath.row]).screenName];
    }
    
    return cell;
}

- (UIImage *) loadPictureForUser: (NSString *) screenName {
    __block UIImage *img;
    dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
    dispatch_async(queue, ^{
        NSURL *imageURL = [[API getInstance] retrieveProfilePictureForUserWithScreenName:screenName];
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            img = [UIImage imageWithData:imageData];
            
        });
        
    });
    
    return img;
    
}



#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    EVCFlingProfileViewController *prof = [[EVCFlingProfileViewController alloc] initWithNibName:@"EVCFlingProfileViewController" bundle:nil andUser:[[API getInstance] getUserDataForUserWithScreenName:((FlingProfile *)[self.partners objectAtIndex:indexPath.row]).screenName]];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:prof animated:YES];
}

@end
