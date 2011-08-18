//
//  MainViewController.h
//  WriteNow
//
//  Created by Keith Fernandes on 8/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"

@interface MainViewController : UINavigationController <UITextViewDelegate> {
    
    
	UINavigationController *navigationController;
    
    NSManagedObjectContext *managedObjectContext;

}

@property (nonatomic, retain) UINavigationController *navigationController;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;


//- (void) makeToolbar;


@end
