//
//  ATSUI_VerticalAppDelegate.h
//  ATSUI_Vertical
//
//  Created by liam on 10-12-31.
//  Copyright 2010 Beyondcow. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "VerticalView.h"

@interface ATSUI_VerticalAppDelegate : NSObject {
    NSWindow *window;
	IBOutlet VerticalView *vv;
}

@property (assign) IBOutlet NSWindow *window;

@end
