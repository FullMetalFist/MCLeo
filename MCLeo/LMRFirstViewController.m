//
//  LMRFirstViewController.m
//  MCLeo
//
//  Created by Leo Reubelt on 6/24/14.
//  Copyright (c) 2014 Leo Reubelt. All rights reserved.
//

#import "LMRFirstViewController.h"

@interface LMRFirstViewController ()

@property (strong, nonatomic) IBOutlet UITextField *peerNameField;
@property (strong, nonatomic) IBOutlet UITableView *peersTableView;

- (IBAction)connectButton:(id)sender;
- (IBAction)disconnectButton:(id)sender;


@end

@implementation LMRFirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.store = [DataStore sharedLocationsDataStore];
    [self.peersTableView setDelegate:self];
    [self.peersTableView setDataSource:self];
    self.peerNameField.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(stateChangeWithNotification:)
                                                 name:@"peerStateChange"
                                               object:nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}


-(void)textFieldDidEndEditing:(UITextField *)peerNameField{
    [self.peerNameField resignFirstResponder];
}

#pragma mark - TableView Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.store.sessionManager.session.connectedPeers count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    MCPeerID *peerID = [self.store.sessionManager.session.connectedPeers objectAtIndex:indexPath.row];
    
    cell.textLabel.text = peerID.displayName;
    
    return cell;
}

#pragma mark -Session Methods

-(void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController{
    [self.store.sessionManager.browser dismissViewControllerAnimated:YES completion:nil];
    [self.peersTableView reloadData];
}

-(void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController{
    [self.store.sessionManager.browser dismissViewControllerAnimated:YES completion:nil];
    [self.peersTableView reloadData];
}


-(void)stateChangeWithNotification:(NSNotification*)stateChange
{
    if ([self.store.sessionManager.session.connectedPeers count] == self.store.sessionManager.numberOfPeers) {
        [self.store.sessionManager.advertiser stop];
        [self.store.sessionManager.browser dismissViewControllerAnimated:YES completion:nil];
        NSLog(@"number ");
    }
    NSLog(@"state change");
    [self.peersTableView reloadData];
}



#pragma mark -IBActions

- (IBAction)connectButton:(id)sender {
    NSLog(@"Connect Button");
    [self.peerNameField resignFirstResponder];
    [self.store.sessionManager createSessionWithName:self.peerNameField.text];
    [self.store.sessionManager beginAdvertising:YES];
    [self.store.sessionManager createBrowser];
    self.store.sessionManager.browser.delegate = self;
    [self presentViewController:self.store.sessionManager.browser animated:YES completion:nil];
    [self.peersTableView reloadData];
}

- (IBAction)disconnectButton:(id)sender {
    [self.store.sessionManager.session disconnect];
    [self.peersTableView reloadData];
}


@end
