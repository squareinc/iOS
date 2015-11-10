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

#import <ORControllerClient/ORController.h>
#import "ORLabelsViewController.h"
#import "ORViewController_Private.h"
#import "ORControllerClient/ORLabel.h"

@interface ORLabelsViewController ()

@property (nonatomic, strong) NSArray *labels;

@end

@implementation ORLabelsViewController

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

    // If we did register previously to observe on model objects, un-register
    [self stopObservingLabelChanges];
    self.labels = nil;
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
    cell = [tableView dequeueReusableCellWithIdentifier:@"LabelCell"];
    cell.textLabel.text = ((ORLabel *) self.labels[(NSUInteger) indexPath.row]).text;
    return cell;
}

- (void)startPolling
{
    [self stopPolling];
    [super startPolling];
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
    [super stopPolling];
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


@end
