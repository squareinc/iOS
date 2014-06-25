//
//  ORControllerPickerViewController.h
//  ORControllerClientSample
//
//  Created by Eric Bariaux on 25/06/14.
//  Copyright (c) 2014 OpenRemote. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ORControllerPickerViewController;
@class ORControllerInfo;

@protocol ORControllerPickerViewControllerDelegate <NSObject>

- (void)controllerPicker:(ORControllerPickerViewController *)picker didPickController:(ORControllerInfo *)controller;
- (void)controllerPickerDidCancelPick:(ORControllerPickerViewController *)picker;

@end

@interface ORControllerPickerViewController : UITableViewController

@property (nonatomic, weak) NSObject <ORControllerPickerViewControllerDelegate> *delegate;

@end
