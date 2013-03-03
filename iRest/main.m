#import <Cocoa/Cocoa.h>
#import "AIRApplication.h"
#import "AIRAppDelegate.h"

int main(int argc, char *argv[])
{
    @autoreleasepool {
        [AIRApplication sharedApplication]; // initializes NSAPP
        [NSApp setDelegate:[[AIRAppDelegate alloc] init]];
        [NSApp run];
    }
    return 0;
}
