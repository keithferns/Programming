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
    Note *theNote;
    Appointment *theAppointment;
    Task *theTask;
    Memo *theMemo;
    NSString *recurring;
    NSManagedObjectContext *_addingContext;
}
@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) Note *theNote;
@property (nonatomic, retain) NSManagedObjectContext *addingContext;
@property (nonatomic, retain) NSString *recurring;
@property (nonatomic, retain) Appointment *theAppointment;
@property (nonatomic, retain) Task *theTask;
@property (nonatomic, retain) Memo *theMemo;

- (void) createNewItem:(NSString *)text ofType:(NSNumber *)type;
- (void) addDateField;

- (void) updateSelectedDate:(NSDate *)date;

- (void) saveNewItem;
- (void) deleteItem:(id)sender;


@end