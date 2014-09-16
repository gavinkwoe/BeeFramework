//
//	 ______    ______    ______
//	/\  __ \  /\  ___\  /\  ___\
//	\ \  __<  \ \  __\_ \ \  __\_
//	 \ \_____\ \ \_____\ \ \_____\
//	  \/_____/  \/_____/  \/_____/
//
//
//	Copyright (c) 2014-2015, Geek Zoo Studio
//	http://www.bee-framework.com
//
//
//	Permission is hereby granted, free of charge, to any person obtaining a
//	copy of this software and associated documentation files (the "Software"),
//	to deal in the Software without restriction, including without limitation
//	the rights to use, copy, modify, merge, publish, distribute, sublicense,
//	and/or sell copies of the Software, and to permit persons to whom the
//	Software is furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//	IN THE SOFTWARE.
//

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "UIView+BeeUIStyle.h"
#import "UIView+BeeUILayout.h"
#import "UIView+Background.h"
#import "UIView+Tag.h"

#import "UIImage+BeeExtension.h"
#import "UIColor+BeeExtension.h"
#import "UIFont+BeeExtension.h"

#import "Bee_UIStyleParser.h"
#import "Bee_UIStyle.h"
#import "BeeUIStyle+Builder.h"
#import "BeeUIStyle+Property.h"
#import "BeeUILayout+CSSElement.h"

#pragma mark -

#undef	KEY_STYLE_CLASSES
#define KEY_STYLE_CLASSES		"UIView.styleClasses"

#undef	KEY_STYLE_INLINE
#define KEY_STYLE_INLINE		"UIView.styleInline"

#undef	KEY_STYLE_CUSTOM
#define KEY_STYLE_CUSTOM		"UIView.styleCustom"

#undef	KEY_STYLE
#define KEY_STYLE				"UIView.style"

#undef	KEY_LAYOUT_TAG
#define KEY_LAYOUT_TAG			"UIView.layoutTag"

#undef	KEY_LAYOUT_CLASS_NAME
#define KEY_LAYOUT_CLASS_NAME	"UIView.layoutClassName"

#undef	KEY_LAYOUT_ELEM_NAME
#define KEY_LAYOUT_ELEM_NAME	"UIView.layoutElemName"

#undef	KEY_DOM_PATH
#define KEY_DOM_PATH			"UIView.DOMPath"

#undef	KEY_ROOT_STYLE
#define KEY_ROOT_STYLE			"UIView.rootStyle"

#pragma mark -

@implementation UIView(BeeUIStyle)

@dynamic css;
@dynamic cssSelector;
@dynamic cssResource;

@dynamic UIStyleClasses;
@dynamic UIStyleInline;
@dynamic UIStyleCustom;
@dynamic UIStyleRoot;
@dynamic UIStyle;

@dynamic UILayoutTag;
@dynamic UILayoutClassName;
@dynamic UILayoutElemName;

@dynamic UIDOMPath;

@dynamic GET_ATTRIBUTE;
@dynamic SET_ATTRIBUTE;

- (NSString *)css
{
	return self.UIStyle.css;
}

- (void)setCss:(NSString *)css
{
	self.UIStyleCustom.CSS( css );

	[self mergeStyle];
	[self applyStyle];
}

//- (NSString *)cssSelector
//{
//	NSMutableArray * array = objc_getAssociatedObject( self, KEY_STYLE_CLASSES );
//	if ( nil == array )
//	{
//		array = [NSMutableArray array];
//		objc_setAssociatedObject( self, KEY_STYLE_CLASSES, array, OBJC_ASSOCIATION_RETAIN_NONATOMIC );
//	}
//	return array;
//}
//
//- (void)setUIStyleClasses:(NSMutableArray *)styleClasses
//{
//	NSMutableArray * classes = objc_getAssociatedObject( self, KEY_STYLE_CLASSES );
//	if ( classes != styleClasses )
//	{
//		objc_setAssociatedObject( self, KEY_STYLE_CLASSES, styleClasses, OBJC_ASSOCIATION_RETAIN_NONATOMIC );
//	}
//}

- (NSMutableArray *)UIStyleClasses
{
	NSMutableArray * array = objc_getAssociatedObject( self, KEY_STYLE_CLASSES );
	if ( nil == array )
	{
		array = [NSMutableArray array];
		objc_setAssociatedObject( self, KEY_STYLE_CLASSES, array, OBJC_ASSOCIATION_RETAIN_NONATOMIC );
	}
	return array;
}

