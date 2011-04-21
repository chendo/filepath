//
//  DocumentPath.h
//  docpath
//
//  Created by Jack Chen on 21/04/11.
//  Copyright 2011 Envato. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#include "CopyLaunchedApplicationsInFrontToBackOrder.h"

@interface DocumentPath : NSObject {

}

+(NSArray *) documentPathsForMostRecentApp;
+(NSArray *) documentPathsForAppName:(NSString *)appName;
+(NSArray *) documentPathsForPID:(int) pid;
+(NSArray *) documentPathsForBundleID:(NSString *) bundleID;

@end
