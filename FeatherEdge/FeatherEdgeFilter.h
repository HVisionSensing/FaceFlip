#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>


@interface FeatherEdgeFilter : CIFilter
{
    CIImage      *inputImage;
    NSNumber     *inputRadius;
}

@end
