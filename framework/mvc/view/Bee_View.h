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

#import "Bee_ViewPackage.h"

// common

#import "Bee_UIConfig.h"
#import "Bee_UICollection.h"
#import "Bee_UIMetrics.h"

#import "UIColor+BeeExtension.h"
#import "UIFont+BeeExtension.h"
#import "UIImage+BeeExtension.h"

// container

#import "Bee_UIApplication.h"
#import "Bee_UIBoard.h"
#import "Bee_UIRouter.h"
#import "Bee_UIStack.h"
#import "Bee_UIWindow.h"

#import "BeeUIBoard+BackwardCompatible.h"
#import "BeeUIBoard+ModalBoard.h"
#import "BeeUIBoard+ModalStack.h"
#import "BeeUIBoard+ModalView.h"
#import "BeeUIBoard+Popover.h"
#import "BeeUIBoard+Traversing.h"

#import "BeeUIStack+Popover.h"

#import "UIView+UINavigationController.h"
#import "UIView+UIViewController.h"
#import "UIViewController+LifeCycle.h"
#import "UIViewController+Metrics.h"
#import "UIViewController+Title.h"
#import "UIViewController+Traversing.h"
#import "UIViewController+UINavigationBar.h"
#import "UIViewController+UINavigationController.h"

// css

#import "Bee_UIStyle.h"
#import "Bee_UIStyleParser.h"
#import "Bee_UIStyleManager.h"

#import "BeeUIStyle+Builder.h"
#import "BeeUIStyle+Property.h"

#import "UIActivityIndicatorView+BeeUIStyle.h"
#import "UIButton+BeeUIStyle.h"
#import "UICheck+BeeUIStyle.h"
#import "UIImageView+BeeUIStyle.h"
#import "UILabel+BeeUIStyle.h"
#import "UIScrollView+BeeUILayout.h"
#import "UITextField+BeeUIStyle.h"
#import "UITextView+BeeUIStyle.h"
#import "UIView+BeeUIStyle.h"
#import "UIViewController+BeeUIStyle.h"

// dom-animation

#import "Bee_UIAnimation.h"
#import "Bee_UIAnimationAlpha.h"
#import "Bee_UIAnimationBounce.h"
#import "Bee_UIAnimationFade.h"
#import "Bee_UIAnimationStyling.h"
#import "Bee_UIAnimationZoom.h"

#import "UIView+Animation.h"

// dom-binding

#import "Bee_UIDataBinding.h"
#import "UISwitch+UIDataBinding.h"
#import "UIButton+UIDataBinding.h"
#import "UIImageView+UIDataBinding.h"
#import "UILabel+UIDataBinding.h"
#import "UITextField+UIDataBinding.h"
#import "UITextView+UIDataBinding.h"

// dom-capability

#import "Bee_UICapability.h"
#import "NSObject+UIPropertyMapping.h"

// dom-element

#import "Bee_UIAccelerometer.h"
#import "Bee_UIActionSheet.h"
#import "Bee_UIActivity.h"
#import "Bee_UIActivityIndicatorView.h"
#import "Bee_UIAlertView.h"
#import "Bee_UIButton.h"
#import "Bee_UIDatePicker.h"
#import "Bee_UIImagePickerController.h"
#import "Bee_UIImageView.h"
#import "Bee_UIKeyboard.h"
#import "Bee_UILabel.h"
#import "Bee_UIMenuController.h"
#import "Bee_UINavigationBar.h"
#import "Bee_UIPageControl.h"
#import "Bee_UIPageViewController.h"
#import "Bee_UIPickerView.h"
#import "Bee_UIProgressView.h"
#import "Bee_UIScrollView.h"
#import "Bee_UISearchBar.h"
#import "Bee_UISegmentedControl.h"
#import "Bee_UISlider.h"
#import "Bee_UISwitch.h"
#import "Bee_UITabBar.h"
#import "Bee_UITableView.h"
#import "Bee_UITextField.h"
#import "Bee_UITextView.h"
#import "Bee_UIToolbar.h"
#import "Bee_UIVideoEditorController.h"
#import "Bee_UIView.h"
#import "Bee_UIWebView.h"

