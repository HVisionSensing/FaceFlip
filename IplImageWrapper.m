#import "IplImageWrapper.h"

@implementation IplImageWrapper

@synthesize iplImage;

- (id) initGrayscaleWithWidth:(int)width height:(int)height
{
	self = [super init];
	
	if( self != nil )
	{
		iplImage = cvCreateImage(cvSize(width, height), IPL_DEPTH_8U, 1);
		
		if(!iplImage) return nil;
	}
	
	return self;
}

- (void) drawGrayscaleFromCIImage:(CIImage *)ciimage
{	
	unsigned char * imageData = (unsigned char *) iplImage->imageData;
	
	// Create grayscale image context for importing pbuffer into OpenCV
	NSBitmapImageRep* bitmapBacking = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:&imageData
																			  pixelsWide:iplImage->width
																			  pixelsHigh:iplImage->height
																		   bitsPerSample:8
																		 samplesPerPixel:1
																				hasAlpha:NO
																				isPlanar:NO
																		  colorSpaceName:NSDeviceWhiteColorSpace
																			 bytesPerRow:0
																			bitsPerPixel:0];
	
	CIContext* grayBitmapContext = [[NSGraphicsContext graphicsContextWithBitmapImageRep:bitmapBacking] CIContext];
	
	// Draw to openCV IplImage from pbuffer
	[grayBitmapContext drawImage: ciimage atPoint:CGPointZero
						fromRect: [ciimage extent] ];
	
	[bitmapBacking release];
}

- (void) dealloc
{
	cvReleaseImage(&iplImage);
	
	[super dealloc];
}

@end
