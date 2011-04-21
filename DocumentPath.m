#import "DocumentPath.h"


@implementation DocumentPath

+(NSArray *) documentPathsForMostRecentApp {
    NSArray *appsInOrder = (NSArray *)CopyLaunchedApplicationsInFrontToBackOrder();
    for(int i=0; i<appsInOrder.count; i++) {
        NSDictionary *app = [appsInOrder objectAtIndex:i];
        NSArray *paths = [self documentPathsForPID:[[app objectForKey:@"pid"] integerValue]];
        if (paths.count > 0)
            return paths;
    }
    return NULL;
}

+(NSArray *) documentPathsForAppName:(NSString *)appName {
    NSString *appPath = [[NSWorkspace sharedWorkspace] fullPathForApplication:appName];
    
    if (appPath == NULL)
        return NULL;
    
    NSBundle *appBundle = [NSBundle bundleWithPath:appPath];
    NSString *bundleID = [appBundle bundleIdentifier];
    
    return [self documentPathsForBundleID:bundleID];
}

+(NSArray *) documentPathsForBundleID:(NSString *) bundleID {
    NSArray *applications = [NSRunningApplication runningApplicationsWithBundleIdentifier:bundleID];
    
    if (applications.count == 0)
        return NULL;
    
    NSMutableArray *all_paths = [NSMutableArray array];
    for(int i=0; i<[applications count]; i++) {
        NSArray *paths = [self documentPathsForPID:[[applications objectAtIndex:i] processIdentifier]];
        for (int j=0; j<paths.count; j++) {
            [all_paths addObject:[paths objectAtIndex:j]];
        }
    }
    return all_paths;
}

+(NSArray *) documentPathsForPID:(int) pid {
    AXUIElementRef app = AXUIElementCreateApplication((pid_t)pid);
    
    NSArray* windows;
    AXUIElementCopyAttributeValues(app, kAXWindowsAttribute, 0, 10, (CFArrayRef *)&windows);
    NSMutableArray* paths = [NSMutableArray arrayWithCapacity: [windows count]];
    
    for(int i=0; i<[windows count]; i++) {
        NSString *path;
        AXUIElementCopyAttributeValue((AXUIElementRef)[windows objectAtIndex:i], kAXDocumentAttribute, (CFTypeRef *)&path);
        if (path == NULL)
            continue;
        path = [[NSURL URLWithString:path] path];
        [paths addObject:path];
    }
    return paths;
}

@end
