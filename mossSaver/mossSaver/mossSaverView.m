//
//  mossSaverView.m
//  mossSaver
//
//  Created by 博一 on 2023/2/21.
//

#import "mossSaverView.h"

#define jikeY [NSColor colorWithRed:1 green:0.894 blue:0.066 alpha:1.00]
#define ratio 0.618

@interface mossSaverView()


@property (nonatomic, strong) NSView *dateNumText;
@property (nonatomic, strong) NSTextField *dateNum_h;

@property (nonatomic, strong) NSTextField *dateNum_m;
@property (nonatomic, strong) NSTextField *dateNum_s;
@property (nonatomic, strong) NSTextField *daliyText;
@property (nonatomic, strong) NSTextField *weekText;

@end

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
    [self updateDate];
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
        NSBundle *bundle = [NSBundle bundleWithIdentifier:@"com.yibo.mossSaver"];
        NSArray *pathArr = [bundle pathsForResourcesOfType: @"otf" inDirectory: @"font"];
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
    
    NSBundle *bundle = [NSBundle bundleWithIdentifier:@"com.yibo.mossSaver"];
    NSString *imagePath = [bundle pathForResource:@"550W" ofType:@"bmp"];
    NSImage *img = [[NSImage alloc] initWithContentsOfFile:imagePath];
    
   
    // 1920 * 1080
    NSImageView *bgImage = [[NSImageView alloc] init];
    bgImage.frame = CGRectMake((width - height / 1080 * 1920) / 2, 0, height / 1080 * 1920 , height);
    bgImage.image = [self resizeImage:img size:CGSizeMake(height / 1080 * 1920 * 0.382, height * 0.382)];
    [bgImage setWantsLayer:YES];
    bgImage.layer.backgroundColor = NSColor.blackColor.CGColor;
    
    [self addSubview: bgImage];
    
    
    
    NSTextField *tipTitle = [[NSTextField alloc]init];
    tipTitle.frame = CGRectMake(width * 0.05, height * 0.618 + 10, width * 0.9, 30);
    tipTitle.editable = NO;
    tipTitle.bordered = NO;
    tipTitle.drawsBackground = NO;
    tipTitle.font = [NSFont fontWithName:@"Rajdhani" size:30];
    tipTitle.textColor = jikeY;
    tipTitle.alignment = NSTextAlignmentCenter;
//    tipTitle.stringValue = [NSString stringWithFormat:@"%f,%f", width, height];
    [self addSubview:tipTitle];

    
    
    self.dateNumText = [[NSView alloc] init];
    self.dateNumText.frame = CGRectMake((width - height) / 2, height * 0.35 - 300, height, 300);
//    [self.dateNumText setWantsLayer:YES];
//    self.dateNumText.layer.backgroundColor = NSColor.blueColor.CGColor;
    
    CGFloat leftPadding = (height - 720) / 2;

    self.dateNum_h = [[NSTextField alloc] init];
    self.dateNum_h.frame = CGRectMake(leftPadding - 30, 0, 350, 300);
    self.dateNum_h.editable = NO;
    self.dateNum_h.bordered = NO;
    self.dateNum_h.drawsBackground = NO;
    self.dateNum_h.font = [NSFont fontWithName:@"Rajdhani" size:300];
    self.dateNum_h.textColor = NSColor.redColor;
    self.dateNum_h.alignment = NSTextAlignmentCenter;
   
    [self.dateNumText addSubview: self.dateNum_h];
    
    self.daliyText = [[NSTextField alloc] init];
    self.daliyText.frame = CGRectMake(leftPadding + 310, 130, 400, 100);
    self.daliyText.editable = NO;
    self.daliyText.bordered = NO;
    self.daliyText.drawsBackground = NO;
    self.daliyText.font = [NSFont fontWithName:@"Rajdhani" size:56];
    self.daliyText.textColor = NSColor.whiteColor;
    self.daliyText.alignment = NSTextAlignmentLeft;
    [self.dateNumText addSubview: self.daliyText];
    
    self.weekText = [[NSTextField alloc] init];
    self.weekText.frame = CGRectMake(leftPadding + 660, 30, 400, 200);
    self.weekText.editable = NO;
    self.weekText.bordered = NO;
    self.weekText.drawsBackground = NO;
    self.weekText.font = [NSFont fontWithName:@"Rajdhani" size:53];
    self.weekText.textColor = jikeY;
    self.weekText.alignment = NSTextAlignmentLeft;
    [self.dateNumText addSubview: self.weekText];

    NSTextField *dateSignOne = [[NSTextField alloc] init];
    dateSignOne.frame = CGRectMake(leftPadding + 300, 50, 30, 120);
    dateSignOne.editable = NO;
    dateSignOne.bordered = NO;
    dateSignOne.drawsBackground = NO;
    dateSignOne.font = [NSFont fontWithName:@"Rajdhani" size: 120];
    dateSignOne.textColor = NSColor.whiteColor;
    dateSignOne.stringValue = @":";
    dateSignOne.alignment = NSTextAlignmentCenter;
    [self.dateNumText addSubview: dateSignOne];

    self.dateNum_m = [[NSTextField alloc] init];
    self.dateNum_m.frame = CGRectMake(leftPadding + 330, 50, 150, 120);
    self.dateNum_m.editable = NO;
    self.dateNum_m.bordered = NO;
    self.dateNum_m.drawsBackground = NO;
    self.dateNum_m.font = [NSFont fontWithName:@"Rajdhani" size:120];
    self.dateNum_m.textColor = NSColor.whiteColor;
    self.dateNum_m.alignment = NSTextAlignmentCenter;
    [self.dateNumText addSubview: self.dateNum_m];

    NSTextField *dateSignTwo = [[NSTextField alloc] init];
    dateSignTwo.frame = CGRectMake(leftPadding + 480, 50, 30, 120);
    dateSignTwo.editable = NO;
    dateSignTwo.bordered = NO;
    dateSignTwo.drawsBackground = NO;
    dateSignTwo.font = [NSFont fontWithName:@"Rajdhani" size:120];
    dateSignTwo.textColor = NSColor.whiteColor;
    dateSignTwo.stringValue = @":";
    dateSignTwo.alignment = NSTextAlignmentCenter;
    [self.dateNumText addSubview: dateSignTwo];

    self.dateNum_s = [[NSTextField alloc] init];
    self.dateNum_s.frame = CGRectMake(leftPadding + 510, 50, 150, 120);
    self.dateNum_s.editable = NO;
    self.dateNum_s.bordered = NO;
    self.dateNum_s.drawsBackground = NO;
    self.dateNum_s.font = [NSFont fontWithName:@"Rajdhani" size:120];
    self.dateNum_s.textColor = NSColor.whiteColor;
    self.dateNum_s.alignment = NSTextAlignmentCenter;
    [self.dateNumText addSubview: self.dateNum_s];

    [self addSubview:self.dateNumText];
    
}

