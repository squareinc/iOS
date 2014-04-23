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
#import "PaginationController.h"
#import "ScreenViewController.h"
#import "GroupController.h"
#import "ORControllerClient/ORObjectIdentifier.h"
#import "ORControllerClient/ORGroup.h"
#import "ORControllerClient/ORScreen.h"
#import "ORControllerClient/ORTabBar.h"
#import "ORControllerClient/ORTabBarItem.h"
#import "ORControllerClient/ORImage.h"
#import "ORControllerClient/ORLabel.h"
#import "ORControllerClient/Definition.h"
#import "ORControllerClient/ORNavigation.h"
#import "ORControllerClient/ORScreenNavigation.h"
#import "ORConsoleSettingsManager.h"
#import "ORConsoleSettings.h"
#import "ORControllerConfig.h"
#import "DirectoryDefinition.h"
#import "NotificationConstant.h"
#import "ORScrollView.h"
#import "ImageCache.h"

#define PAGE_CONTROL_HEIGHT 20
#define kTabBarHeight 49.0

@interface PaginationController ()

- (void)initView;
- (void)updateView;
- (void)initViewForPage:(NSUInteger)page;
- (void)updateViewForPage:(NSUInteger)page;
- (void)updateViewForCurrentPage;
- (void)updateViewForCurrentPageAndBothSides;
- (void)pageControlValueDidChange:(id)sender;
- (void)scrollToSelectedViewWithAnimation:(BOOL)withAnimation;
- (BOOL)switchToScreen:(ORScreen *)aScreen withAnimation:(BOOL) withAnimation;
- (void)updateTabBarItemSelection;

@property (nonatomic, strong) ORGroup *group;
@property (nonatomic, strong) ORTabBar *tabBar;
@property (nonatomic, weak) UITabBar *uiTabBar;

@end

@implementation PaginationController

- (id)initWithGroup:(ORGroup *)aGroup tabBar:(ORTabBar *)aTabBar
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.group = aGroup;
        if (self.group.tabBar) {
            self.tabBar = self.group.tabBar;
        } else {
            self.tabBar = aTabBar;
        }
    }
    return self;
}

- (void)dealloc
{
    self.uiTabBar.delegate = nil;
    self.uiTabBar = nil;
    self.imageCache = nil;
}

/**
 * Assign the ScreenViewController array to paginationController with landscape boolean value.
 */
- (void)setViewControllers:(NSArray *)newViewControllers isLandscape:(BOOL)isLandscapeOrientation {
	isLandscape = isLandscapeOrientation;
	CGSize size = [UIScreen mainScreen].bounds.size;
	frameWidth = isLandscape ? size.height : size.width;
	frameHeight = isLandscape ? size.width : size.height;

	for (UIView *view in [scrollView subviews]) {
		[view removeFromSuperview];
	}
	
	viewControllers = newViewControllers;
	
	//Recover last screen
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    ORObjectIdentifier *lastScreenIdenfitier = [[ORObjectIdentifier alloc] initWithStringId:[userDefaults objectForKey:@"lastScreenId"]];
	NSLog(@"last screen id = %@", lastScreenIdenfitier);
	
	if (lastScreenIdenfitier) {
		for (int i = 0; i < [viewControllers count]; i++) {
			if ([lastScreenIdenfitier isEqual:[(ORScreen *)[[viewControllers objectAtIndex:i] screen] identifier]]) {
//				UIViewController *vc = [viewControllers objectAtIndex:i];
                // TODO: ebr : check why this is ???
//				vc.view.bounds = scrollView.bounds;
				selectedIndex = i;
				break;
			}
		}
	} else {
		selectedIndex = 0;
	}
}

- (BOOL)switchToFirstScreen {
	return [self switchToScreen:((ScreenViewController *)[viewControllers objectAtIndex:0]).screen];
}

- (ScreenViewController *)currentScreenViewController {
	return [viewControllers objectAtIndex:selectedIndex]; 
}

- (void)initView {
	[scrollView setContentSize:CGSizeMake(frameWidth * [viewControllers count], frameHeight)];
	[pageControl setNumberOfPages:[viewControllers count]];
	[self updateViewForCurrentPage];
}

- (void)updateView {
	[scrollView setContentSize:CGSizeMake(frameWidth * [viewControllers count], frameHeight)];
	[pageControl setNumberOfPages:[viewControllers count]];
	[self updateViewForCurrentPageAndBothSides];
}

//Return YES if succuess, without animation.
- (BOOL)switchToScreen:(ORScreen *)aScreen {
	return [self switchToScreen:aScreen withAnimation:NO];
}