- (void)setUIStyleClasses:(NSMutableArray *)styleClasses
{
	NSMutableArray * classes = objc_getAssociatedObject( self, KEY_STYLE_CLASSES );
	if ( classes != styleClasses )
	{
		objc_setAssociatedObject( self, KEY_STYLE_CLASSES, styleClasses, OBJC_ASSOCIATION_RETAIN_NONATOMIC );
	}
}

- (BeeUIStyle *)UIStyleInline
{
	BeeUIStyle * style = objc_getAssociatedObject( self, KEY_STYLE_INLINE );
	if ( nil == style )
	{
		style = [BeeUIStyle style];
		objc_setAssociatedObject( self, KEY_STYLE_INLINE, style, OBJC_ASSOCIATION_RETAIN_NONATOMIC );
	}
	return style;
}

- (void)setUIStyleInline:(BeeUIStyle *)newStyle
{
	BeeUIStyle * style = objc_getAssociatedObject( self, KEY_STYLE_INLINE );
	if ( style != newStyle )
	{
		objc_setAssociatedObject( self, KEY_STYLE_INLINE, newStyle, OBJC_ASSOCIATION_RETAIN_NONATOMIC );
	}
}

- (BeeUIStyle *)UIStyleCustom
{
	BeeUIStyle * style = objc_getAssociatedObject( self, KEY_STYLE_CUSTOM );
	if ( nil == style )
	{
		style = [BeeUIStyle style];
		objc_setAssociatedObject( self, KEY_STYLE_CUSTOM, style, OBJC_ASSOCIATION_RETAIN_NONATOMIC );
	}
	return style;
}

- (void)setUIStyleCustom:(BeeUIStyle *)newStyle
{
	BeeUIStyle * style = objc_getAssociatedObject( self, KEY_STYLE_CUSTOM );
	if ( style != newStyle )
	{
		objc_setAssociatedObject( self, KEY_STYLE_CUSTOM, newStyle, OBJC_ASSOCIATION_RETAIN_NONATOMIC );
	}
}

- (BeeUIStyle *)UIStyle
{
	return objc_getAssociatedObject( self, KEY_STYLE );
}

- (void)setUIStyle:(BeeUIStyle *)newStyle
{
	BeeUIStyle * style = objc_getAssociatedObject( self, KEY_STYLE );
	if ( style != newStyle )
	{
		objc_setAssociatedObject( self, KEY_STYLE, newStyle, OBJC_ASSOCIATION_RETAIN_NONATOMIC );
	}
}

- (BeeUIStyle *)UIStyleRoot
{
	return objc_getAssociatedObject( self, KEY_ROOT_STYLE );
}

- (void)setUIStyleRoot:(BeeUIStyle *)newStyle
{
	BeeUIStyle * style = objc_getAssociatedObject( self, KEY_ROOT_STYLE );
	if ( style != newStyle )
	{
		objc_setAssociatedObject( self, KEY_ROOT_STYLE, newStyle, OBJC_ASSOCIATION_RETAIN_NONATOMIC );
	}
}

- (NSString *)UILayoutTag
{
	return objc_getAssociatedObject( self, KEY_LAYOUT_TAG );
}

- (void)setUILayoutTag:(NSString *)newTag
{
	NSString * tag = objc_getAssociatedObject( self, KEY_LAYOUT_TAG );
	if ( tag != newTag )
	{
		objc_setAssociatedObject( self, KEY_LAYOUT_TAG, newTag, OBJC_ASSOCIATION_RETAIN_NONATOMIC );
	}
}

- (NSString *)UILayoutClassName
{
	return objc_getAssociatedObject( self, KEY_LAYOUT_CLASS_NAME );
}

- (void)setUILayoutClassName:(NSString *)newClassName
{
	NSString * className = objc_getAssociatedObject( self, KEY_LAYOUT_CLASS_NAME );
	if ( className != newClassName )
	{
		objc_setAssociatedObject( self, KEY_LAYOUT_CLASS_NAME, newClassName, OBJC_ASSOCIATION_RETAIN_NONATOMIC );
	}
}

- (NSString *)UILayoutElemName
{
	return objc_getAssociatedObject( self, KEY_LAYOUT_ELEM_NAME );
}

- (void)setUILayoutElemName:(NSString *)newElemName
{
	NSString * elemName = objc_getAssociatedObject( self, KEY_LAYOUT_ELEM_NAME );
	if ( elemName != newElemName )
	{
		objc_setAssociatedObject( self, KEY_LAYOUT_ELEM_NAME, newElemName, OBJC_ASSOCIATION_RETAIN_NONATOMIC );
	}
}

