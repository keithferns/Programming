//
//  CustomTextView.h
//  iDoit
//
//  Created by Keith Fernandes on 11/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTextView : UITextView {

    BOOL isEditing;
    
}

@property (nonatomic, readwrite) BOOL isEditing;

@end
