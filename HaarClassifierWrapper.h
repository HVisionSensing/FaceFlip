#import <Cocoa/Cocoa.h>
#import <OpenCV/cv.h>

#import "IplImageWrapper.h"

#define HAAR_SCALE_FACTOR	1.2
#define HAAR_MIN_NEIGHBORS	2
#define HAAR_FLAGS			CV_HAAR_DO_CANNY_PRUNING

@interface HaarClassifierWrapper : NSObject {
	CvHaarClassifierCascade* classifier;
	CvMemStorage*			 storage;
	NSMutableArray*			 objects;
}
@property (readonly) NSMutableArray* objects;

- (void) detectWithIplImage:(IplImageWrapper *)image;
- (id) initWithClassifierFile:(NSString *)classifierPath;

@end
