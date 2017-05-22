//
//  APLGestureRecognizerViewController.swift
//  SimpleGestureRecognizers
//
//  Created by 開発 on 2016/1/2.
//
//
//
/*
     File: APLGestureRecognizerViewController.m
     File: APLGestureRecognizerViewController.h
 Abstract: A view controller that manages a view and four gesture recognizers.
 The gesture recognizers recognize taps, right and left swipes, and rotation gestures respectively. When they recognize a gesture, the recognizers send a suitable message to the view controller, which in turn displays an appropriate image at the location of the gesture.

 For the purposes of example, the view contains a segmented control that can toggle recognition of left swipe gestures. The view controller maintains a reference to the left swipe gesture recognizer so that the recognizer can be added to and removed from the view as appropriate.

 Notice that recognizers ignore the exclusiveTouch setting of views.

  Version: 2.5

 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.

 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.

 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.

 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.

 Copyright (C) 2013 Apple Inc. All Rights Reserved.

 */

import UIKit

@objc(APLGestureRecognizerViewController)
class APLGestureRecognizerViewController: UIViewController, UIGestureRecognizerDelegate {
    
    
    @IBOutlet var tapRecognizer: UITapGestureRecognizer!
    @IBOutlet var swipeLeftRecognizer: UISwipeGestureRecognizer!
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var segmentedControl: UISegmentedControl!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if self.segmentedControl.selectedSegmentIndex == 0 {
            self.view.addGestureRecognizer(self.swipeLeftRecognizer)
        } else {
            self.view.removeGestureRecognizer(self.swipeLeftRecognizer)
        }
        
        // For illustrative purposes, set exclusive touch for the segmented control (see the ReadMe).
        self.segmentedControl.isExclusiveTouch = true
    }
    
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        
        return .all
    }
    
    
    @IBAction func takeLeftSwipeRecognitionEnabledFrom(_ aSegmentedControl: UISegmentedControl) {
        
        /*
        Add or remove the left swipe recogniser to or from the view depending on the selection in the segmented control.
        */
        if aSegmentedControl.selectedSegmentIndex == 0 {
            self.view.addGestureRecognizer(self.swipeLeftRecognizer)
        } else {
            self.view.removeGestureRecognizer(self.swipeLeftRecognizer)
        }
    }
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        // Disallow recognition of tap gestures in the segmented control.
        if touch.view === self.segmentedControl && gestureRecognizer === self.tapRecognizer {
            return false
        }
        return true
    }
    
    
    //MARK: -
    //MARK: Responding to gestures
    
    /*
    In response to a tap gesture, show the image view appropriately then make it fade out in place.
    */
    @IBAction func showGestureForTapRecognizer(_ recognizer: UITapGestureRecognizer) {
        
        let location = recognizer.location(in: self.view)
        self.drawImageForGestureRecognizer(recognizer, atPoint: location)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.imageView.alpha = 0.0
        }) 
    }
    
    
    /*
    In response to a swipe gesture, show the image view appropriately then move the image view in the direction of the swipe as it fades out.
    */
    //- (IBAction)showGestureForSwipeRecognizer:(UISwipeGestureRecognizer *)recognizer {
    @IBAction func showGestureForSwipeRecognizer(_ recognizer: UISwipeGestureRecognizer) {
        
        var location = recognizer.location(in: self.view)
        self.drawImageForGestureRecognizer(recognizer, atPoint: location)
        
        if recognizer.direction == .left {
            location.x -= 220.0
        } else {
            location.x += 220.0
        }
        
        UIView.animate(withDuration: 0.5, animations: {
            self.imageView.alpha = 0.0
            self.imageView.center = location
        }) 
    }
    
    
    /*
    In response to a rotation gesture, show the image view at the rotation given by the recognizer. At the end of the gesture, make the image fade out in place while rotating back to horizontal.
    */
    @IBAction func showGestureForRotationRecognizer(_ recognizer: UIRotationGestureRecognizer) {
        
        let location = recognizer.location(in: self.view)
        
        let transform = CGAffineTransform(rotationAngle: recognizer.rotation)
        self.imageView.transform = transform
        self.drawImageForGestureRecognizer(recognizer, atPoint: location)
        
        /*
        If the gesture has ended or is cancelled, begin the animation back to horizontal and fade out.
        */
        if recognizer.state == .ended || recognizer.state == .cancelled {
            UIView.animate(withDuration: 0.5, animations: {
                self.imageView.alpha = 0.0
                self.imageView.transform = CGAffineTransform.identity
            }) 
        }
    }
    
    
    //MARK: -
    //MARK: Drawing the image view
    
    /*
    Set the appropriate image for the image view for the given gesture recognizer, move the image view to the given point, then dispay the image view by setting its alpha to 1.0.
    */
    private func drawImageForGestureRecognizer(_ recognizer: UIGestureRecognizer, atPoint centerPoint: CGPoint) {
        
        let imageName: String
        
        if type(of: recognizer) === UITapGestureRecognizer.self {
            imageName = "tap.png"
        } else if type(of: recognizer) === UIRotationGestureRecognizer.self {
            imageName = "rotation.png"
        } else if type(of: recognizer) === UISwipeGestureRecognizer.self {
            imageName = "swipe.png"
        } else {
            fatalError()
        }
        
        self.imageView.image = UIImage(named: imageName)
        self.imageView.center = centerPoint
        self.imageView.alpha = 1.0
    }
    
    
}
