//
//  MyDataObject.h
//  WriteNow
//
//  Created by Keith Fernandes on 9/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDataObject.h"

@interface MyDataObject : AppDataObject {
    
    Appointment *selectedAppointment;
    Task *selectedTask;
    Memo *selectedMemo;
    Note *myNote;
    NSNumber *noteType;
    NSDate *myDate;
    NSString *myText;
}

@property (nonatomic, retain) Note *myNote;
@property (nonatomic, retain) NSString *myText;
@property (nonatomic, retain) NSDate *myDate;
@property (nonatomic, retain) NSNumber *noteType;
@property (nonatomic, retain) Appointment *selectedAppointment;
@property (nonatomic, retain) Task *selectedTask;
@property (nonatomic, retain) Memo *selectedMemo;

@end
