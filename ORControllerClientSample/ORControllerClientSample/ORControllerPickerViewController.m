//
//  ORControllerPickerViewController.m
//  ORControllerClientSample
//
//  Created by Eric Bariaux on 25/06/14.
//  Copyright (c) 2014 OpenRemote. All rights reserved.
//

#import "ORControllerPickerViewController.h"
#import "ORControllerClient/ORControllerBrowser.h"
#import "ORControllerClient/ORControllerInfo.h"

@interface ORControllerPickerViewController () <ORControllerBrowserDelegate>

@property (nonatomic, strong) ORControllerBrowser *controllerBrowser;

@end

@implementation ORControllerPickerViewController

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"Discover controller";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                           target:self action:@selector(cancel:)];
    
    self.controllerBrowser = [[ORControllerBrowser alloc] init];
    self.controllerBrowser.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.controllerBrowser startSearchingForORControllers];
}

- (void)cancel:(id)sender
{
    [self.controllerBrowser stopSearchingForORControllers];
    [self.delegate controllerPickerDidCancelPick:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.controllerBrowser discoveredControllers] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
    }
    
    ORControllerInfo *info = [self.controllerBrowser.discoveredControllers objectAtIndex:indexPath.row];
    cell.textLabel.text = info.name;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    ORControllerInfo *info = [self.controllerBrowser.discoveredControllers objectAtIndex:indexPath.row];
    [self.controllerBrowser stopSearchingForORControllers];
    [self.delegate controllerPicker:self didPickController:info];
}

#pragma mark - ORControllerBrowser delegate implementation

- (void)controllerBrowser:(ORControllerBrowser *)browser didFindController:(ORControllerInfo *)controllerInfo
{
    [self.tableView reloadData];
}

- (void)controllerBrowser:(ORControllerBrowser *)browser didUpdateController:(ORControllerInfo *)controllerInfo
{
    [self.tableView reloadData];
}

- (void)controllerBrowser:(ORControllerBrowser *)browser didFail:(NSError *)error
{
    [[[UIAlertView alloc] initWithTitle:@"Auto-discovery error"
                                message:[error description]
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
}

@end
