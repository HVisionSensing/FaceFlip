#import <Foundation/Foundation.h>
#import <QuartzCore/CoreImage.h>


@interface FeatherEdgePlugInLoader : NSObject <CIPlugInRegistration>
{

}

-(BOOL)load:(void*)host;

@end
