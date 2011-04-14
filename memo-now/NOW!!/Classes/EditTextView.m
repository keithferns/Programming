//
//  EditTextView.m
//  NOW!!
//
//  Created by Keith Fernandes on 4/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EditTextView.h"


@implementation EditTextView

	//@synthesize backgroundColor;
@synthesize inputView;
	//@synthesize touch;
	//@synthesize type; 

	//[self setBackgroundColor:[UIColor blueColor]];




    
 //    self = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
	

    

/*
-(void)sendEvent:(UIEvent *)event {
		//loop over touches for this event
	for(UITouch *touch in [event allTouches]) {
		BOOL touchEnded = (touch.phase == UITouchPhaseEnded);
		BOOL isSingleTap = (touch.tapCount == 1);
		BOOL isHittingEditTextView =
		(touch.view.class == [EditTextView class]);
		if(touchEnded && isSingleTap && isHittingEditTextView) {
			EditTextView *tv = (EditTextView *)touch.view;
			[tv tapOccurred:touch withEvent:event];
		}
	}
	[super sendEvent:event];
}

}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *aTouch = [touches anyObject];
    if (aTouch.tapCount == 1) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
    }
}
*/ 


- (void)dealloc {
    [super dealloc];
}


@end
