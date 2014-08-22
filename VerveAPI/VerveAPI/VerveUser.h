//
//  VerveUser.h
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 8/17/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VerveUser : NSObject

@property(nonatomic, retain) NSString *name;
@property(nonatomic, retain) NSString *screenName;
@property(nonatomic, retain) NSString *password;
@property(nonatomic, retain) NSString *email;
@property(nonatomic, retain) NSString *mobile;
@property(nonatomic, retain) NSString *zipcode;
@property(nonatomic, retain) NSString *birth_month;
@property(nonatomic) long birth_year;

-(NSMutableDictionary *) toJSON;


@end
