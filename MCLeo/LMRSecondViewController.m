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

@property (weak, nonatomic) IBOutlet UITextField *enterTextField;
@property (weak, nonatomic) IBOutlet UITextView *textField;


- (IBAction)sendButton:(id)sender;

@end

@implementation LMRSecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.label.text = @"";
    self.textField.text = @"";
    self.label.hidden = YES;
    
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



- (IBAction)sendButton:(id)sender
{
    [self.enterTextField resignFirstResponder];
    NSString *dataString = self.enterTextField.text;
    NSDictionary *dictionary = @{@"message": dataString};
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

-(void)didReceiveDataWithNotification:(NSNotification *)notification
{
    NSLog(@"VC Notification");
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *notificationDictionary = notification.userInfo;
        NSDictionary *receivedDataDictionary = [NSJSONSerialization JSONObjectWithData:notificationDictionary[@"data"] options:0 error:nil];
        MCPeerID *fromPeer = notificationDictionary[@"peerID"];
        NSString *message = receivedDataDictionary[@"message"];
        NSString *labelText;
        if ([self.textField.text isEqualToString:@""])
        {
            labelText = [NSString stringWithFormat:@"Message From: %@\n%@",fromPeer.displayName,message];
        }
        else
        {
            labelText = [NSString stringWithFormat:@"%@\n%@",self.textField.text,message];
        }
        self.textField.text = labelText;
    });
}

@end
