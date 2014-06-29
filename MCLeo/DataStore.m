//
//  DataStore.m
//  MCLeo
//
//  Created by Leo Reubelt on 6/24/14.
//  Copyright (c) 2014 Leo Reubelt. All rights reserved.
//

#import "DataStore.h"

@implementation DataStore

+ (instancetype)sharedLocationsDataStore
{
    static DataStore *_dataStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dataStore = [[DataStore alloc] init];
    });
    return _dataStore;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.sessionManager = [[SessionManager alloc]init];
    }
    return self;
}


@end
