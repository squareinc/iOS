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

#import "ORDevicesViewController.h"
#import "ORViewController_Private.h"
#import "ORDeviceViewController.h"
#import <ORControllerClient/ORController.h>
#import <ORControllerClient/ORDevice.h>
#import <ORControllerClient/ORDevice.h>
#import <ORControllerClient/ORCommand.h>

@interface ORDevicesViewController ()

@property (nonatomic, strong) NSArray *devices;

@property(nonatomic, strong) ORDevice *selectedDevice;
@end

@implementation ORDevicesViewController

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

    // If we did register previously to observe on model objects, un-register
    [self stopObservingLabelChanges];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ORDeviceViewController *vc = (ORDeviceViewController *) segue.destinationViewController;
    vc.device = self.selectedDevice;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.devices count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"DeviceCell"];
    cell.textLabel.text = ((ORDevice *) self.devices[(NSUInteger) indexPath.row]).name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedDevice = self.devices[(NSUInteger) indexPath.row];
    [self.orb requestDevice:self.selectedDevice withSuccessHandler:^(ORDevice *theDevice) {
        [self performSegueWithIdentifier:@"DeviceSegue" sender:self];
    } errorHandler:^(NSError *error) {
        NSLog(@"Error %@", error);
    }];

}

- (void)startPolling
{
    [super startPolling];
    [self.orb connectWithSuccessHandler:^{
        [self.orb requestDevicesListWithSuccessHandler:^(NSArray *array) {
            self.devices = array;
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
//    [self stopObservingLabelChanges];
    [super stopPolling];
}

- (void)stopObservingLabelChanges
{
    if (self.devices) {
        [self.devices enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            @try {
                [obj removeObserver:self forKeyPath:@"text"];
            } @catch (NSException *e) {
                // Ignore NSRangeException, would mean we already removed ourself as observer
                if (![@"NSRangeException" isEqualToString:e.name]) {
                    @throw e;
                }
            }
        }];
    }
}

@end
