#import "AIRAppDelegate.h"

#ifdef DEBUG
#define START    [NSDate dateWithTimeIntervalSinceNow:3]
#define STOP     [NSDate dateWithTimeIntervalSinceNow:4]
#define INTERVAL 16
#define DURATION INTERVAL*9/24
#else
// TODO: +[NSDate dateWithNaturalLanguageString] probably won't work with certain locales. Fix.
#define START    [NSDate dateWithNaturalLanguageString:@"8 PM"]
#define STOP     [NSDate dateWithNaturalLanguageString:@"5 AM"]
#define INTERVAL 24*60*60 // 24 hours
#define DURATION 9*60*60  // 9 hours
#endif

@implementation AIRAppDelegate {
    NSTimer *_timer;
    NSView *_view;
//    NSWindow *_window;
}

#pragma mark - NSApplicationDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Make it difficult to quit the app while screen is unlocked.
    NSApplicationPresentationOptions options = (NSApplicationPresentationHideDock |
                                                NSApplicationPresentationHideMenuBar |
                                                NSApplicationPresentationDisableAppleMenu |
                                                NSApplicationPresentationDisableProcessSwitching |
                                                NSApplicationPresentationDisableForceQuit |
                                                NSApplicationPresentationDisableSessionTermination |
                                                NSApplicationPresentationDisableHideApplication);
    [NSApp setPresentationOptions:options];

    // Observe when OS X goes to sleep, wakes up, or changes time zone.
    NSNotificationCenter *notificationCenter = [[NSWorkspace sharedWorkspace] notificationCenter];
    [notificationCenter addObserver:self selector:@selector(workspaceWillSleep:) name:NSWorkspaceWillSleepNotification object:nil];
    [notificationCenter addObserver:self selector:@selector(workspaceDidWake:) name:NSWorkspaceDidWakeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(systemTimeZoneDidChange:) name:NSSystemTimeZoneDidChangeNotification object:nil];

    [self startCycle];

// TODO: Use _window and fade it in & out.
//    NSRect contentSize = NSMakeRect(100, 100, 320, 480);
////    NSView *contentView = [[NSView alloc] initWithFrame:contentSize];
//    _window = [[NSWindow alloc] initWithContentRect:contentSize styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO];    
//    [_window setAlphaValue:0];
////    [_window setContentView:contentView];
//    [_window makeKeyAndOrderFront:self];
////    [[_window animator] setAlphaValue:1];

//    NSView *view = [[NSView alloc] initWithFrame:NSMakeRect(100, 100, 320, 480)];
//
//    [contentView addSubview:view];
//    [view setAlphaValue:0];
//    [[view animator] setAlphaValue:1];
}

#pragma mark - Lock & Unlock Screen

- (void)lockScreen
{
    [self lockScreenWithDuration:DURATION];
}

- (void)lockScreenWithDuration:(NSTimeInterval)duration
{
    _view = [[NSView alloc] initWithFrame:CGRectZero];
    NSDictionary *options = @{NSFullScreenModeAllScreens: @(YES),
                              NSFullScreenModeWindowLevel: @(NSScreenSaverWindowLevel)};
    [_view enterFullScreenMode:[NSScreen mainScreen] withOptions:options];
    [self performSelector:@selector(unlockScreen) withObject:nil afterDelay:duration];
}

- (void)unlockScreen
{
    [_view exitFullScreenModeWithOptions:nil];
    _view = nil;
}

#pragma mark - Stop & Start Cycle

- (void)stopCycle
{
    [_timer invalidate];
    _timer = nil;
    [self unlockScreen];
}

- (void)startCycle
{
    // Lock screen if now is between START & STOP.
    //   | ------- DURATION ------- |
    //           | --- duration --- |
    //   | ----- * ---------------- |
    // START    now               STOP
    NSTimeInterval duration = [STOP timeIntervalSinceNow];
    if (duration < DURATION) {
        [self lockScreenWithDuration:duration];
    }

    // Reset timer.
    _timer = [[NSTimer alloc] initWithFireDate:START interval:INTERVAL target:self selector:@selector(lockScreen) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
}

#pragma mark - Notifications

// TODO: Should I invalidate the timer? Does sleep mess up the timer? I think yes.
- (void)workspaceWillSleep:(NSNotification *)notification
{
    [self stopCycle];
}

- (void)workspaceDidWake:(NSNotification *)notification
{
    [self startCycle];
}

// TODO: Confirm this is called for Daylight Savings Time changes.
- (void)systemTimeZoneDidChange:(NSNotification *)notification
{
    [self stopCycle];
    [self startCycle];
}

@end
