//
//  TVHandlerAppDelegate.m
//  TVHandler
// 
// 	Copyright (c) 2009 Patrick Quinn-Graham
// 
// 	Permission is hereby granted, free of charge, to any person obtaining
// 	a copy of this software and associated documentation files (the
// 	"Software"), to deal in the Software without restriction, including
// 	without limitation the rights to use, copy, modify, merge, publish,
// 	distribute, sublicense, and/or sell copies of the Software, and to
// 	permit persons to whom the Software is furnished to do so, subject to
// 	the following conditions:
// 
// 	The above copyright notice and this permission notice shall be
// 	included in all copies or substantial portions of the Software.
// 
// 	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// 	EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// 	MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// 	NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
// 	LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
// 	OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
// 	WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "TVHandlerAppDelegate.h"
#import "RegexKitLite.h"

@implementation TVHandlerAppDelegate

@synthesize window, numberOfFiles, progressInfo, progressBar;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	turbo = [[SBApplication applicationWithBundleIdentifier:@"com.elgato.Turbo"] retain];
	[turbo activate];
	tvmagic = [[SBApplication applicationWithBundleIdentifier:@"com.pftqg.TVMagic2"] retain];
	[tvmagic activate];
	
	testing = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(doTimer:) userInfo:nil repeats:YES];
	[testing fire];
	waitingList = [[NSMutableArray arrayWithCapacity:10] retain];
}

-(void)populateFiles {
	NSString *p = [[NSUserDefaults standardUserDefaults] valueForKey:@"OriginalFiles"];
	NSError *err;	
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSArray *arr = [fileManager contentsOfDirectoryAtPath:p error:&err];

	[waitingList removeAllObjects];
	for(NSString *file in arr) {
		if([[file pathExtension] isEqualToString:@"m2t"]) {
			[waitingList addObject:file];
		}
	}
	[numberOfFiles setTitleWithMnemonic:[NSString stringWithFormat:@"%d", [waitingList count]]];
	
	[progressBar setMaxValue:[waitingList count]];
	[progressBar setDoubleValue:0];
	[progressInfo setTitleWithMnemonic:@"Starting up..."];
}

-(void)nextFile {
	if([waitingList count] == 0) {
		[progressInfo setTitleWithMnemonic:@"Idle."];
		[progressBar setDoubleValue:[progressBar maxValue]];
		return;
	}
	
	NSString *nextFile = [waitingList lastObject];
	if(!nextFile) {
		[progressInfo setTitleWithMnemonic:@"Idle."];
		[progressBar setDoubleValue:[progressBar maxValue]];
		return;
	}
	
	[progressBar setDoubleValue:([progressBar maxValue] - [waitingList count])];
	
	NSString *originalFiles = [[NSUserDefaults standardUserDefaults] valueForKey:@"OriginalFiles"];
	NSString *moveFilesTo = [[NSUserDefaults standardUserDefaults] valueForKey:@"MoveFilesTo"];

	NSLog(@"At this point nextFile is: %@", nextFile);
	encodingFile = [[NSURL fileURLWithPath:[originalFiles stringByAppendingPathComponent:nextFile]] retain];
	NSString *nextFileOutput = [nextFile stringByReplacingOccurrencesOfRegex:@"m2t$" withString:@"m4v"];
	encodingFileOutput = [[NSURL fileURLWithPath:[originalFiles stringByAppendingPathComponent:nextFileOutput]] retain];
	encodingFileDestination = [[NSURL fileURLWithPath:[moveFilesTo stringByAppendingPathComponent:nextFileOutput]] retain];
	
	[progressInfo setTitleWithMnemonic:nextFile];
	[turbo     addFile:encodingFile 
	   withDestination:encodingFileOutput 
		   exportingAs:TurboEtypCustom 
	 withCustomSetting:@"PatrickPVR" 
			 replacing:NO];
	[turbo encodeNoErrorDialogs:nil];
	
	[waitingList removeLastObject]; // remove this file from the waiting list	
}

-(void)cleanupLastFile {
	NSError *err = nil;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if(![fileManager fileExistsAtPath:[encodingFileOutput path]] || 
	   [turbo lastErrorCode] != 0) {
		NSURL *failedPath = [NSURL fileURLWithPath:[[encodingFile path] stringByAppendingPathExtension:@"failed"]];
		if(![fileManager moveItemAtURL:encodingFile toURL:failedPath error:&err]) {
			[[NSAlert alertWithError:err] runModal];
		}
		if([fileManager fileExistsAtPath:[encodingFileOutput path]]) {
			if(![fileManager removeItemAtURL:encodingFileOutput error:&err]) {
				[[NSAlert alertWithError:err] runModal];
			}
		}

	// If output file exists then assume all went to plan...	
	} else {
		// move encodingFileOutput to encodingFileDestination
		if(![fileManager moveItemAtURL:encodingFileOutput toURL:encodingFileDestination error:&err]) {
			[[NSAlert alertWithError:err] runModal];
		} else {
			[tvmagic transferToItunes:encodingFileDestination];
			// delete encodingFile
			if(![fileManager removeItemAtURL:encodingFile error:&err]) {
				[[NSAlert alertWithError:err] runModal];
			}
		}
	}
	// done!
	[encodingFile release];
	[encodingFileOutput release];
	[encodingFileDestination release];
	encodingFile = nil;
	encodingFileOutput = nil;
	encodingFileDestination = nil;
}

-(void)doTimer:(id)sender {
	if(turbo.isEncoding) {
		// then nothing changes, we are still waiting...
	} else {
		// are we waiting on a file?
		if(encodingFile != nil) {
			// Clean up this file, and move it to the destination.
			[self cleanupLastFile];
		}
		// have we got any files left in the waiting list?
		// if not populate it...
		if([waitingList count] == 0) {
			[self populateFiles];
		}
		[self nextFile];
	}
}

#pragma mark -
#pragma mark Handle UI Actions

-(IBAction)changeMoveTo:(id)sender {
	NSOpenPanel *openPanel = [NSOpenPanel openPanel];
	[openPanel setCanChooseDirectories:YES];
	[openPanel setCanCreateDirectories:YES];
	[openPanel setPrompt:@"Choose destination folder"];
	[openPanel setCanChooseFiles:NO];	
	[openPanel beginSheetForDirectory:nil file:nil types:nil modalForWindow:self.window modalDelegate:self 
					   didEndSelector:@selector(changeLookForOpenPanelDidEnd:returnCode:contextInfo:) contextInfo:@"MoveFilesTo"];
}
-(IBAction)changeLookFor:(id)sender {
	NSOpenPanel *openPanel = [NSOpenPanel openPanel];
	[openPanel setCanChooseDirectories:YES];
	[openPanel setCanCreateDirectories:YES];
	[openPanel setPrompt:@"Choose source folder"];
	[openPanel setCanChooseFiles:NO];	
	[openPanel beginSheetForDirectory:nil file:nil types:nil modalForWindow:self.window modalDelegate:self 
					   didEndSelector:@selector(changeLookForOpenPanelDidEnd:returnCode:contextInfo:) contextInfo:@"OriginalFiles"];
}

- (void)changeLookForOpenPanelDidEnd:(NSOpenPanel *)panel returnCode:(int)returnCode  contextInfo:(void  *)contextInfo {
	if(returnCode != NSOKButton) {
		return; // don't bother with it.
	}	
	[[NSUserDefaults standardUserDefaults] setValue:[panel directory] forKey:(NSString*)contextInfo];
}	


@end
 