/*
 * Turbo.h
 */

#import <AppKit/AppKit.h>
#import <ScriptingBridge/ScriptingBridge.h>


@class TurboApplication, TurboListOfFileOrSpecifier;

enum TurboEtyp {
	TurboEtypIPodHigh = 'IpdB',
	TurboEtypIPodStandard = 'IpdS',
	TurboEtypSonyPSP = 'PspH',
	TurboEtypAppleTV = 'ApTV',
	TurboEtypIPhone = 'iPhn',
	TurboEtypYouTube = 'YouT',
	TurboEtypYouTubeHD = 'YoHD',
	TurboEtypHD720p = 'H720',
	TurboEtypHD1080p = 'H180',
	TurboEtypCustom = 'Cust'
};
typedef enum TurboEtyp TurboEtyp;



/*
 * Turbo Suite
 */

// The Turbo application itself.
@interface TurboApplication : SBApplication

@property (readonly) NSInteger lastErrorCode;  // Last error code that occurred, e.g. during encoding.
@property (readonly) BOOL isEncoding;  // True if Turbo.264 is currently encoding, False if you can start a new encode.
@property (readonly) BOOL isHardwarePluggedIn;  // True if the Turbo.264 hardware is plugged in.

- (void) open:(NSArray *)x;  // Open a document.
- (void) quit;  // Quit the application.
- (BOOL) exists;  // Verify if an object exists.
- (void) encodeNoErrorDialogs:(id)noErrorDialogs;  // Encode added files.
- (void) addFile:(NSURL *)x withDestination:(NSURL *)withDestination exportingAs:(TurboEtyp)exportingAs withCustomSetting:(NSString *)withCustomSetting replacing:(BOOL)replacing;  // Add a file to the queue for later encoding.

@end

