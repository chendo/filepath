#import <Cocoa/Cocoa.h>
#include "CopyLaunchedApplicationsInFrontToBackOrder.h"

@interface DocumentPath : NSObject {

}

+(NSArray *) documentPathsForMostRecentApp:(NSString **)appName;
+(NSArray *) documentPathsForAppName:(NSString *)appName;
+(NSArray *) documentPathsForPID:(int) pid;
+(NSArray *) documentPathsForBundleID:(NSString *) bundleID;

@end
