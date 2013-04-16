#import "cv.h"

@interface IplImageWrapper : NSObject {
	IplImage* iplImage;
}
@property (readonly) IplImage* iplImage;
@property (readonly) CGSize size;

- (id) initGrayscaleWithSize:(CGSize)frameSize;
- (void) drawGrayscaleFromCIImage:(CIImage *)ciimage;
@end