#import "UIView+Background.h"
#import "UIView+LifeCycle.h"
#import "UIView+Manipulation.h"
#import "UIView+Metrics.h"
#import "UIView+HoldGesture.h"
#import "UIView+PanGesture.h"
#import "UIView+PinchGesture.h"
#import "UIView+SwipeGesture.h"
#import "UIView+Screenshot.h"
#import "UIView+Tag.h"
#import "UIView+TapGesture.h"
#import "UIView+Traversing.h"
#import "UIView+Visibility.h"

// dom-element-ext

#import "Bee_UICameraView.h"
#import "Bee_UICell.h"
#import "Bee_UIFootLoader.h"
#import "Bee_UIMatrixView.h"
#import "Bee_UIPullLoader.h"
#import "Bee_UITipsView.h"
#import "Bee_UIZoomView.h"
#import "Bee_UIZoomImageView.h"

#import "UIView+BeeUICell.h"
#import "BeeUISignal+BeeUICell.h"

// dom-layout

#import "Bee_UILayout.h"
#import "Bee_UILayoutBuilder.h"
#import "Bee_UILayoutConfig.h"
#import "Bee_UILayoutContainer.h"

#import "Bee_UIMetrics.h"

#import "UIButton+BeeUILayout.h"
#import "UIImageView+BeeUILayout.h"
#import "UILabel+BeeUILayout.h"
#import "UITextField+BeeUILayout.h"
#import "UITextView+BeeUILayout.h"
#import "UIView+BeeUILayout.h"
#import "UIViewController+BeeUILayout.h"

#import "UIButton+LayoutParser.h"
#import "UIImageView+LayoutParser.h"
#import "UILabel+LayoutParser.h"
#import "UIScrollView+LayoutParser.h"
#import "UITextField+LayoutParser.h"
#import "UITextView+LayoutParser.h"
#import "UIView+LayoutParser.h"

#import "BeeUIScrollView+LayoutParser.h"

// dom-event

#import "Bee_UISignal.h"
#import "Bee_UISignalBus.h"

#import "BeeUISignal+SourceView.h"
#import "UIView+BeeUISignal.h"
#import "UIViewController+BeeUISignal.h"

// dom-query

#import "Bee_UIQuery.h"
#import "BeeUIQuery+CSS.h"
#import "BeeUIQuery+Dimensions.h"
#import "BeeUIQuery+Effects.h"
#import "BeeUIQuery+Events.h"
#import "BeeUIQuery+Manipulation.h"
#import "BeeUIQuery+Miscellaneous.h"
#import "BeeUIQuery+Offset.h"
#import "BeeUIQuery+Transform.h"
#import "BeeUIQuery+Traversing.h"
#import "BeeUIQuery+Value.h"

// dom-transition

#import "Bee_UITransition.h"
#import "Bee_UITransitionCube.h"
#import "Bee_UITransitionFade.h"
#import "Bee_UITransitionFlip.h"
#import "Bee_UITransitionPush.h"

#import "UIView+Transition.h"
#import "UIViewController+Transition.h"

// view-model

#import "Bee_ViewModel.h"
#import "BeeUISignal+SourceModel.h"
#import "BeeViewModel+BeeUISignal.h"

#import "Bee_OnceViewModel.h"
#import "Bee_StreamViewModel.h"
#import "Bee_PagingViewModel.h"
#import "Bee_PublishViewModel.h"

// template

#import "Bee_UITemplate.h"
#import "Bee_UITemplateManager.h"
#import "Bee_UITemplateParser.h"
#import "Bee_UITemplateParserAndroid.h"
#import "Bee_UITemplateParserXML.h"

#import "UIView+BeeUITemplate.h"
#import "UIViewController+BeeUITemplate.h"

// backward compatible

#import "UINavigationBar+BeeExtension.h"
#import "UIView+BeeExtension.h"

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
