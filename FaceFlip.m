#import "FaceFlip.h"

@interface FaceFlip(private)
-(void) initCV;
-(void) initCI;
-(CIImage *) flippedFaceAt:(CIVector *)faceRect fromImage:(CIImage *)ciimage;
@end

@implementation FaceFlip

+ (NSString *) name
{
	return @"Face Flip";
}

- (id) initWithCoder:(NSCoder *) coder
{
	return [self init];
}

- (id) initWithContext:(CTContext *) ctContext
{
	self = [super initWithContext:ctContext];
	
	videoWidth = [[self context] size].width;
	videoHeight = [[self context] size].height;
	
	cvImage = [[IplImageWrapper alloc] initGrayscaleWithWidth:videoWidth height:videoHeight];
	
	NSString *classifierPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"haarcascade_frontalface_alt2" ofType:@"xml"];
	faceClassifier = [[HaarClassifierWrapper alloc] initWithClassifierFile:classifierPath];
	
	NSString *featherPath = [[[NSBundle bundleForClass:[self class]] builtInPlugInsPath] stringByAppendingPathComponent:@"FeatherEdge.plugin"];
	[CIPlugIn loadPlugIn:[NSURL fileURLWithPath:featherPath] allowNonExecutable:NO];
	
	return self;
}

- (void) dealloc
{
	[cvImage release];
	[faceClassifier release];
	
	[super dealloc];
}

- (CIImage *) flippedFaceAt:(CIVector *)faceRect fromImage:(CIImage *)ciimage
{
	// Crop image to face
	CIFilter *cropFilter = [CIFilter filterWithName:@"CICrop"];
	[cropFilter setValue:ciimage forKey:@"inputImage"];
	[cropFilter setValue:faceRect forKey:@"inputRectangle"];
	
	// Flip face upside down
	NSAffineTransform *flipTransform = [NSAffineTransform transform];
	[flipTransform translateXBy:0
							yBy:2*[faceRect Y]+[faceRect W] ]; // Flips the face onto itself, lines up with existing face
	[flipTransform scaleXBy:1 yBy:-1];
	CIFilter *flipFilter = [CIFilter filterWithName:@"CIAffineTransform"];
	[flipFilter setValue:[cropFilter valueForKey:@"outputImage"] forKey:@"inputImage"];
	[flipFilter setValue:flipTransform forKey:@"inputTransform"];
	
	// Blur edges of flipped face
	CIFilter *featherEdge = [CIFilter filterWithName:@"FeatherEdgeFilter"];
	[featherEdge setValue:[flipFilter valueForKey:@"outputImage"] forKey:@"inputImage"];
	[featherEdge setValue:[NSNumber numberWithFloat:[faceRect W]/FEATHER_FACTOR] forKey:@"inputRadius"];
	
	return [featherEdge valueForKey:@"outputImage"];
}

- (void) doit
{
	// Grab video frame from pixel buffer
	CIImage *ciimage = [CIImage imageWithCVImageBuffer: [[self context] oglPBuff]];
	
	// Blur frame for better face tracking
	CIFilter *blur = [CIFilter filterWithName:@"CIGaussianBlur"];
	[blur setValue:[NSNumber numberWithFloat:1.5] forKey:@"inputRadius"];
	[blur setValue:ciimage forKey:@"inputImage"];
	
	// Import frame into openCV
	[cvImage drawGrayscaleFromCIImage:[blur valueForKey:@"outputImage"]];
	
	// Detect faces
	[faceClassifier detectWithIplImage:cvImage];
	
	// Begin with existing image as background
	CIImage *result = ciimage;
	
	for(CIVector* faceRect in [faceClassifier objects]) {
		// Generate flipped face
		CIImage* flippedFace = [self flippedFaceAt:faceRect fromImage:ciimage];
		
		// Composite face over existing image
		CIFilter *overComposite = [CIFilter filterWithName:@"CISourceOverCompositing"];
		[overComposite setValue:flippedFace forKey:@"inputImage"];
		[overComposite setValue:result forKey:@"inputBackgroundImage"];
		
		result = [overComposite valueForKey:@"outputImage"];
	}
	
	// Flip composited image upside down
	NSAffineTransform *flipTransform = [NSAffineTransform transform];
	[flipTransform translateXBy:0 yBy:videoHeight];
	[flipTransform scaleXBy:1 yBy:-1];
	CIFilter *flipFilter = [CIFilter filterWithName:@"CIAffineTransform"];
	[flipFilter setValue:result forKey:@"inputImage"];
	[flipFilter setValue:flipTransform forKey:@"inputTransform"];

	result = [flipFilter valueForKey:@"outputImage"];
	
	// Clear previous drawing
	[[self context] reset:YES];
	
	// Draw composite image
	[[[self context] ciCtx] drawImage:result atPoint:CGPointZero fromRect:[ciimage extent]];
}

@end