- (NSString *)UIDOMPath
{
	return objc_getAssociatedObject( self, KEY_DOM_PATH );
}

- (void)setUIDOMPath:(NSString *)path
{
	NSString * domPath = objc_getAssociatedObject( self, KEY_DOM_PATH );
	if ( domPath != path )
	{
		objc_setAssociatedObject( self, KEY_DOM_PATH, path, OBJC_ASSOCIATION_RETAIN_NONATOMIC );
	}
}

#pragma mark -

- (BeeUIStyleValueBlockS)GET_ATTRIBUTE
{
	BeeUIStyleValueBlockS block = ^ id ( NSString * name )
	{
		if ( name )
		{
			return [self.UIStyle.properties objectForKey:name];
		}
		else
		{
			return nil;
		}
	};
	
	return [[block copy] autorelease];
}

- (BeeUIStyleValueBlockSS)SET_ATTRIBUTE
{
	BeeUIStyleValueBlockSS block = ^ id ( NSString * name, NSString * value )
	{
		if ( name )
		{
			[self.UIStyle.properties setObject:value forKey:name];
		}

		return self;
	};
	
	return [[block copy] autorelease];
}

#pragma mark -

- (BOOL)hasStyleClass:(NSString *)className
{
	NSArray * array = self.UIStyleClasses;
	if ( nil == array )
		return NO;

	for ( NSString * tagClass in self.UIStyleClasses )
	{
		if ( [className isEqualToString:tagClass] )
		{
			return YES;
		}
	}
	
	return NO;
}

- (void)addStyleClass:(NSString * )className
{
	BOOL found = [self hasStyleClass:className];
	if ( NO == found )
	{
		[self.UIStyleClasses addObject:className];
	}
}

- (void)removeStyleClass:(NSString * )className
{
	BOOL found = [self hasStyleClass:className];
	if ( found )
	{
		[self.UIStyleClasses removeObject:className];
	}
}

- (void)toggleStyleClass:(NSString * )className
{
	BOOL found = [self hasStyleClass:className];
	if ( NO == found )
	{
		[self.UIStyleClasses addObject:className];
	}
	else
	{
		[self.UIStyleClasses removeObject:className];
	}
}

- (void)removeAllStyleClasses
{
	[self.UIStyleClasses removeAllObjects];
}

- (void)addStyleProperties:(NSDictionary *)dict
{
	BeeUIStyle * custom = self.UIStyleCustom;
	if ( custom )
	{
		self.UIStyleCustom.CSS( dict );
	}
}

- (void)removeStyleProperties:(NSDictionary *)dict
{
	// TODO:
}

- (void)mergeStyle
{
	BeeUIStyle * style1 = self.UIStyleInline;
    BeeUIStyle * style2 = self.UIStyleCustom;
	BeeUIStyle * style3 = [self.UIStyleRoot childStyleWithClasses:self.UIStyleClasses];
	BeeUIStyle * style4 = [self.UIStyleRoot childStyleWithElement:self.layout];

	if ( style2 || style3 || self.UIStyleClasses.count )
	{
		BeeUIStyle * merged = [BeeUIStyle style];

		if ( style4 && style4.properties.count )
		{
			[style4 mergeTo:merged];
		}
		
		if ( style3 && style3.properties.count )
		{
			[style3 mergeTo:merged];
		}
		
		if ( style2 && style2.properties.count )
		{
			[style2 mergeTo:merged];
		}
		
		if ( style1 && style1.properties.count )
		{
			[style1 mergeTo:merged];
		}
		
		self.tagString = self.UILayoutTag;
		self.tagClasses = self.UIStyleClasses;
		
		self.UIStyle = merged;
	}
	else
	{
		self.UIStyle = self.UIStyleInline;
	}
}

- (void)applyStyle
{
	if ( nil == self.UIStyle )
	{
		[self mergeStyle];
	}

	if ( self.UIStyle )
	{
		[self applyUIStyling:self.UIStyle.properties];
	}
}

#pragma mark -

+ (BOOL)supportForUIStyling
{
	return YES;
}

