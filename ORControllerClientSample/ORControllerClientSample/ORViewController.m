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
#import "ORControllerAddress.h"
#import "ORController.h"
#import "ORLabel.h"
#import "Definition.h"

@interface ORViewController ()

@property (nonatomic, strong) NSArray *labels;

@end

@implementation ORViewController

- (void)viewWillAppear:(BOOL)animated
{
    ORControllerAddress *address = [[ORControllerAddress alloc] initWithPrimaryURL:[NSURL URLWithString:@"http://localhost:8688/controller"]];
    ORController *orb = [[ORController alloc] initWithControllerAddress:address];
    [orb connectWithSuccessHandler:^{
        [orb requestPanelUILayout:@"panel1" successHandler:^(Definition *definition) {
            self.labels = [definition.labels allObjects];
            // Register on all model objects to observe any change on their value
            [self.labels enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [obj addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:NULL];
            }];
            [self.tableView reloadData];

        } errorHandler:^(NSError *error) {
            // TODO
        }];
    } errorHandler:NULL];
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    // If we did register previously to observe on model objects, un-register
    if (self.labels) {
        [self.labels enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [obj removeObserver:self];
        }];
    }
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

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self.tableView reloadData];
}

@end
