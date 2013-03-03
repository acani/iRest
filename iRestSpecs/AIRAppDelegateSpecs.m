#import <SenTestingKit/SenTestingKit.h>
#import "AIRAppDelegate.h"

@interface AIRAppDelegateSpecs : SenTestCase @end

@implementation AIRAppDelegateSpecs {
    AIRAppDelegate *_appDelegate;
}

#pragma mark - SenTest

- (void)setUp
{
    _appDelegate = (AIRAppDelegate *)[NSApp delegate];
}

- (void)tearDown
{
    _appDelegate = nil;
}

#pragma mark - NSObject

- (void)spec_superclass
{
    STAssertEquals([AIRAppDelegate superclass], [NSObject class], nil);
}

- (void)specProtocols
{
    STAssertTrue([AIRAppDelegate conformsToProtocol:@protocol(NSApplicationDelegate)], nil);
}

#pragma mark - NSApplicationDelegate

- (void)spec__main
{
    AIRAppDelegate *appDelegate = (AIRAppDelegate *)[NSApp delegate];
    STAssertNotNil(appDelegate, nil);
    STAssertEquals([appDelegate class], [AIRAppDelegate class], nil);
}

- (void)specApplicationDidFinishLaunching_
{
    AIRAppDelegate *appDelegate = (AIRAppDelegate *)[NSApp delegate];
    [appDelegate applicationDidFinishLaunching:nil];

    NSApplicationPresentationOptions options = (NSApplicationPresentationHideDock |
                                                NSApplicationPresentationHideMenuBar |
                                                NSApplicationPresentationDisableAppleMenu |
                                                NSApplicationPresentationDisableProcessSwitching |
                                                NSApplicationPresentationDisableForceQuit |
                                                NSApplicationPresentationDisableSessionTermination |
                                                NSApplicationPresentationDisableHideApplication);
    STAssertEquals([NSApp presentationOptions], options, nil);
}

@end
