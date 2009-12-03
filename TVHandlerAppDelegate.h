//
//  TVHandlerAppDelegate.h
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

#import <Cocoa/Cocoa.h>
#import "Turbo.h"
#import "TVMagic2.h"

@interface TVHandlerAppDelegate : NSObject <NSApplicationDelegate> {
    
	NSWindow *window;
	NSTimer *testing;
	NSTextField *numberOfFiles;
	NSTextField *progressInfo;
	NSProgressIndicator *progressBar;
	
	NSURL *encodingFile;
	NSURL *encodingFileOutput;
	NSURL *encodingFileDestination;
	
	NSMutableArray *waitingList;
	TurboApplication *turbo;
	
	TVMagic2Application *tvmagic;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSTextField *numberOfFiles;
@property (assign) IBOutlet NSTextField *progressInfo;
@property (assign) IBOutlet NSProgressIndicator *progressBar;

-(IBAction)changeMoveTo:(id)sender;
-(IBAction)changeLookFor:(id)sender;

@end
