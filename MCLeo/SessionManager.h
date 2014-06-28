//
//  MCSession.h
//  MCLeo
//
//  Created by Leo Reubelt on 6/26/14.
//  Copyright (c) 2014 Leo Reubelt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface SessionManager : NSObject <MCSessionDelegate>

@property (nonatomic, strong) MCSession *session;
@property (nonatomic, strong) MCBrowserViewController *browser;
@property (nonatomic, strong) MCAdvertiserAssistant *advertiser;
@property (nonatomic, strong) NSMutableArray *peers;
@property (nonatomic) NSInteger numberOfPeers;
@property (nonatomic, strong) NSString *sessionName;

-(void)createSessionWithName:(NSString *)displayName;
-(void)createBrowser;
-(void)beginAdvertising:(BOOL)isHost;

@end
