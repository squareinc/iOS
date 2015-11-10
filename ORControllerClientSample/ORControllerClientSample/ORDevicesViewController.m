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
#import <ORControllerClient/ORControllerDeviceModel.h>
#import <ORControllerClient/ORControllerDeviceModel.h>

@interface ORDevicesViewController ()

@property(nonatomic, strong) ORDevice *selectedDevice;
@property(nonatomic, strong) ORControllerDeviceModel *deviceModel;
@end

@implementation ORDevicesViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"DeviceSegue"]) {
        ORDeviceViewController *vc = (ORDeviceViewController *) segue.destinationViewController;
        vc.device = self.deviceModel.devices[(NSUInteger) [self.tableView indexPathForCell:sender].row];
        vc.orb = self.orb;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.deviceModel.devices count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"DeviceCell"];
    cell.textLabel.text = ((ORDevice *) self.deviceModel.devices[(NSUInteger) indexPath.row]).name;
    return cell;
}

- (void)startPolling
{
    [self stopPolling];
    [super startPolling];
    [self.orb connectWithSuccessHandler:^{
        [self.orb requestDeviceModelWithSuccessHandler:(^(ORControllerDeviceModel *deviceModel) {
            self.deviceModel = deviceModel;
            [self.tableView reloadData];
        })                                errorHandler:^(NSError *error) {
            [[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Error %ld", (long) [error code]]
                                        message:[error localizedDescription]
                                       delegate:nil
                              cancelButtonTitle:nil
                              otherButtonTitles:@"OK", nil] show];
        }];
    }                      errorHandler:NULL];
}

@end
