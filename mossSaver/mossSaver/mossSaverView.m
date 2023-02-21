//
//  mossSaverView.m
//  mossSaver
//
//  Created by 博一 on 2023/2/21.
//

#import "mossSaverView.h"

#define jikeY [NSColor colorWithRed:1 green:0.894 blue:0.066 alpha:1.00]
#define ratio 0.618

@implementation mossSaverView

- (instancetype)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
    self = [super initWithFrame:frame isPreview:isPreview];
    if (self) {
        [self setAnimationTimeInterval:1/30.0];
        [self registerFont];
        [self initUI:frame];
    }
    return self;
}

- (void)startAnimation
{
    [super startAnimation];
}

- (void)stopAnimation
{
    [super stopAnimation];
}

- (void)drawRect:(NSRect)rect
{
    [super drawRect:rect];
    
}

- (void)animateOneFrame
{
    return;
}

- (BOOL)hasConfigureSheet
{
    return NO;
}

- (NSWindow*)configureSheet
{
    return nil;
}

- (void)registerFont {
    Boolean needAdd = YES;
    NSArray *fontArr = [[NSFontManager sharedFontManager] availableFonts];
    for (NSString *name in fontArr) {
        if ([name isEqualToString:@"Rajdhani-Medium"]) {
            needAdd = NO;
        }
    }
    if (needAdd) {
        NSArray *pathArr = [[NSBundle mainBundle] pathsForResourcesOfType: @"otf" inDirectory: @"font"];
        for (int i = 0; i < pathArr.count; i ++) {
            NSURL *fontURL = [NSURL fileURLWithPath:pathArr[i]];
            NSURL *urls[] = {fontURL};
            CFArrayRef fontURLs = CFArrayCreate(kCFAllocatorDefault, (void *)urls, (CFIndex)1, NULL);
            CTFontManagerRegisterFontURLs(fontURLs, kCTFontManagerScopePersistent, true, ^bool(CFArrayRef  _Nonnull errors, bool done) {
                    if (CFArrayGetCount(errors) > 0) {
                        // regist failed
                        CFErrorRef cfError = (CFErrorRef)CFArrayGetValueAtIndex(errors, 0);
                        NSError *error = (__bridge_transfer NSError *)cfError;
                        NSLog(@"Regist Font Failed: %@", [error localizedDescription]);
                        return false;
                    }
                    return true;
                });
        }
    }
    
}


- (void)initUI:(NSRect)rect {
    
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    
    NSTextField *tipTitle = [[NSTextField alloc]init];
    tipTitle.frame = CGRectMake(width * 0.05, height * 0.618 + 10, width * 0.9, 30);
    tipTitle.editable = NO;
    tipTitle.bordered = NO;
    tipTitle.drawsBackground = NO;
    tipTitle.font = [NSFont fontWithName:@"Rajdhani" size:30];
    tipTitle.textColor = jikeY;
    tipTitle.alignment = NSTextAlignmentCenter;
    tipTitle.stringValue = [NSString stringWithFormat:@"%f,%f", width, height];
    [self addSubview:tipTitle];
}

@end
