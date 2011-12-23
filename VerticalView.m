//
//  VerticalView.m
//  ATSUI_Vertical
//
//  Created by liam on 10-12-31.
//  Copyright 2010 Beyondcow. All rights reserved.
//

#import "VerticalView.h"

#define TextMargin 14
#define TextFontName "Hiragino Mincho Pro W3"
#define TextFontSize 18

@implementation VerticalView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
		text=NULL;
    }
    return self;
}

- (void)setString:(NSString*)s
{
	if(text)free(text);
	
	string=(CFStringRef)s;
	length = CFStringGetLength(string);
    text = (UniChar *)malloc(length * sizeof(UniChar));
    CFStringGetCharacters(string, CFRangeMake(0, length), text);
	CFRelease(string);
}

- (void)drawRect:(NSRect)dirtyRect {
    // Drawing code here.
	
	if(text==NULL)return;
	HIRect bounds;
	bounds.size.width=[self bounds].size.width;
	bounds.size.height=[self bounds].size.height;
	bounds.origin.x=0;
	bounds.origin.y=0;
	
	NSGraphicsContext *currentContext = [NSGraphicsContext currentContext];
	CGContextRef cgContext = (CGContextRef)([currentContext graphicsPort]);
	
	verify_noerr( ATSUCreateStyle(&style) );
	verify_noerr( ATSUFindFontFromName(TextFontName, strlen(TextFontName), kFontFullName, kFontNoPlatform, kFontNoScript, kFontNoLanguage, &font) );
	
    tags[0] = kATSUFontTag;
    sizes[0] = sizeof(ATSUFontID);
    values[0] = &font;
	
	pointSize = Long2Fix(TextFontSize);
	tags[1] = kATSUSizeTag;
    sizes[1] = sizeof(Fixed);
    values[1] = &pointSize;
	verify_noerr( ATSUSetAttributes(style, 2, tags, sizes, values) );
	
	charType = kATSUStronglyVertical;
	tags[0] = kATSUVerticalCharacterTag;
    sizes[0] = sizeof(ATSUVerticalCharacterType);
    values[0] = &charType;
    verify_noerr( ATSUSetAttributes(style, 1, tags, sizes, values) );
	
	verify_noerr( ATSUCreateTextLayout(&layout) );
    verify_noerr( ATSUSetTextPointerLocation(layout, text, kATSUFromTextBeginning, kATSUToTextEnd, length) );	
	verify_noerr( ATSUSetRunStyle(layout, style, kATSUFromTextBeginning, kATSUToTextEnd) );
	
	lineRotation = X2Fix(90.0);
    tags[0] = kATSULineRotationTag;
    sizes[0] = sizeof(Fixed);
    values[0] = &lineRotation;
	verify_noerr( ATSUSetLayoutControls(layout, 1, tags, sizes, values) );
	
	windowHeight = bounds.size.height;
    lineWidth = X2Fix(windowHeight - (2.0*TextMargin));
	tags[0] = kATSULineWidthTag;
    sizes[0] = sizeof(Fixed);
    values[0] = &lineWidth;
	verify_noerr( ATSUSetLayoutControls(layout, 1, tags, sizes, values) );
	
	// Set up the CGContext for drawing
	tags[0] = kATSUCGContextTag;
	sizes[0] = sizeof(CGContextRef);
	values[0] = &cgContext;
	verify_noerr( ATSUSetLayoutControls(layout, 1, tags, sizes, values) );
	
	// Break the text into lines
	verify_noerr( ATSUBatchBreakLines(layout, kATSUFromTextBeginning, length, lineWidth, &numSoftBreaks) );
    verify_noerr( ATSUGetSoftLineBreaks(layout, kATSUFromTextBeginning, kATSUToTextEnd, 0, NULL, &numSoftBreaks) );
    theSoftBreaks = (UniCharArrayOffset *) malloc(numSoftBreaks * sizeof(UniCharArrayOffset));
    verify_noerr( ATSUGetSoftLineBreaks(layout, kATSUFromTextBeginning, kATSUToTextEnd, numSoftBreaks, theSoftBreaks, &numSoftBreaks) );
	
	// Prepare the coordiates for drawing.
	x = TextMargin; // Left margin
	y = TextMargin; // Top margin
	cgY = y; 
	
	verify_noerr( ATSUCreateFontFallbacks(&fallbacks) );
	verify_noerr( ATSUSetObjFontFallbacks(fallbacks, 0, NULL, kATSUDefaultFontFallbacks) );
	tags[0] = kATSULineFontFallbacksTag;
	sizes[0] = sizeof(ATSUFontFallbacks);
	values[0] = &fallbacks;
	verify_noerr( ATSUSetLayoutControls(layout, 1, tags, sizes, values) );
	
	verify_noerr( ATSUSetTransientFontMatching(layout, true) );
	
    currentStart = 0;
    for (i=0; i <= numSoftBreaks; i++) {
        currentEnd = ((numSoftBreaks > 0 ) && (numSoftBreaks > i)) ? theSoftBreaks[i] : length;		
        ATSUGetLineControl(layout, currentStart, kATSULineAscentTag, sizeof(ATSUTextMeasurement), &ascent, NULL);
        ATSUGetLineControl(layout, currentStart, kATSULineDescentTag, sizeof(ATSUTextMeasurement), &descent, NULL);
        x += Fix2X(ascent);
		
        verify_noerr( ATSUDrawText(layout, currentStart, currentEnd - currentStart, X2Fix(x), X2Fix(cgY)) );

        x += Fix2X(descent);
        currentStart = currentEnd;
    }
	
	//Dispose Layout and style
    free(theSoftBreaks);
	CGContextFlush( cgContext );
	verify_noerr( ATSUDisposeStyle(style) );
	verify_noerr( ATSUDisposeTextLayout(layout) );
	verify_noerr( ATSUDisposeFontFallbacks(fallbacks) );
}

@end
