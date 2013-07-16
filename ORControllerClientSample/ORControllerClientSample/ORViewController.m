//
//  ORViewController.m
//  ORControllerClientSample
//
//  Created by Eric Bariaux on 15/07/13.
//  Copyright (c) 2013 OpenRemote. All rights reserved.
//

#import "ORViewController.h"
#import "ORControllerAddress.h"
#import "ORController.h"
#import "ORLabel.h"

@interface ORViewController ()

@property (nonatomic, strong) NSArray *labels;

@end

@implementation ORViewController

- (void)viewWillAppear:(BOOL)animated
{
    ORControllerAddress *address = [[ORControllerAddress alloc] initWithPrimaryURL:[NSURL URLWithString:@"http://localhost:8688/controller"]];
    ORController *orb = [[ORController alloc] initWithControllerAddress:address];
    [orb connectWithSuccessHandler:^{
        [orb readControllerConfigurationWithSuccessHandler:^{
            self.labels = [[orb allLabels] allObjects];
            [self.tableView reloadData];
        } errorHandler:NULL];
    } errorHandler:NULL];
    [super viewWillAppear:animated];
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

@end
