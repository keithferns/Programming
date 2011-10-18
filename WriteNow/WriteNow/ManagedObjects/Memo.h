//
//  Memo.h
//  WriteNow
//
//  Created by Keith Fernandes on 10/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Note.h"

@class File, Folder, Tag;

@interface Memo : Note {
@private
}
@property (nonatomic, retain) NSDate * editDate;
@property (nonatomic, retain) NSSet* tags;
@property (nonatomic, retain) Folder * folder;
@property (nonatomic, retain) File * file;

@end