//Return YES if succuess
- (BOOL)switchToScreen:(ORScreen *)aScreen withAnimation:(BOOL) withAnimation {
	int index = -1;
	for (int i = 0; i< viewControllers.count; i++) {
		ScreenViewController *svc = (ScreenViewController *)[viewControllers objectAtIndex:i];
		if ([svc.screen.identifier isEqual:aScreen.identifier]) {
			index = i;
			break;
		}
	}
	if (index != -1) {//found screen in current orientation
		selectedIndex = index;
		NSLog(@"switch to screen index = %lu, id = %@ animation=%d", (unsigned long)selectedIndex, aScreen.identifier, withAnimation);
		[pageControl setCurrentPage:selectedIndex];
		[self scrollToSelectedViewWithAnimation:withAnimation];
	} else {
		// not found, may be in the opposite orientation, or a invalid screenId.
		return NO;
	}
	
    [self updateTabBarItemSelection];
	return YES;
}

//Return YES if succuess
- (BOOL)previousScreen {
	if (selectedIndex == 0) {
		return NO;
	}
	selectedIndex--;
	[pageControl setCurrentPage:selectedIndex];
	[self scrollToSelectedViewWithAnimation:YES];
	return YES;
}

//Return YES if succuess
- (BOOL)nextScreen {
	if (selectedIndex == pageControl.numberOfPages - 1) {
		return NO;
	}
	selectedIndex++;
	[pageControl setCurrentPage:selectedIndex];
	[self scrollToSelectedViewWithAnimation:YES];
	return YES;
}

// Save last screen's id while switching screen view for recovery of lastScreenView in RootViewController.
- (void)saveLastScreen {
	if (selectedIndex < viewControllers.count) {
		ORObjectIdentifier *lastScreenIdentifier = ((ScreenViewController *)[viewControllers objectAtIndex:selectedIndex]).screen.identifier;
		if (!lastScreenIdentifier) {
			return;
		}
		NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
		[userDefaults setObject:[lastScreenIdentifier stringValue] forKey:@"lastScreenId"];
	}
}

// Refresh the current screenView.
- (void)updateViewForCurrentPage {
	[self initViewForPage:selectedIndex];
	[pageControl setCurrentPage:selectedIndex];
    [self updateTabBarItemSelection];
}

// Refresh the current screenView, previous screenView and next screenView.
- (void)updateViewForCurrentPageAndBothSides {
	[self updateViewForPage:selectedIndex - 1];
	[self updateViewForPage:selectedIndex];
	[self updateViewForPage:selectedIndex + 1];
    [self updateTabBarItemSelection];

	[pageControl setCurrentPage:selectedIndex];
	[self saveLastScreen];
}

// Init current screen view of paginationController with specified page index.
- (void)initViewForPage:(NSUInteger)page {
	if (page >= [viewControllers count]) return;
	UIViewController *controller = [viewControllers objectAtIndex:page];
	
	if (controller.view.superview != scrollView) {
		CGRect frame = scrollView.bounds;
		frame.origin.x = frameWidth * page;
		[controller.view setFrame:frame];
		scrollView.contentOffset = CGPointMake(frame.origin.x, 0);
		[scrollView addSubview:controller.view];
	}
	
	if (page == selectedIndex) {
		[((ScreenViewController *)controller) startPolling];
	} else {
		[((ScreenViewController *)controller) stopPolling];
	}
}

// Refresh the screenView page index specified.
- (void)updateViewForPage:(NSUInteger)page {
	if (page >= [viewControllers count]) return;
	UIViewController *controller = [viewControllers objectAtIndex:page];
    
	CGRect frame = scrollView.bounds;
	frame.origin.x = frameWidth * page;
	[controller.view setFrame:frame];
	if (controller.view.superview != scrollView) {
		[scrollView addSubview:controller.view];
	}
	
	if (page == selectedIndex) {
		[((ScreenViewController *)controller) startPolling];
	} else {
		[((ScreenViewController *)controller) stopPolling];
	}	
}

//if you have changed *selectedIndex* then calling this method will scroll to that seleted view immediately
- (void)scrollToSelectedViewWithAnimation:(BOOL)withAnimation {
	
	//HACK: clear 2nd view, it's a hack, beause 2nd view always cover 1st view.
	//TODO: should fix this hack.
	if (withAnimation == NO && selectedIndex == 0 && viewControllers.count > 1) {
		UIViewController *vc = [viewControllers objectAtIndex:1];
		[vc.view removeFromSuperview];
	}
	
	[self updateViewForCurrentPage];
	CGRect frame = scrollView.bounds;

	frame.origin.x = frameWidth * selectedIndex;
	frame.origin.y = 0;
	[scrollView scrollRectToVisible:frame animated:withAnimation];
}

