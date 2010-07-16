#import "CTEffect.h"
#import "IplImageWrapper.h"
#import "HaarClassifierWrapper.h"

#define FEATHER_FACTOR 3.5

@interface FaceFlip : CTEffect
{	
	IplImageWrapper* cvImage;
	HaarClassifierWrapper* faceClassifier;
    
    IBOutlet NSView* inspectorView;
    
    BOOL mShouldFlipFrame;
}

@property(nonatomic, assign) BOOL shouldFlipFrame;

@end
