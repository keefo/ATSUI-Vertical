//
//  ATSUI_VerticalAppDelegate.m
//  ATSUI_Vertical
//
//  Created by liam on 10-12-31.
//  Copyright 2010 Beyondcow. All rights reserved.
//

#import "ATSUI_VerticalAppDelegate.h"

@implementation ATSUI_VerticalAppDelegate

@synthesize window;
- (void)awakeFromNib
{
	NSRect r=[window frame];
	r.size.width=390;
	r.size.height=180;
	[window setFrame:r display:YES];
	[window setTitle:@"ATSUI Vertical Text Demo"];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application
	[vv setString:@"Happy new year 2011! Best regards from beyondcow.com"];
	[vv display];
}

@end
