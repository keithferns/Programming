//
//  NewAppointment.h
//  WriteNow
//
//  Created by Keith Fernandes on 10/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NewAppointmentDelegate <NSObject>

- (void ) addPickerControls;

@end

@interface NewAppointment : NSObject  {
 
    id<NewAppointmentDelegate> delegate;
    Appointment *newAppointment;
    NSManagedObjectContext *addingContext;
}
@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) Appointment *newAppointment;
@property (nonatomic, retain) NSManagedObjectContext *addingContext;

- (void) createNewAppointment:(NSString *)text;
- (void) addDateField;
- (void) setDoDate;
- (void) saveNewAppointment;



@end
