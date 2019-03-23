#import <AppKit/AppKit.h>
#import <MetalKit/MetalKit.h>

@interface TerminalView : MTKView
@end

int
main() {
    @autoreleasepool {
        // window frame
        NSRect frame = NSMakeRect(0, 0, 1280, 720);
        
        // window style
        int style = NSTitledWindowMask |
                    NSClosableWindowMask |
                    NSResizableWindowMask |
                    NSMiniaturizableWindowMask;

        // window pointer
        NSWindow* window = [[NSWindow alloc] initWithContentRect:frame
                                             styleMask:style
                                             backing:NSBackingStoreBuffered
                                             defer:NO];

        // set window title
        window.title = @"metl";

        // focus window 
        [window cascadeTopLeftFromPoint:NSMakePoint(100, 100)];
        [window makeKeyAndOrderFront:nil];

        // set window view
        window.contentView = [[TerminalView alloc] initWithFrame:frame];

        // start run loop
        [NSApp run];
    }

    return 0;
}

@implementation TerminalView {
    id<MTLCommandQueue> commandQueue;
    dispatch_semaphore_t mtlSemaphore;
    MTLViewport viewport;
    int swapChainBufferCount;
}

- (id)initWithFrame:(CGRect)frame {
    // get gpu device
    id<MTLDevice> device = MTLCreateSystemDefaultDevice();

    // init self with gpu device
    self = [super initWithFrame:frame device:device];

    if(self) {
        [self setup];
    }

    return self;
}

// TODO
- (void)setup {
    swapChainBufferCount = 3;

    // view settings
    self.colorPixelFormat = MTLPixelFormatBGRA8Unorm;

    // create semaphore
    mtlSemaphore = dispatch_semaphore_create(swapChainBufferCount);

    // logical command queue for gpu
    commandQueue = [self.device newCommandQueue];
}

// TODO
// 
// where the magic happens
- (void)drawRect:(CGRect)rect {
    // wait for semaphore
    dispatch_semaphore_wait(mtlSemaphore, DISPATCH_TIME_FOREVER);

    MTLRenderPassDescriptor *rpd = [MTLRenderPassDescriptor 
                                    renderPassDescriptor];

    // set up the rpd with defaults
    rpd.colorAttachments[0].texture = self.currentRenderPassDescriptor.
                                      colorAttachments[0].texture;
    rpd.colorAttachments[0].loadAction = MTLLoadActionClear;
    rpd.colorAttachments[0].storeAction = MTLStoreActionStore;

    // iterate through colors
    static float col = 0.0f;
    col = (col > 1.0f) ? 0.0f : col + 0.01f;

    // set color
    rpd.colorAttachments[0].clearColor = MTLClearColorMake(col, 0.5, col, 1);

    // create command buffer
    id<MTLCommandBuffer> commandBuffer = [commandQueue commandBuffer];

    // encode render command
    id<MTLRenderCommandEncoder> encoder = [commandBuffer
                                           renderCommandEncoderWithDescriptor:
                                           rpd];

    // establish viewport
    viewport.originX = 0;
    viewport.originY = 0;
    viewport.width   = self.drawableSize.width;
    viewport.height  = self.drawableSize.height;

    // encode
    [encoder setViewport:viewport];
    [encoder endEncoding];

    // set semaphore
    __block dispatch_semaphore_t semaphore = mtlSemaphore;
    
    [commandBuffer addCompletedHandler:^(id<MTLCommandBuffer> buffer) {
        dispatch_semaphore_signal(semaphore);
    }];
    [commandBuffer presentDrawable:self.currentDrawable];
    [commandBuffer commit];

    // draw
    [super drawRect:rect];
}

@end