- (void)applyViewBackgroundImage:(NSMutableDictionary *)properties
{
	BOOL				stretched = NO;
	BOOL				rounded = NO;
	BOOL				pattern = NO;
	BOOL				grayed = NO;

	UIEdgeInsets		contentInsets = UIEdgeInsetsZero;
	UIViewContentMode	contentMode = self.contentMode;
	NSString *			relativePath = [properties objectForKey:@"package"];

	BeeUIImageView *	backgroundImageView = nil;

// old styels
	
	NSString * imageMode = [properties parseStringWithKeys:@[@"background-mode", @"background-image-mode"]];
    if ( imageMode )
    {
		if ( [imageMode matchAnyOf:@[@"stretch", @"stretched"]] )
		{
			stretched = YES;
			contentMode = UIViewContentModeScaleToFill;
		}
		else if ( [imageMode matchAnyOf:@[@"round", @"rounded"]] )
		{
			rounded = YES;
			contentMode = UIViewContentModeScaleAspectFit;
		}
		else
		{
			contentMode = UIViewContentModeFromString( imageMode );
		}
    }

	NSString * imageInsets = [properties parseStringWithKeys:@[@"background-insets", @"background-image-insets"]];
	if ( imageInsets )
	{
		contentInsets = UIEdgeInsetsFromStringEx( imageInsets );
	}
	
	NSArray * imageStyles = [properties parseComponentsWithKeys:@[@"background-style", @"background-image-style"]];
	for ( NSString * segment in imageStyles )
	{
		if ( [segment matchAnyOf:@[@"gray", @"grayed"]] )
		{
			grayed = YES;
		}
		else if ( [segment matchAnyOf:@[@"pattern", @"repeat"]] )
		{
			pattern = YES;
		}
	}
	
// new styels
	
	NSString * imageStretch = [properties parseStringWithKeys:@[@"background-stretch", @"background-stretched"]];
	if ( imageStretch )
	{
		stretched = YES;
		contentMode = UIViewContentModeScaleToFill;
		contentInsets = UIEdgeInsetsFromStringEx( imageStretch );
	}
	
	NSString * imageRounded = [properties parseStringWithKeys:@[@"background-round", @"background-rounded"]];
	if ( imageRounded )
	{
		rounded = [imageRounded boolValue];
		
		if ( rounded )
		{
			contentMode = UIViewContentModeScaleAspectFit;
		}
	}
	
	NSString * imageGrayed = [properties parseStringWithKeys:@[@"background-gray", @"background-grayed"]];
	if ( imageGrayed )
	{
		grayed = [imageGrayed boolValue];
	}
	
	NSString * imageRepeat = [properties parseStringWithKeys:@[@"background-pattern", @"background-repeat"]];
	if ( imageRepeat )
	{
		pattern = [imageRepeat boolValue];
	}

	NSString * imageName = [properties parseURLWithKeys:@[@"background-src", @"background-image", @"background-image-src"]];
    if ( imageName )
    {
		backgroundImageView = self.backgroundImageView;
    }
	else
	{
		if ( self.hasBackgroundImageView )
		{
			backgroundImageView = self.backgroundImageView;
		}
	}
	
// apply effects

	if ( backgroundImageView )
	{
		backgroundImageView.strechInsets = contentInsets;
		backgroundImageView.strech = stretched;

		backgroundImageView.round = rounded;
		backgroundImageView.gray = grayed;
		backgroundImageView.pattern = pattern;

		if ( imageName && imageName.length )
		{
			if ( [imageName hasPrefix:@"http://"] || [imageName hasPrefix:@"https://"] )
			{
				backgroundImageView.url = imageName;
			}
			else
			{
				UIImage * image = nil;
				
				if ( nil == image && relativePath )
				{
					NSString * absolutePath = [relativePath stringByAppendingPathComponent:imageName];
					if ( [[NSFileManager defaultManager] fileExistsAtPath:absolutePath] )
					{
						image = [[[UIImage alloc] initWithContentsOfFile:absolutePath] autorelease];
					}
				}
				
				if ( nil == image )
				{
					image = [UIImage imageNamed:imageName];
				}
				
				if ( image )
				{
					if ( stretched )
					{
						if ( NO == UIEdgeInsetsEqualToEdgeInsets(contentInsets, UIEdgeInsetsZero) )
						{
							backgroundImageView.image = [image stretched:contentInsets];
						}
						else
						{
							backgroundImageView.image = [image stretched];
						}
					}
					else
					{
						backgroundImageView.image = image;
					}
				}
			}
		}
		
		backgroundImageView.contentMode = contentMode;
	}
}

- (void)applyViewBackgroundColor:(NSMutableDictionary *)properties
{
	UIColor * color = [properties parseColorWithKeys:@[@"background-color", @"bgcolor"] defaultValue:self.backgroundColor];
	self.backgroundColor = color;
}

