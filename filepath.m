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
    bool firstFlag = false;
    
    if (argc > 1) {
        int appIndex = 1;
        // Check for -f
        if (argc == 3) {
            if (strcmp(argv[1], "-f") == 0) {
                firstFlag = true;
                appIndex = 2;
            }
            else {
                fprintf(stderr, "Unrecognised option.\nUsage: filepath [-f] [application name]\n  -f\tdefault to first file\n");
                return 1;
            }
        }
               
        paths = [DocumentPath documentPathsForAppName:[NSString stringWithCString:argv[appIndex]]];
    }
    else {
        paths = [DocumentPath documentPathsForMostRecentApp:&appName];
    }
    
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
    
    if ( (paths.count == 1) || firstFlag) {
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