- (void)loadView {
	[super loadView];
	[self.view setFrame:CGRectMake(0, 0, frameWidth, frameHeight)];

	scrollView = [[ORScrollView alloc] init];
	[scrollView setDelegate:self];
	[scrollView setPagingEnabled:YES];
	[scrollView setShowsVerticalScrollIndicator:NO];
	[scrollView setShowsHorizontalScrollIndicator:NO];
	[scrollView setScrollsToTop:NO];
	[scrollView setOpaque:YES];
	[scrollView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    // Scroll view takes whole screen height, even if a tab bar is present
    // This is so the rendering on iOS console is in sync with how the modeler presents it
	[scrollView setFrame:CGRectMake(0, 0, frameWidth, frameHeight)];
	[scrollView setBackgroundColor:[UIColor blackColor]];
	[self.view addSubview:scrollView];
	pageControl = [[UIPageControl alloc] init];
	if (viewControllers.count > 1) {
		[pageControl setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth];
		[pageControl setFrame:CGRectMake(0, frameHeight - PAGE_CONTROL_HEIGHT - (self.tabBar?kTabBarHeight:0.0), frameWidth, PAGE_CONTROL_HEIGHT)];
		[pageControl setBackgroundColor:[UIColor clearColor]];
		[pageControl setOpaque:NO];
		[pageControl addTarget:self action:@selector(pageControlValueDidChange:) forControlEvents:UIControlEventValueChanged];
		[self.view addSubview:pageControl];
	}
    // Tab bar added latest so it sits on top of other views
    if (self.tabBar) {
        UITabBar *tmpBar = [[UITabBar alloc] initWithFrame:CGRectMake(0.0, frameHeight - kTabBarHeight, frameWidth, kTabBarHeight)];
        self.uiTabBar = tmpBar;
        [self.view addSubview:self.uiTabBar];
        NSMutableArray *tmpItems = [NSMutableArray arrayWithCapacity:[self.tabBar.items count]];
        // Not using fast iteration but standard for loop to have access to object index
        for (int i = 0; i < [self.tabBar.items count]; i++) {
            ORTabBarItem *item = [self.tabBar.items objectAtIndex:i];
            UITabBarItem *uiItem = [[UITabBarItem alloc] initWithTitle:item.label.text image:nil tag:i];
            UIImage *itemImage = [self.imageCache getImageNamed:item.image.src finalImageAvailable:^(UIImage *image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    uiItem.image = image;
                });
            }];
            if (itemImage) {
                uiItem.image = itemImage;
            }
            [tmpItems addObject:uiItem];
        }
        self.uiTabBar.items = tmpItems;
        self.uiTabBar.delegate = self;
    }

    [self initView];
}

- (void)didReceiveMemoryWarning {
	// Our view will be released when it has no superview, so set these references to nil
	if (self.view.superview == nil) {
		scrollView = nil;
		pageControl = nil;
	}
	
	[super didReceiveMemoryWarning];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
	// Switch the indicator when more than 50% of the previous/next page is visible
    int calculatedIndex = floor((scrollView.contentOffset.x - frameWidth / 2) / frameWidth) + 1;
    selectedIndex = MIN(MAX(0, calculatedIndex), [viewControllers count] - 1);
	[self updateViewForCurrentPageAndBothSides];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)s {
	//HACK: correct hacked larger ContentSize back to normal.
	//TODO: should fix this hack.
// EBR - 20111024 - Not sure if this is of any use
//	[scrollView setContentSize:CGSizeMake(frameWidth * pageControl.numberOfPages, frameHeight)];
}

- (void)pageControlValueDidChange:(id)sender {
	selectedIndex = pageControl.currentPage;
	[self updateViewForCurrentPageAndBothSides];
	
	CGRect frame = scrollView.bounds;
	frame.origin.x = frameWidth * selectedIndex;
	frame.origin.y = 0;
	[scrollView scrollRectToVisible:frame animated:YES];

	// DENNIS: Maybe you want to make sure that the user can't interact with the scroll view while it is animating.
	//[scrollView setUserInteractionEnabled:NO];
}

- (void)viewWillAppear:(BOOL)animated {
	[self initView];
    [super viewWillDisappear:animated];
}

/**
 * Verify that the screen that is current displayed is the target of the navigation of an item in the tab bar.
 * If it is, select that item. Items are search in order and the first one matching is selected.
 * If no matching item is found, selection is cleared.
 */
- (void)updateTabBarItemSelection
{
    NSUInteger selected = NSNotFound;
    
    for (ORTabBarItem *tabBarItem in self.tabBar.items) {
		if (tabBarItem.navigation && tabBarItem.navigation.navigationType == ORNavigationTypeToGroupOrScreen) {
            ORScreenNavigation *navigation = ((ORScreenNavigation *)tabBarItem.navigation);
            if ([self.group.identifier isEqual:navigation.destinationGroup.identifier]) {
                if (!navigation.destinationScreen || [navigation.destinationScreen.identifier isEqual: [self currentScreenViewController].screen.identifier]) {
                    selected = [self.tabBar.items indexOfObject:tabBarItem];
                    break;
                }
			}
		}
    }
    self.uiTabBar.selectedItem = (selected != NSNotFound)?[self.uiTabBar.items objectAtIndex:selected]:nil;
}

#pragma mark UITabBar delegate

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    ORTabBarItem *tabBarItem = [self.tabBar.items objectAtIndex:item.tag];
	if (tabBarItem && tabBarItem.navigation) {
		[[NSNotificationCenter defaultCenter] postNotificationName:NotificationNavigateTo object:tabBarItem.navigation];
	}
    
    // ! Do not do anything anymore here as after the navigation, self will be released if we moved to a different group
}

@synthesize group;
@synthesize tabBar;
@synthesize uiTabBar;
@synthesize viewControllers, selectedIndex;

@end
