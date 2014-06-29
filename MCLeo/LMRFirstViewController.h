//
//  LMRFirstViewController.h
//  MCLeo
//
//  Created by Leo Reubelt on 6/24/14.
//  Copyright (c) 2014 Leo Reubelt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "DataStore.h"

@interface LMRFirstViewController : UIViewController <MCBrowserViewControllerDelegate,MCAdvertiserAssistantDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, MCBrowserViewControllerDelegate>

@property (strong, nonatomic) DataStore *store;

-(void)stateChangeWithNotification:(NSNotification*)stateChange;

@end
