//
//  myMemoAppDelegate.h
//  myMemo
//
//  Created by Keith Fernandes on 7/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class myMemoViewController;

@interface myMemoAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet myMemoViewController *viewController;

@end
