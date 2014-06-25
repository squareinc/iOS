/*
 * OpenRemote, the Home of the Digital Home.
 * Copyright 2008-2013, OpenRemote Inc.
 *
 * See the contributors.txt file in the distribution for a
 * full listing of individual contributors.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

#import "ORViewController.h"
#import "LoginViewController.h"
#import "ORControllerClient/ORControllerAddress.h"
#import "ORControllerClient/ORControllerInfo.h"
#import "ORControllerClient/ORController.h"
#import "ORControllerClient/ORLabel.h"
#import "ORControllerClient/Definition.h"
#import "ORControllerClient/ORUserPasswordCredential.h"
#import "ORControllerPickerViewController.h"

//#define CONTROLLER_ADDRESS @"http://localhost:8688/controller"
#define CONTROLLER_ADDRESS @"https://localhost:8443/controller"

@interface ORViewController () <ORControllerPickerViewControllerDelegate>

@property (nonatomic, strong) NSArray *labels;
@property (nonatomic, strong) ORController *orb;

@property (atomic) BOOL gotLogin;
@property (atomic, strong) NSObject <ORCredential> *_credentials;
@property (atomic, strong) NSCondition *loginCondition;

@property (atomic) BOOL didAcceptCertificate;
@property (atomic, strong) NSCondition *certificateCondition;

@property (nonatomic, strong) NSString *controllerAddress;

@end

@implementation ORViewController

- (void)viewDidLoad
{
    self.controllerAddress = CONTROLLER_ADDRESS;
    self.title = self.controllerAddress;
    self.toolbarItems = @[[[UIBarButtonItem alloc] initWithTitle:@"Start" style:UIBarButtonItemStyleBordered target:self action:@selector(startPolling)],
    [[UIBarButtonItem alloc] initWithTitle:@"Stop" style:UIBarButtonItemStyleBordered target:self action:@selector(stopPolling)]];
    self.navigationController.toolbarHidden = NO;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Select" style:UIBarButtonItemStylePlain target:self action:@selector(pickController:)];
    
    [self createOrb];
    
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
//    [self performSelector:@selector(startPolling) withObject:nil afterDelay:2.01];
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    // If we did register previously to observe on model objects, un-register
    [self stopObservingLabelChanges];
    self.labels = nil;
}

- (id)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.labels count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.textLabel.text = ((ORLabel *)[self.labels objectAtIndex:indexPath.row]).text;
    return cell;
}

- (void)pickController:(id)sender
{
    [self stopPolling];

    ORControllerPickerViewController *vc = [[ORControllerPickerViewController alloc] init];
    vc.delegate = self;
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:vc] animated:YES completion:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    // We're not guaranteed that the value we observe is set on the main thread,
    // so ensure we're updating our UI on the main thread here
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (void)stopObservingLabelChanges
{
    if (self.labels) {
        [self.labels enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            @try {
                [obj removeObserver:self forKeyPath:@"text"];
            } @catch(NSException *e) {
                // Ignore NSRangeException, would mean we already removed ourself as observer
                if (![@"NSRangeException" isEqualToString:e.name]) {
                    @throw e;
                }
            }
        }];
    }
}

- (void)createOrb
{
    ORControllerAddress *address = [[ORControllerAddress alloc] initWithPrimaryURL:[NSURL URLWithString:self.controllerAddress]];
    self.orb = [[ORController alloc] initWithControllerAddress:address];
    
    // We set ourself as the authenticationManager, we'll provide the credential by asking the user
    // for a username / password
    self.orb.authenticationManager = self;
}

- (void)startPolling
{
    [self.orb connectWithSuccessHandler:^{
        [self.orb requestPanelUILayout:@"panel1" successHandler:^(Definition *definition) {
            self.labels = [definition.labels allObjects];
            // Register on all model objects to observe any change on their value
            [self.labels enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [obj addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:NULL];
            }];
            [self.tableView reloadData];
            
        } errorHandler:^(NSError *error) {
            [[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Error %ld", (long)[error code]]
                                        message:[error localizedDescription]
                                       delegate:nil
                              cancelButtonTitle:nil
                              otherButtonTitles:@"OK", nil] show];
        }];
    } errorHandler:NULL];
}

- (void)stopPolling
{
    [self stopObservingLabelChanges];
    [self.orb disconnect];
}

#pragma mark - ORControllerPickerViewController delegate implementation

- (void)controllerPicker:(ORControllerPickerViewController *)picker didPickController:(ORControllerInfo *)controller
{
    [self dismissViewControllerAnimated:YES completion:^{
        self.controllerAddress = [controller.address.primaryURL description];
        self.title = self.controllerAddress;
        [self createOrb];
    }];
}

- (void)controllerPickerDidCancelPick:(ORControllerPickerViewController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - ORAuthenticationManager implementation

- (NSObject <ORCredential> *)credential
{
    self.gotLogin = NO;
    self.loginCondition = [[NSCondition alloc] init];
    
    // "Dummy" implementation for this sample code as no caching is performed.
    // Any time a credential is required, we'll ask the user
    
    // Make sure presenting the login panel is done on the main thread,
    // as this method call is done on a background thread
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:[[LoginViewController alloc] initWithDelegate:self] animated:YES completion:NULL];
    });
    
    // As this code is executing in the background, it's safe to block here for some time
    [self.loginCondition lock];
    if (!self.gotLogin) {
        [self.loginCondition wait];
    }
    [self.loginCondition unlock];
    self.loginCondition = nil;
    
    return self._credentials;
}

- (BOOL)acceptServer:(NSURLProtectionSpace *)protectionSpace
{
    self.didAcceptCertificate = NO;
    self.certificateCondition = [[NSCondition alloc] init];

    dispatch_async(dispatch_get_main_queue(), ^{
        [[[UIAlertView alloc] initWithTitle:@"Invalid certificate"
                                    message:[NSString stringWithFormat:@"Certificate for host '%@' can not be validated, do you want to proceed with the connection ?", protectionSpace.host]
                                   delegate:self
                          cancelButtonTitle:@"No"
                          otherButtonTitles:@"Yes", nil] show];
    });

    [self.certificateCondition lock];
    [self.certificateCondition wait];
    [self.certificateCondition unlock];
    self.certificateCondition = nil;
    
    return self.didAcceptCertificate;
}

#pragma mark - LoginViewController delegate implementation

- (void)loginViewControllerDidCancelLogin:(LoginViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:^{
        [self.loginCondition lock];
        self.gotLogin = YES;
        self._credentials = nil;
        [self.loginCondition signal];
        [self.loginCondition unlock];
    }];
}

- (void)loginViewController:(LoginViewController *)controller didProvideUserName:(NSString *)username password:(NSString *)password
{
    [self dismissViewControllerAnimated:YES completion:^{
        [self.loginCondition lock];
        self._credentials = [[ORUserPasswordCredential alloc] initWithUsername:username password:password];
        self.gotLogin = YES;
        [self.loginCondition signal];
        [self.loginCondition unlock];
    }];
}

#pragma mark - Alert (certificate accept) delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.certificateCondition lock];
    self.didAcceptCertificate = (buttonIndex == 1);
    [self.certificateCondition signal];
    [self.certificateCondition unlock];
}

@end
