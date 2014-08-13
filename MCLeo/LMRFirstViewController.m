//
//  LMRFirstViewController.m
//  MCLeo
//
//  Created by Leo Reubelt on 6/24/14.
//  Copyright (c) 2014 Leo Reubelt. All rights reserved.
//

#import "LMRFirstViewController.h"
#import "LMRSecondViewController.h"

@interface LMRFirstViewController ()


@property (strong, nonatomic) IBOutlet UITextField *peerNameField;
@property (strong, nonatomic) IBOutlet UISwitch *advertiseSwitchOutlet;
@property (strong, nonatomic) IBOutlet UIButton *browseButtonOutlet;


@property (strong, nonatomic) IBOutlet UITableView *peersTableView;

- (IBAction)peerNameTextEntered:(id)sender;
- (IBAction)advertiseSwitch:(id)sender;
- (IBAction)browseButton:(id)sender;
- (IBAction)disconnectButton:(id)sender;


@end

@implementation LMRFirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.store = [DataStore sharedLocationsDataStore];
    [self.peersTableView setDelegate:self];
    [self.peersTableView setDataSource:self];
    [self.peerNameField setDelegate:self];
    self.tabBarController.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(stateChangeWithNotification:)
                                                 name:@"peerStateChange"
                                               object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.store.sessionManager.advertiser stop];
    [self.advertiseSwitchOutlet setOn:NO];
}


- (IBAction)peerNameTextEntered:(id)sender
{
    [self.peerNameField resignFirstResponder];
    self.store.sessionManager.peerID = [[MCPeerID alloc]initWithDisplayName:self.peerNameField.text];
    NSLog(@"Peer Name Entered");
}





#pragma mark - TableView Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.store.sessionManager.session.connectedPeers count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (![self.store.sessionManager.session.connectedPeers count]==0 && self.store.sessionManager.session.connectedPeers) {
        MCPeerID *peerID = [self.store.sessionManager.session.connectedPeers objectAtIndex:indexPath.row];
        cell.textLabel.text = peerID.displayName;
    }
    return cell;
}





#pragma mark -Session Methods

-(void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController
{
    [self.store.sessionManager.browser dismissViewControllerAnimated:YES completion:nil];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.peersTableView reloadData];
    });

}

-(void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController
{
    [self.store.sessionManager.browser dismissViewControllerAnimated:YES completion:nil];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.peersTableView reloadData];
    });
}


-(void)stateChangeWithNotification:(NSNotification*)stateChange
{

    if ([self.store.sessionManager.session.connectedPeers count] == self.store.sessionManager.numberOfPeers){
        NSLog(@"ConnectedYYYY");
        [self.store.sessionManager stopAdcertising];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.peersTableView reloadData];
            self.tabBarController.selectedIndex = 1;
        });

    }
}

//- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
//    LMRSecondViewController *secondVC = self.tabBarController.viewControllers[1];
//    
//    if (!([self.store.sessionManager.session.connectedPeers count]==2 && self.store.sessionManager.session.connectedPeers) && (viewController == secondVC)) {
//        return NO;
//    }
//    else return YES;
//}

- (void)advertiserAssistantDidDismissInvitation:(MCAdvertiserAssistant *)advertiserAssistant{
    NSLog(@"Advertiser Gone");
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.peersTableView reloadData];
        [self.store.sessionManager.advertiser stop];
        [self.advertiseSwitchOutlet setOn:NO animated:YES];
    });
}


#pragma mark -IBActions

- (IBAction)advertiseSwitch:(id)sender
{
    if ([self.peerNameField.text isEqualToString:@""] || !self.peerNameField.text)
    {
        UIAlertView *noNameAlert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Must Enter Name" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [noNameAlert show];
        [self.advertiseSwitchOutlet setOn:NO animated:YES];
    }
    else
    {
    
    self.browseButtonOutlet.enabled = !self.advertiseSwitchOutlet.isOn;
    [self.peerNameField resignFirstResponder];

    
    if (self.advertiseSwitchOutlet.isOn)
    {
        self.store.sessionManager.peerID = [[MCPeerID alloc]initWithDisplayName:self.peerNameField.text];
        [self.store.sessionManager createSession];
        [self.store.sessionManager beginAdvertising];
    }
    else
    {
        [self.store.sessionManager.advertiser stop];
    }
    self.store.sessionManager.advertiser.delegate = self;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.peersTableView reloadData];
    });
    }
}

- (IBAction)browseButton:(id)sender
{
    if ([self.peerNameField.text isEqualToString:@""] || !self.peerNameField.text)
    {
        UIAlertView *noNameAlert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Must Enter Name" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [noNameAlert show];
    }
    else
    {
    [self.peerNameField resignFirstResponder];
    
    self.store.sessionManager.peerID = [[MCPeerID alloc]initWithDisplayName:self.peerNameField.text];
    [self.store.sessionManager createSession];
    
    [self.store.sessionManager createBrowser];
    self.store.sessionManager.browser.delegate = self;
    [self presentViewController:self.store.sessionManager.browser animated:YES completion:nil];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.peersTableView reloadData];
    });
    }
}

- (IBAction)disconnectButton:(id)sender
{

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.store.sessionManager stopAdcertising];
        [self.advertiseSwitchOutlet setOn:NO animated:YES];
        self.browseButtonOutlet.enabled = YES;
        [self.store.sessionManager.session disconnect];
        [self.peersTableView reloadData];
        sleep(1);
        [self.peersTableView reloadData];
    });

}



@end
