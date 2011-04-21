#import <Foundation/Foundation.h>
#import "DocumentPath.h"

int main (int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

    NSArray *paths;
    if (argc > 1) {
        paths = [DocumentPath documentPathsForAppName:[NSString stringWithCString:argv[1]]];
    }
    else {
        paths = [DocumentPath documentPathsForMostRecentApp];
    }
    
    paths = [paths sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    if (paths.count == 0) {
        return 1;
    } else if (paths.count == 1) {
        printf("%s\n", [[paths objectAtIndex:0] cString]);
    } else {
        fprintf(stderr, "Multiple paths found:\n");
        
        for(int i=0; i<paths.count; i++) {
            fprintf(stderr, "%d: %s\n", i + 1, [[paths objectAtIndex:i] cString]);
        }
        fprintf(stderr, "Enter choice: ");
        int choice = 0;
        while (true) {
            scanf("%d", &choice);
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
