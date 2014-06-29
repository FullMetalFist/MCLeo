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

@property (nonatomic, strong) MCPeerID *peerID;
@property (nonatomic, strong) MCSession *session;
@property (nonatomic, strong) MCBrowserViewController *browser;
@property (nonatomic, strong) MCAdvertiserAssistant *advertiser;
@property (nonatomic) NSInteger numberOfPeers;
@property (nonatomic) BOOL isHost;

-(void)createSession;
-(void)createBrowser;
-(void)beginAdvertising;

@end
