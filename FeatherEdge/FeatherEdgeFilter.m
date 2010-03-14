#import "FeatherEdgeFilter.h"
#import <Foundation/Foundation.h>
#import <ApplicationServices/ApplicationServices.h>

@implementation FeatherEdgeFilter

static CIKernel *_FeatherEdgeFilterKernel = nil;

- (id)init
{
    if(_FeatherEdgeFilterKernel == nil)
    {
		NSBundle    *bundle = [NSBundle bundleForClass:NSClassFromString(@"FeatherEdgeFilter")];
		NSStringEncoding encoding = NSUTF8StringEncoding;
		NSError     *error = nil;
		NSString    *code = [NSString stringWithContentsOfFile:[bundle pathForResource:@"FeatherEdgeFilterKernel" ofType:@"cikernel"] encoding:encoding error:&error];
		NSArray     *kernels = [CIKernel kernelsWithString:code];

		_FeatherEdgeFilterKernel = [[kernels objectAtIndex:0] retain];
    }
    return [super init];
}

- (NSDictionary *)customAttributes
{
    return [NSDictionary dictionaryWithObjectsAndKeys:

        [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithDouble:  1.00], kCIAttributeMin,
            [NSNumber numberWithDouble:  1.00], kCIAttributeSliderMin,
            [NSNumber numberWithDouble:1000.00], kCIAttributeSliderMax,
            [NSNumber numberWithDouble:100.00], kCIAttributeDefault,
            [NSNumber numberWithDouble:100.00], kCIAttributeIdentity,
            kCIAttributeTypeDistance,		  kCIAttributeType,
            nil],                               @"inputRadius",

        nil];
}

- (CIImage *)outputImage
{
	CISampler *src = [CISampler samplerWithImage: inputImage];
	
    return [self apply: _FeatherEdgeFilterKernel, src, inputRadius,
						kCIApplyOptionDefinition, [src definition], nil];
}

@end
