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
    NSNumber *eventType;
    Note *theNote;
    Appointment *theAppointment;
    ToDo *theToDo;
    Memo *theMemo;
    Project *theProject;
    Folder *theFolder;
    Document *theDocument;
    NSString *recurring;
    NSManagedObjectContext *_addingContext;
}

@property (nonatomic, retain) NSManagedObjectContext *addingContext;
@property (nonatomic, retain) NSString *recurring;
@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) Note *theNote;
@property (nonatomic, retain) Appointment *theAppointment;
@property (nonatomic, retain) ToDo *theToDo;
@property (nonatomic, retain) Memo *theMemo;
@property (nonatomic, retain) Project *theProject;
@property (nonatomic, retain) Folder *theFolder;
@property (nonatomic, retain) Document *theDocument;
@property (nonatomic, retain) NSNumber *eventType;


- (void) createNewItem:(NSString *)text ofType:(NSNumber *)type;
- (void) addDateField;

- (void) updateSelectedDate:(NSDate *)date;
- (void) saveNewItem;
- (void) deleteItem:(id)sender;


@end