- (NSImage*) resizeImage:(NSImage*)sourceImage size:(NSSize)size{

    NSRect targetFrame = NSMakeRect(0, 0, size.width, size.height);
    NSImage*  targetImage = [[NSImage alloc] initWithSize:size];
     
    NSSize sourceSize = [sourceImage size];
     
    float ratioH = size.height/ sourceSize.height;
    float ratioW = size.width / sourceSize.width;
     
    NSRect cropRect = NSZeroRect;
    if (ratioH >= ratioW) {
        cropRect.size.width = floor (size.width / ratioH);
        cropRect.size.height = sourceSize.height;
    } else {
        cropRect.size.width = sourceSize.width;
        cropRect.size.height = floor(size.height / ratioW);
    }
     
    cropRect.origin.x = floor( (sourceSize.width - cropRect.size.width)/2 );
    cropRect.origin.y = floor( (sourceSize.height - cropRect.size.height)/2 );
     
     
     
    [targetImage lockFocus];
     
    [sourceImage drawInRect:targetFrame
                   fromRect:cropRect       //portion of source image to draw
                  operation:NSCompositingOperationCopy  //compositing operation
                   fraction:1.0              //alpha (transparency) value
             respectFlipped:YES              //coordinate system
                      hints:@{NSImageHintInterpolation:
     [NSNumber numberWithInt:NSImageInterpolationLow]}];
     
    [targetImage unlockFocus];
    return targetImage;
}

- (void)updateDate {
    NSArray *weekArr = @[@"星\n期\n日",@"星\n期\n一",@"星\n期\n二",@"星\n期\n三",@"星\n期\n四",@"星\n期\n五",@"星\n期\n六"];
    NSDate *now = [[NSDate alloc] init];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags =  NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    NSInteger year = [dateComponent year];
    NSInteger month = [dateComponent month];
    NSString *monthStr = [self timeAddZero:month];
    NSInteger day = [dateComponent day];
    NSString *dayStr = [self timeAddZero:day];
    NSInteger week = [dateComponent weekday];
    NSString *weekStr = weekArr[week - 1];
    NSString *showDaliy = [NSString stringWithFormat:@"%ld / %@ / %@",(long)year,monthStr,dayStr];
    self.daliyText.stringValue = showDaliy;
    self.weekText.stringValue = weekStr;
    if (week == 6) {
        self.weekText.textColor = NSColor.redColor;
    }
    
    NSInteger hour = [dateComponent hour];
    NSString *hourStr = [self timeAddZero:hour];
    NSInteger minute = [dateComponent minute];
    NSString *minuteStr = [self timeAddZero:minute];
    NSInteger second = [dateComponent second];
    NSString *secondStr = [self timeAddZero:second];
    
    self.dateNum_h.stringValue = hourStr;
    self.dateNum_m.stringValue = minuteStr;
    self.dateNum_s.stringValue = secondStr;
    
}


- (NSString*) timeAddZero:(NSInteger) timeNum {
    if (timeNum >= 10) {
        return [NSString stringWithFormat: @"%ld", (long)timeNum];
    } else {
        return [NSString stringWithFormat: @"0%ld", (long)timeNum];
    }
}



@end
