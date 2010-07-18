#import "CTEffect.h"

@class IplImageWrapper;
@class HaarClassifierWrapper;

@interface FaceFlip : CTEffect
{	
	IplImageWrapper* cvImage;
	HaarClassifierWrapper* faceClassifier;
    
    IBOutlet NSView* inspectorView;
    
    BOOL mShouldFlipFrame;
}

@property(nonatomic, assign) BOOL shouldFlipFrame;

@end
