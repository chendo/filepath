#import <Foundation/Foundation.h>
#import "DocumentPath.h"

int main (int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

    if (!AXAPIEnabled()) {
        fprintf(stderr, "You must enable access for assistive devices in Universal Access.\n");
        return 1;
    }
    
    NSArray *paths;
    NSString *appName;
    if (argc > 1) {
        paths = [DocumentPath documentPathsForAppName:[NSString stringWithCString:argv[1]]];
    }
    else {
        paths = [DocumentPath documentPathsForMostRecentApp:&appName];
    }
    
    paths = [paths sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    if (paths.count == 0) {
        if (argc > 1) {
            fprintf(stderr, "No paths found for %s; either application not found or does not use NSDocuments\n", argv[1]);
        } else {
            fprintf(stderr, "No paths found at all. Weird.\n");
        }
        return 1;
    }
    
    if (appName)
        fprintf(stderr, "Getting path(s) from %s...\n", [appName cString]);
    
    if (paths.count == 1) {
        printf("%s\n", [[paths objectAtIndex:0] cString]);
    } else {
        fprintf(stderr, "Multiple paths found:\n");
        
        for(int i=0; i<paths.count; i++) {
            fprintf(stderr, "%d: %s\n", i + 1, [[paths objectAtIndex:i] cString]);
        }
        
        int choice = 0;
        while (true) {
            fprintf(stderr, "Enter choice: ");
            if (scanf("%d", &choice) != 1) {
                choice = -1;
                while (fgetc(stdin) != '\n')
                    ;
                
            }
            if ( (1 > choice) || (choice > paths.count) ) {
                fprintf(stderr, "Invalid choice.\n");
                continue;
            }
            printf("%s\n", [[paths objectAtIndex:(choice - 1)] cString]);
            break;
        }
    }
    
    [pool drain];
    return 0;
}
