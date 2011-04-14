//
//  TestViewController.h
//  TestCustomTextView
//
//  Created by Keith Fernandes on 4/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditTextView.h"

@interface TestViewController : UIViewController {

	EditTextView *newTV;

}


@property (nonatomic, retain) IBOutlet EditTextView *newTV;



@end
