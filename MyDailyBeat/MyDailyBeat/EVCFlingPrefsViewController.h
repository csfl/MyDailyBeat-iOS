//
//  EVCFlingPrefsViewController.h
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 8/24/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RelationshipPrefs.h"
#import <API.h>
#import <UIView+Toast.h>
#import <FXForms.h>


@interface EVCFlingPrefsViewController : UIViewController <FXFormControllerDelegate> {
    
    
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property(nonatomic, retain) API *api;
@property (nonatomic, strong) FXFormController *formController;

@end
