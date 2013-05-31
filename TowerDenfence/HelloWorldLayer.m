//
//  HelloWorldLayer.m
//  TowerDenfence
//
//  Created by mir-macmini5 on 13-4-16.
//  Copyright __MyCompanyName__ 2013年. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

// HelloWorldLayer implementation
@implementation HelloWorldLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
		
//        tmxTiledMap = [CCTMXTiledMap tiledMapWithTMXFile:@"map_1.tmx"];
//        [self addChild:tmxTiledMap z:-1];

        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(50, 50, 480 - 50, 320 - 50)];
        
        view.backgroundColor = [UIColor blueColor];
        
        [[[CCDirector sharedDirector] openGLView] addSubview:view];
        
        [view release];
        
		// create and initialize a Label
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Hello World" fontName:@"Marker Felt" fontSize:64];

		// ask director the the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
	
        CCLOG(@"%f----%f",size.height,size.width);
        
		// position the label on the center of the screen
		label.position =  ccp( size.width /2 , size.height/2 );
		
		// add the label as a child to this Layer
		[self addChild: label];
	}
	return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
