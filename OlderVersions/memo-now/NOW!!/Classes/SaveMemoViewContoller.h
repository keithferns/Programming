//
//  SaveMemoViewContoller.h
//  NOW!!
//
//  Created by Keith Fernandes on 4/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
	//KF: use "--{" to designate beginning of a new screen description and "}--" to designate the end.

/*	
		WISHDO: 
		Backend categorization of Memos based on terms found in body of note or tags/keywords (if tagging feature is implemented). Automated Categorization would be key feature of future brainy_app but will require sophisticated search algorithms. This might just be possible with a collection of short notes but not so easy with longer documents unless these are explicitly tagged (RESEARCH: Other than Spotlight, and like search-engines, what programs  specifically look for tags/keywords in pdfs?).
		
		IMPLIMENTATION: 
		Could I adapt a POS-Tagger to do the job? Lexical 'clustering' might provide one source of information for tagger (RESEARCH: Semantic Web?).  (COGITATE: Other aids to categorizing.)
	
	
		USES
			- finds Orphan Memos a foster folder until such time as user places them. Makes suggestions.
			- anticipates screen contents in saving Memos by discovering likely folders (best-match) as user types. again depends on quality of search algorithm. 
			- .....
 
Table Cells:
 --{ 1. SAVE [MEMO] To [FOLDER]
			--{ [Save to <table view of 5 cells] or [5 Folder Icons for 5 folders]
			1. NEW --{[NAME][TAG]...... brainyapp to provide discreet suggestions.}-- 
			2. "most_recent"		--{[Most Recently Used Folder, obviously]}--
			3. "1st most_used"		--{ ..}--
			4. "2nd most_used"		--{		}--
			5. "MORE				-- {More Folders ranked by Use/Recency/Relevance(term matching)}--
			}--  
	 2. APPEND [MEMO] To [LIST]/[NOTE] (see above). 
	 3. SCHEDULE [APPOINTMENT] -- {DateTimeView}--
	 4. REMIND [TODO/EVENT] -- {DateTimeView with flexible options (Today, Tomorrow, This week, This Month, Recurring (note: recurring should have reminders further in advance of date. Maybe, default to 2 weeks for annual recurring like anniversaries and bdays etc, and 1 week for monthly recurring like bills.}-- 
	 5. OTHER [??????]
 }--
 
 */

@interface SaveMemoViewContoller : UITableViewController {

		//UIButton *backButton;
	
		//FIX:  reusing some of the buttons.  make separate classes for each. 
	
}

	//@property(nonatomic, retain) IBOutlet UIButton *backButton;

	//- (IBAction)backAction:(id)sender;

@end

