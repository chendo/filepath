#import <Foundation/Foundation.h>
#import "DocumentPath.h"

int main (int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

    NSSet *paths;
    if (argc > 1) {
        paths = [NSSet setWithSet:[DocumentPath documentPathsForAppName:[NSString stringWithCString:argv[1]]]];
    }
    else {
        paths = [NSSet setWithArray:[DocumentPath documentPathsForMostRecentApp]];
    }
    
    if (paths.count == 0) {
        return 1;
    } else if (paths.count == 1) {
        printf("%s\n", [[paths anyObject] cString]);
    } else {
        fprintf(stderr, "Multiple paths found:\n");
        NSArray *_paths = [paths allObjects];
        for(int i=0; i<_paths.count; i++) {
            fprintf(stderr, "%d: %s\n", i + 1, [[_paths objectAtIndex:i] cString]);
        }
        fprintf(stderr, "Enter choice: ");
        int choice = 0;
        while (scanf("%d", &choice)) {
            if ( (1 > choice) || (choice > paths.count) ) {
                fprintf(stderr, "Invalid choice.\n");
                continue;
            }
            printf("%s\n", [[_paths objectAtIndex:(choice - 1)] cString]);
            break;
        }
    }
    
    [pool drain];
    return 0;
}
