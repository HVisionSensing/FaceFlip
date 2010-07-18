#import <OpenCV/cxtypes.h>
#import <OpenCV/cvtypes.h>

@class IplImageWrapper;

@interface HaarClassifierWrapper : NSObject {
	CvHaarClassifierCascade* classifier;
	CvMemStorage*			 storage;
	NSMutableArray*			 objects;
}
@property (readonly) NSMutableArray* objects;

- (void) detectWithIplImage:(IplImageWrapper *)image;
- (id) initWithClassifierFile:(NSString *)classifierPath;

@end
