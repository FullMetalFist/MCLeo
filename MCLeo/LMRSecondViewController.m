//
//  LMRSecondViewController.m
//  MCLeo
//
//  Created by Leo Reubelt on 6/24/14.
//  Copyright (c) 2014 Leo Reubelt. All rights reserved.
//

#import "LMRSecondViewController.h"

@interface LMRSecondViewController ()

@property (strong, nonatomic) IBOutlet UILabel *label;

- (IBAction)sendButton:(id)sender;

@end

@implementation LMRSecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.store = [DataStore sharedLocationsDataStore];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveDataWithNotification:)
                                                 name:@"didReceiveData"
                                               object:nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)sendButton:(id)sender {
    NSDictionary *dictionary = @{@"message": @"Hello Leo"};
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil];
    NSError *error;
    [self.store.sessionManager.session sendData:data
                                        toPeers:self.store.sessionManager.session.connectedPeers
                                       withMode:MCSessionSendDataReliable
                                          error:&error];
    if (error) {
        NSLog(@"error");
    }
    
}

-(void)didReceiveDataWithNotification:(NSNotification *)notification{
    NSLog(@"VC Notification");
    
    NSDictionary *notificationDictionary = notification.userInfo;
    NSDictionary *receivedDataDictionary = [NSJSONSerialization JSONObjectWithData:notificationDictionary[@"data"] options:0 error:nil];
    MCPeerID *fromPeer = notificationDictionary[@"peerID"];
    NSString *message = receivedDataDictionary[@"message"];
    
    
    self.label.text = [NSString stringWithFormat:@"%@ says %@",fromPeer.displayName,message];

}

@end