- (void)applyViewBorder:(NSMutableDictionary *)properties
{
// border:5px solid red
	
    NSString * border = [properties parseStringWithKeys:@[@"border"]];
    if ( border && border.length )
    {
		NSArray * segments = [border componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
		if ( segments.count == 3 )
		{
			NSString * width = [segments objectAtIndex:0];
//			NSString * type = [segments objectAtIndex:1];
			NSString * color = [segments objectAtIndex:2];

			// TODO: type
			
			self.layer.borderWidth = width.floatValue;
			self.layer.borderColor = [UIColor colorWithString:color].CGColor;
		}
		else if ( segments.count == 2 )
		{
			NSString * width = [segments objectAtIndex:0];
			NSString * color = [segments objectAtIndex:1];
			
			self.layer.borderWidth = width.floatValue;
			self.layer.borderColor = [UIColor colorWithString:color].CGColor;
		}
		else
		{
			self.layer.borderWidth = 0.0f;
			self.layer.borderColor = [UIColor clearColor].CGColor;
		}
    }
	else
	{
		self.layer.borderWidth = 0.0f;
		self.layer.borderColor = [UIColor clearColor].CGColor;
	}

// border-color, border-width, border-radius

	self.layer.borderColor = [properties parseColorWithKeys:@[@"border-color"] defaultValue:[UIColor clearColor]].CGColor;
	self.layer.borderWidth = [properties parseFloatWithKeys:@[@"border-width"] defaultValue:0.0f];
	self.layer.cornerRadius = [properties parseFloatWithKeys:@[@"border-radius", @"corner-radius"] defaultValue:0.0f];

	if ( self.layer.cornerRadius > 0.0f )
	{
		self.layer.masksToBounds = YES;
	}
}

- (void)applyViewContent:(NSMutableDictionary *)properties
{
	self.tag = [properties parseIntegerWithKeys:@[@"tag"] defaultValue:self.tag];
	self.contentMode = [properties parseContentModeWithKeys:@[@"mode", @"content-mode"] defaultValue:self.contentMode];
}

- (void)applyViewOverflow:(NSMutableDictionary *)properties
{
    NSString * overflow = [properties parseStringWithKeys:@[@"overflow"]];
    if ( overflow && overflow.length )
    {
		if ( [overflow matchAnyOf:@[@"visible"]] )
		{
			self.layer.masksToBounds = NO;
		}
		else if ( [overflow matchAnyOf:@[@"hidden"]] )
		{
			self.layer.masksToBounds = YES;
		}
    }
}

- (void)applyViewVisibility:(NSMutableDictionary *)properties
{
// opaque
	
	self.alpha = [properties parseFloatWithKeys:@[@"alpha", @"opaque", @"opacity"] defaultValue:self.alpha];

// display
	
    NSString * display = [properties parseStringWithKeys:@[@"display"]];

    if ( display && display.length )
    {
		if ( [display matchAnyOf:@[@"none"]] )
		{
			[self setHidden:YES];
		}
		else if ( [display matchAnyOf:@[@"inline"]] )
		{
			[self setHidden:NO];
		}
		else
		{
			[self setHidden:NO];
		}
    }
	else
	{
//		[self setHidden:NO];
	}
}

- (void)applyViewShadow:(NSMutableDictionary *)properties
{
	self.layer.shadowColor = [properties parseColorWithKeys:@[@"shadow-color"] defaultValue:[UIColor clearColor]].CGColor;
	self.layer.shadowOffset = [properties parseSizeWithKeys:@[@"shadow-offset"] defaultValue:CGSizeZero];
	self.layer.shadowOpacity = [properties parseFloatWithKeys:@[@"shadow-opacity"] defaultValue:1.0f];
	self.layer.shadowRadius = [properties parseFloatWithKeys:@[@"shadow-radius"] defaultValue:1.0f];
//	self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
}

- (void)applyUIStyling:(NSDictionary *)properties
{
	NSMutableDictionary * propertiesCopy = [NSMutableDictionary dictionaryWithDictionary:properties];

	[self applyViewBorder:propertiesCopy];
	[self applyViewBackgroundColor:propertiesCopy];
	[self applyViewBackgroundImage:propertiesCopy];
	[self applyViewContent:propertiesCopy];
	[self applyViewShadow:propertiesCopy];
	[self applyViewOverflow:propertiesCopy];
	[self applyViewVisibility:propertiesCopy];
	
	[super applyUIStyling:propertiesCopy];
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
