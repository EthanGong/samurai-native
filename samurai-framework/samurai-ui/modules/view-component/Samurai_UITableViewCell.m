//
//     ____    _                        __     _      _____
//    / ___\  /_\     /\/\    /\ /\    /__\   /_\     \_   \
//    \ \    //_\\   /    \  / / \ \  / \//  //_\\     / /\/
//  /\_\ \  /  _  \ / /\/\ \ \ \_/ / / _  \ /  _  \ /\/ /_
//  \____/  \_/ \_/ \/    \/  \___/  \/ \_/ \_/ \_/ \____/
//
//	Copyright Samurai development team and other contributors
//
//	http://www.samurai-framework.com
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//	THE SOFTWARE.
//

#import "Samurai_UITableViewCell.h"
#import "Samurai_UIView.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation UITableViewCell(Samurai)

+ (id)createInstanceWithRenderer:(SamuraiRenderObject *)renderer identifier:(NSString *)identifier
{
	UITableViewCell * tableViewCell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
	
	tableViewCell.renderer = renderer;
	tableViewCell.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	tableViewCell.userInteractionEnabled = YES;
	
	return tableViewCell;
}

#pragma mark -

- (void)dataWillChange
{
}

- (void)dataDidChanged
{
}

#pragma mark -

- (id)serialize
{
	SamuraiRenderObject * renderObject = [self renderer];
	if ( nil == renderObject )
		return nil;
	
	return [[SamuraiRenderStoreScope storeScope:renderObject] getData];
}

- (void)unserialize:(id)obj
{
	SamuraiRenderObject * renderObject = [self renderer];
	if ( nil == renderObject )
		return;
	
	[self dataWillChange];
	
	for ( SamuraiRenderObject * childRender in renderObject.childs )
	{
		[[SamuraiRenderStoreScope storeScope:childRender] setData:obj];
	}
	
	[self dataDidChanged];
}

- (void)zerolize
{
	SamuraiRenderObject * renderObject = [self renderer];
	if ( nil == renderObject )
		return;
	
	[self dataWillChange];
	
	[[SamuraiRenderStoreScope storeScope:renderObject] clearData];
	
	[self dataDidChanged];
}

#pragma mark -

- (void)applyFrame:(CGRect)frame
{
	[super applyFrame:frame];
}

#pragma mark -

- (CGSize)computeSizeBySize:(CGSize)size
{
	return [super computeSizeBySize:size];
}

- (CGSize)computeSizeByWidth:(CGFloat)width
{
	return [super computeSizeByWidth:width];
}

- (CGSize)computeSizeByHeight:(CGFloat)height
{
	return [super computeSizeByHeight:height];
}

#pragma mark -

- (BOOL)isCell
{
	return YES;
}

- (BOOL)isCellContainer
{
	return NO;
}

- (NSIndexPath *)computeIndexPath
{
	for ( UIView * thisView = self.superview; nil != thisView; thisView = thisView.superview )
	{
		if ( [thisView isCellContainer] && [thisView isKindOfClass:[UITableView class]] )
		{
			return [(UITableView *)thisView indexPathForCell:self];
		}
	}
	
	return nil;
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( UI, UITableViewCell )

DESCRIBE( before )
{
}

DESCRIBE( after )
{
}

TEST_CASE_END

#endif	// #if __SAMURAI_TESTING__

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "_pragma_pop.h"
