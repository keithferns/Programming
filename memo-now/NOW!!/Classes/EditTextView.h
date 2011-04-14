//
//  EditTextView.h
//  NOW!!
//
//  Created by Keith Fernandes on 4/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EditTextView : UITextView {
		//UIColor *backgroundColor;
	UIView *inputView;
		//UIEventType *eventtype;
		//UITouch *touch;
		//NSString *const UITextFieldTextDidBeginEditingNotification;
}

	//@property(nonatomic, copy) UIColor *backgroundColor;
@property(readwrite, retain) UIView *inputView;
	//@property(nonatomic, retain) UITouch *touch;
	//@property(readonly) UIEventType type; 



@end
