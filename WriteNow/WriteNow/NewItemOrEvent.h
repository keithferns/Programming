//
//  NewMemo.h
//  WriteNow
//
//  Created by Keith Fernandes on 11/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol NewItemOrEventDelegate <NSObject>


@end

@interface NewItemOrEvent : NSObject  {
    
    id<NewItemOrEventDelegate> delegate;
    Note *newNote;
    NSString *recurring;
    NSManagedObjectContext *_addingContext;
}
@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) Note *newNote;
@property (nonatomic, retain) NSManagedObjectContext *addingContext;
@property (nonatomic, retain) NSString *recurring;

- (void) createNewItem:(NSString *)text ofType:(NSNumber *)type;
- (void) addDateField;
- (void) setDoDate;
- (void) saveNewItem;



@end