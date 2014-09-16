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

#import "Bee.h"

#pragma mark -

@interface PBXNode : NSObject

+ (instancetype)node;
+ (instancetype)findNode:(NSString *)key;

- (NSString *)key;
- (void)generateKey;

@end

#pragma mark -

@interface PBXBuildFile : PBXNode
@property (nonatomic, retain) NSString *			isa;
@property (nonatomic, retain) NSString *			fileRef;
@end

#pragma mark -

typedef enum
{
	PBXFileReferenceTypeUnknown = 0,
	PBXFileReferenceTypeFramework,
	PBXFileReferenceTypeSource,
	PBXFileReferenceTypeResource,
	PBXFileReferenceTypeProduct
} PBXFileReferenceType;

@interface PBXFileReference : PBXNode
@property (nonatomic, retain) NSString *			isa;
@property (nonatomic, retain) NSString *			explicitFileType;
@property (nonatomic, retain) NSString *			lastKnownFileType;
@property (nonatomic, retain) NSNumber *			includeInIndex;
@property (nonatomic, retain) NSNumber *			fileEncoding;
@property (nonatomic, retain) NSString *			path;
@property (nonatomic, retain) NSString *			sourceTree;

+ (instancetype)node:(NSString *)fileName;

- (BOOL)isBuildable;

- (PBXFileReferenceType)type;
- (void)setType:(PBXFileReferenceType)type;

@end

#pragma mark -

@interface PBXBuildPhase : PBXNode
@property (nonatomic, retain) NSString *			isa;
@property (nonatomic, retain) NSString *			buildActionMask;
@property (nonatomic, retain) NSMutableArray *		files;
@property (nonatomic, retain) NSNumber *			runOnlyForDeploymentPostprocessing;
@end

@interface PBXFrameworksBuildPhase : PBXBuildPhase
@end
@interface PBXResourcesBuildPhase : PBXBuildPhase
@end
@interface PBXSourcesBuildPhase : PBXBuildPhase
@end

#pragma mark -

@interface PBXGroup : PBXNode
@property (nonatomic, retain) NSString *			isa;
@property (nonatomic, retain) NSString *			name;
@property (nonatomic, retain) NSString *			path;
@property (nonatomic, retain) NSMutableArray *		children;
@property (nonatomic, retain) NSString *			sourceTree;
@end

#pragma mark -

@interface PBXNativeTarget : PBXNode
@property (nonatomic, retain) NSString *			isa;
@property (nonatomic, retain) NSString *			buildConfigurationList;
@property (nonatomic, retain) NSMutableArray *		buildPhases;
@property (nonatomic, retain) NSMutableArray *		buildRules;
@property (nonatomic, retain) NSMutableArray *		dependencies;
@property (nonatomic, retain) NSString *			name;
@property (nonatomic, retain) NSString *			productName;
@property (nonatomic, retain) NSString *			productReference;
@property (nonatomic, retain) NSString *			productType;
@end

#pragma mark -

@interface PBXProject : PBXNode
@property (nonatomic, retain) NSString *			isa;
@property (nonatomic, retain) NSMutableDictionary *	attributes;
@property (nonatomic, retain) NSString *			buildConfigurationList;
@property (nonatomic, retain) NSString *			compatibilityVersion;
@property (nonatomic, retain) NSString *			developmentRegion;
@property (nonatomic, retain) NSNumber *			hasScannedForEncodings;
@property (nonatomic, retain) NSMutableArray *		knownRegions;
@property (nonatomic, retain) NSString *			mainGroup;
@property (nonatomic, retain) NSString *			productRefGroup;
@property (nonatomic, retain) NSString *			projectDirPath;
@property (nonatomic, retain) NSString *			projectRoot;
@property (nonatomic, retain) NSMutableArray *		targets;
@end

#pragma mark -

@interface XCBuildConfiguration : PBXNode
@property (nonatomic, retain) NSString *			isa;
@property (nonatomic, retain) NSMutableDictionary *	buildSettings;
@property (nonatomic, retain) NSString *			name;
@end

#pragma mark -

@interface XCConfigurationList : PBXNode
@property (nonatomic, retain) NSString *			isa;
@property (nonatomic, retain) NSMutableArray *		buildConfigurations;
@property (nonatomic, retain) NSNumber *			defaultConfigurationIsVisible;
@property (nonatomic, retain) NSString *			defaultConfigurationName;
@end

#pragma mark -

@interface PListBuilder : NSObject
+ (NSString *)objectToString:(id)obj indent:(int)indent;
+ (NSString *)objectToString:(id)obj indent:(int)indent key:(NSString *)parentKey;
@end

#pragma mark -

@interface ProjectBuilder : NSObject

@property (nonatomic, retain) NSString *			applicationName;
@property (nonatomic, retain) NSString *			organizationName;
@property (nonatomic, retain) NSString *			deploymentTarget;

@property (nonatomic, retain) NSMutableArray *		fileNames;
@property (nonatomic, retain) NSMutableArray *		libraries;
@property (nonatomic, retain) NSMutableArray *		frameworks;
@property (nonatomic, retain) NSMutableArray *		otherFlags;
@property (nonatomic, retain) NSMutableArray *		architectures;
@property (nonatomic, retain) NSMutableArray *		headerSearchPaths;
@property (nonatomic, retain) NSMutableArray *		librarySearchPaths;

@property (nonatomic, retain) NSString *			errorDesc;

- (void)addFile:(NSString *)file;
- (void)addLibrary:(NSString *)lib;
- (void)addFramework:(NSString *)framework;
- (void)addOtherFlag:(NSString *)flag;
- (void)addArchitecture:(NSString *)arch;
- (void)addHeaderSearchPath:(NSString *)path;
- (void)addLibrarySearchPath:(NSString *)path;

- (NSString *)toString;

@end
