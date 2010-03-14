#import "HaarClassifierWrapper.h"


@implementation HaarClassifierWrapper

@synthesize objects;

- (id) initWithClassifierFile:(NSString *)classifierPath
{
	self = [super init];
	
	if( self != nil )
	{
		classifier = (CvHaarClassifierCascade*) cvLoad ([classifierPath cStringUsingEncoding:NSASCIIStringEncoding], NULL, NULL, NULL);
		storage = cvCreateMemStorage(0);
		
		if(!classifier || !storage) return nil;
	}
	
	return self;
}

- (void) detectWithIplImage:(IplImageWrapper *)image
{
	CvSeq* cvObjects = cvHaarDetectObjects([image iplImage], classifier, storage,
									   HAAR_SCALE_FACTOR, HAAR_MIN_NEIGHBORS,
									   HAAR_FLAGS, cvSize(30, 30));
	
	int numberOfObjects = cvObjects ? cvObjects->total : 0;
	
	[objects autorelease];
	objects = [[NSMutableArray alloc] initWithCapacity:numberOfObjects];
	
	for (int i = 0; i < numberOfObjects; i++) {
		CvRect* cvRect = (CvRect*) cvGetSeqElem (cvObjects, i);
		[objects addObject:[CIVector vectorWithX:cvRect->x
											   Y:[image iplImage]->height - (cvRect->y + cvRect->height) // Convert to CI coordinates
											   Z:cvRect->width
											   W:cvRect->height]];
	}
}

- (void) dealloc
{
	cvReleaseMemStorage(&storage);
	
	[objects release];
	
	[super dealloc];
}

@end
