#import <AppKit/AppKit.h>
#import <Foundation/Foundation.h>

int
main() {
    @autoreleasepool {
        NSSpeechSynthesizer* synth = [[NSSpeechSynthesizer alloc] initWithVoice: nil];
        [synth startSpeakingString: @"Hello, world!"];

        while(![synth isSpeaking]) {}
        while([synth isSpeaking]) {}

        [synth release];
        
        NSLog(@"%@", [NSDate date]);
    }

    return 0;
}
