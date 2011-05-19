#import <Foundation/Foundation.h>
#import "DocumentPath.h"
#include <getopt.h>

int choose = false;
int verbose = false;
static char *version = "0.3";

static struct option long_options[] = {
    {"verbose", no_argument, &verbose,     true},
    {"choose",  no_argument, &choose,      true},
    {"help",    no_argument, 0,            'h'},
    {0, 0, 0, 0}
};

int main (int argc, char **argv) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

    if (!AXAPIEnabled()) {
        fprintf(stderr, "You must enable access for assistive devices in Universal Access.\n");
        return 1;
    }
    
    NSArray *paths;
    NSString *appName = NULL;
    
    opterr = 0;
    
    int c, option_index;
    
    while ( (c = getopt_long(argc, argv, "cvh", long_options, &option_index)) != -1) {
        switch (c) {
            case 'c':
                choose = true;
                break;
            case 'v':
                verbose = true;
                break;
            case '?':
                fprintf(stderr, "Invalid options.\n\n");
            case 'h':        
                fprintf(stderr, "filepath v%s\n"
                        "Usage: filepath [<options>] [application name]\n"
                        "Prints the path of an opened file in OS X.\n\n"
                        "By default, it prints the path from the most recent application window with a document.\n"
                        "e.g., `filepath` returns \"/Users/chendo/foo.txt\"\n\n"
                        "You are also able to specify which app to use:\n"
                        "`filepath MacVim` pulls the path from MacVim\n\n"
                        "Options:\n"
                        "  -c, --choose     choose from a list of open files if more than one\n"
                        "  -v, --verbose    show which application the path is coming from\n\n"
                        "More information, support and tips & tricks at http://github.com/chendo/filepath\n", version);
                return 1;                    
        }
    }
    
    // If there is an extra argument
    if (optind + 1 <= argc)
    {
        paths = [DocumentPath documentPathsForAppName:[NSString stringWithUTF8String:argv[optind]]];
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
    
    if (appName && verbose)
        fprintf(stderr, "Getting path(s) from %s...\n", [appName UTF8String]);
    
    if ( (paths.count == 1) || choose == false) {
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
