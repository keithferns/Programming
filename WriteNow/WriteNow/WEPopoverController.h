//
//  PopupViewController.h
//  WEPopover
//
//  Created by Werner Altewischer on 02/09/10.
//  Copyright 2010 Werner IT Consultancy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WEPopoverContainerView.h"

@class WEPopoverController;

@protocol PopoverControllerDelegate<NSObject>

- (void)popoverControllerDidDismissPopover:(WEPopoverController *)popoverController;
- (BOOL)popoverControllerShouldDismissPopover:(WEPopoverController *)popoverController;

@end

@interface WEPopoverController : NSObject {
	UIViewController *contentViewController;
	UIView *view;
	NSString *name;
    
	BOOL popoverVisible;
	UIPopoverArrowDirection popoverArrowDirection;
	id <PopoverControllerDelegate> delegate;
	CGSize popoverContentSize;
	WEPopoverContainerViewProperties *containerViewProperties;
	id <NSObject> context;
    
    UITapGestureRecognizer *tapGesture;
    UIView *parentView;
}

@property(nonatomic, retain) UIViewController *contentViewController;

@property (nonatomic, readonly) UIView *view;
@property (nonatomic, assign) NSString *name;

@property (nonatomic, readonly, getter=isPopoverVisible) BOOL popoverVisible;
@property (nonatomic, readonly) UIPopoverArrowDirection popoverArrowDirection;
@property (nonatomic, assign) id <PopoverControllerDelegate> delegate;
@property (nonatomic, assign) CGSize popoverContentSize;
@property (nonatomic, retain) WEPopoverContainerViewProperties *containerViewProperties;
@property (nonatomic, retain) id <NSObject> context;

- (void) addName:(NSString *)string;
- (NSString *) returnName;

- (id)initWithContentViewController:(UIViewController *)theContentViewController;

- (void)dismissPopoverAnimated:(BOOL)animated;

/*- (void)presentPopoverFromRect:(CGRect)rect 
						inView:(UIView *)view 
	  permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections 
					  animated:(BOOL)animated;
*/
- (void)presentPopoverFromRect:(CGRect)rect 
						inView:(UIView *)view 
	  permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections 
					  animated:(BOOL)animated name:(NSString *)name;
- (void)repositionPopoverFromRect:(CGRect)rect
		 permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections;

- (void)parentViewTapped:(UITapGestureRecognizer *)tapGesture;
@end
