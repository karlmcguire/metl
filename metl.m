#import <AppKit/AppKit.h>

int
main() {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    [NSApplication sharedApplication];

    NSUInteger windowStyle = NSTitledWindowMask | NSClosableWindowMask | NSResizableWindowMask;

    NSRect windowRect = NSMakeRect(100, 100, 400, 400);

    NSWindow* window = [[NSWindow alloc] initWithContentRect:windowRect
                                         styleMask:windowStyle
                                         backing:NSBackingStoreBuffered
                                         defer:NO];

    [window autorelease];

    NSWindowController* windowController = [[NSWindowController alloc] initWithWindow:window];

    [windowController autorelease];

    NSTextView* textView = [[NSTextView alloc] initWithFrame:windowRect];
    [textView autorelease];

    [window setContentView:textView];
    [textView insertText:@"Hello world!"];

    [window orderFrontRegardless];
    [NSApp run];

    [pool drain];

    return 0;
}
