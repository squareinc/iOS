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

#import <ORControllerClient/ORDevice.h>
#import <ORControllerClient/ORDeviceCommand.h>
#import <ORControllerClient/ORDeviceSensor.h>
#import <ORControllerClient/ORController.h>
#import "ORDeviceViewController.h"


@implementation ORDeviceViewController


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.device.commands.count;
    } else if (section == 1) {
        return self.device.sensors.count;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"CommandCell"];
        ORDeviceCommand *command = self.device.commands[(NSUInteger) indexPath.row];
        cell.textLabel.text = command.name;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Protocol: %@. Tags: %@", command.protocol, [[command.tags allObjects] componentsJoinedByString:@", "]];
    } else if (indexPath.section == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"SensorCell"];
        ORDeviceSensor *sensor = self.device.sensors[(NSUInteger) indexPath.row];
        cell.textLabel.text = sensor.name;
        cell.detailTextLabel.text = [self valueForSensorType:sensor.type];
    }
    return cell;
}

- (NSString *)valueForSensorType:(SensorType)type
{
    switch(type) {
        case SensorTypeUnknown:
            return @"Unknown";
        case SensorTypeSwitch:
            return @"Switch";
        case SensorTypeLevel:
            return @"Level";
        case SensorTypeRange:
            return @"Range";
        case SensorTypeColor:
            return @"Color";
        case SensorTypeCustom:
            return @"Custom";
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        ORDeviceCommand *command = self.device.commands[(NSUInteger) indexPath.row];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self.orb executeCommand:command withParameter:nil successHandler:^{
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }           errorHandler:^(NSError *error) {
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Error" message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
            [ac addAction:[UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:ac animated:YES completion:nil];
        }];
    }

}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Commands";
    } else if (section == 1) {
        return @"Sensors";
    } else {
        return nil;
    }

}

@end
