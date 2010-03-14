#import <Cocoa/Cocoa.h>
#import <OpenCV/cv.h>
#import <QuartzCore/QuartzCore.h>

@interface IplImageWrapper : NSObject {
	IplImage* iplImage;
}
@property (readonly) IplImage* iplImage;

- (id) initGrayscaleWithWidth:(int)width height:(int)height;
- (void) drawGrayscaleFromCIImage:(CIImage *)ciimage;
@end
