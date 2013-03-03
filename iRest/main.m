#import <Cocoa/Cocoa.h>
#import "AIRAppDelegate.h"

int main(int argc, char *argv[])
{
    @autoreleasepool {
        NSApplication *application = [NSApplication sharedApplication];
        [application setDelegate:[[AIRAppDelegate alloc] init]];
        [application run];
    }
    return 0;
}
