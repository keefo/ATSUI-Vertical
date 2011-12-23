//
//  VerticalView.h
//  ATSUI_Vertical
//
//  Created by liam on 10-12-31.
//  Copyright 2010 Beyondcow. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface VerticalView : NSView {
	CFStringRef					string;
	UniChar						*text;
	UniCharCount				length;
    UniCharArrayOffset			currentStart, currentEnd;
	
	ATSUFontFallbacks			fallbacks;
	ATSUStyle					style;
	ATSUTextLayout				layout;
	ATSUFontID					font;
	Fixed						pointSize;
	ATSUAttributeTag			tags[2];
    ByteCount					sizes[2];
    ATSUAttributeValuePtr		values[2];
	Fixed						lineRotation, lineWidth, ascent, descent;
	ATSUVerticalCharacterType	charType;
	
	float						x, y, cgY, windowHeight;
    ItemCount					numSoftBreaks;
    UniCharArrayOffset			*theSoftBreaks;
    int							i;
}

- (void)setString:(NSString*)s;

@end
