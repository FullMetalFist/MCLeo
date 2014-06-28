//
//  DataStore.h
//  MCLeo
//
//  Created by Leo Reubelt on 6/24/14.
//  Copyright (c) 2014 Leo Reubelt. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SessionManager.h"

@interface DataStore : NSObject

@property (strong, nonatomic) SessionManager *sessionManager;

+ (instancetype)sharedLocationsDataStore;

@end
