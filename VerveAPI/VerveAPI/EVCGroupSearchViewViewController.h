//
//  EVCGroupSearchViewViewController.h
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 11/9/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "API.h"
#import "EVCSearchEngine.h"
#import "UIView+Toast.h"
#import "DLAVAlertView.h"

@interface EVCGroupSearchViewViewController : UIViewController <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate> {
    UIBarButtonItem *cancel;
    BOOL isFiltered;
    EVCSearchEngine *currentSearch;

}

@property (nonatomic) IBOutlet UITableView *mTableView;
@property (nonatomic) IBOutlet UISearchBar *mSearchBar;
@property (strong, nonatomic) NSMutableArray* data;


@end
