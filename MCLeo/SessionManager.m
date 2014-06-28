//
//  MCSession.m
//  MCLeo
//
//  Created by Leo Reubelt on 6/26/14.
//  Copyright (c) 2014 Leo Reubelt. All rights reserved.
//

#import "SessionManager.h"

@implementation SessionManager


-(id)init{
    self = [super init];
    
    if (self) {
        self.numberOfPeers = 1;
        self.session = nil;
        self.browser = nil;
        self.advertiser = nil;
    }
    
    return self;
}


#pragma mark - Session Callback Methods

-(void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
    if ([self.session.connectedPeers count] == self.numberOfPeers) {
        [self.advertiser stop];
//        if (self.session.myPeerID == peerID) {
//            [self.session disconnect];
//        }
    }
    
    NSDictionary *stateChangeDict = @{@"peerWithChangedState":peerID,@"state":[NSNumber numberWithInt:state]};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"peerStateChange"
                                                        object:nil
                                                      userInfo:stateChangeDict];
}


-(void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{
    NSLog(@"Received Data");
    
    NSDictionary *dataDict = @{@"data": data,@"peerID":peerID};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didReceiveData"
                                                        object:nil
                                                      userInfo:dataDict];
}


-(void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress{}

-(void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error{}

-(void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID{}








#pragma mark - Session Setup Methods

-(void)createSessionWithName:(NSString *)displayName{
   
    MCPeerID *peerID = [[MCPeerID alloc]initWithDisplayName:displayName];
    self.session = [[MCSession alloc]initWithPeer:peerID];
    self.session.delegate = self;
}


-(void)createBrowser{
    
    self.browser = [[MCBrowserViewController alloc] initWithServiceType:@"connection" session:self.session];
    NSLog(@"browser create");
    
}

-(void)beginAdvertising:(BOOL)isHost{
    if (isHost) {
        
        NSLog(@"begin advertising");
        self.advertiser = [[MCAdvertiserAssistant alloc] initWithServiceType:@"connection"
                                                               discoveryInfo:nil
                                                                     session:self.session];
        
        [self.advertiser start];
    }
    else{
        [self.advertiser stop];
        self.advertiser = nil;
    }
}



@end
