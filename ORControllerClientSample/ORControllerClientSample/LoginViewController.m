/*
 * OpenRemote, the Home of the Digital Home.
 * Copyright 2008-2012, OpenRemote Inc.
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
#import "LoginViewController.h"
#import "ORControllerClient/Definition.h"

@interface LoginViewController ()

@property (nonatomic, weak) NSObject <LoginViewControllerDelegate> *delegate;

@end

@implementation LoginViewController

- (id)initWithDelegate:(NSObject <LoginViewControllerDelegate> *)aDelegate
{
    self = [super initWithNibName:@"LoginViewController" bundle:nil];
	if (self) {
        self.delegate = aDelegate;
	}
	return self;
}

// Back to the view where loginView was triggered from.
- (IBAction)cancel
{
    [self.delegate loginViewControllerDidCancelLogin:self];
}

// Send sign in request to remote controller server by loginViewController's delegate.
- (IBAction)login
{
	if (self.usernameField.text == nil || self.passwordField.text == nil ||
			[@"" isEqualToString:self.usernameField.text] || [@"" isEqualToString:self.passwordField.text]) {
		[[[UIAlertView alloc] initWithTitle:@"" message:@"No username or password entered." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
	}
    [self.delegate loginViewController:self didProvideUserName:self.usernameField.text password:self.passwordField.text];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{	
	if ([@"" isEqualToString:self.usernameField.text]) {
		[self.usernameField becomeFirstResponder];
		return YES;
	} else {
		[self.passwordField becomeFirstResponder];		
	}
	
	if ([@"" isEqualToString:self.passwordField.text]) {
		[self.passwordField becomeFirstResponder];
		return YES;
	} else {
		[self.usernameField becomeFirstResponder];
	}
	
	[self login];

	return YES;
}

@synthesize usernameField;
@synthesize passwordField;
@synthesize delegate;

@end