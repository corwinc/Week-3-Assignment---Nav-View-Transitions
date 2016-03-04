//
//  MailboxViewController.swift
//  Week 3 Assignment
//
//  Created by Corwin Crownover on 2/17/16.
//  Copyright © 2016 Corwin Crownover. All rights reserved.
//

import UIKit

class MailboxViewController: UIViewController, UIScrollViewDelegate {

    // OUTLETS
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var messagesFeed: UIImageView!
    @IBOutlet weak var rescheduleView: UIImageView!
    @IBOutlet weak var listView: UIImageView!
    @IBOutlet weak var messageImageView: UIImageView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var laterIcon: UIImageView!
    @IBOutlet weak var listIcon: UIImageView!
    @IBOutlet weak var deleteIcon: UIImageView!
    @IBOutlet weak var archiveIcon: UIImageView!
    @IBOutlet weak var leftSwipeIconView: UIView!
    @IBOutlet weak var rightSwipeIconView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var menuView: UIImageView!
    
    
    
    // VARIABLES
    var initialCenter: CGPoint!
    var swipedLeftPosition: CGFloat!
    var swipedRightPosition: CGFloat!
    var containerViewInitialCenter: CGPoint!
    var containerViewSwipedRightPosition: CGFloat!
    var containerViewSwipedLeftPosition: CGFloat!
    var singleMessageSnoozed: Bool!

    
    
    
    // VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = messagesFeed.image!.size
        scrollView.delegate = self
        
        initialCenter = messageImageView.center
        swipedRightPosition = initialCenter.x + 320
        swipedLeftPosition = initialCenter.x - 320
        
        rescheduleView.alpha = 0
        listView.alpha = 0
        
        let edgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: "didEdgePan:")
        edgeGesture.edges = UIRectEdge.Left
        containerView.addGestureRecognizer(edgeGesture)
        
        containerViewSwipedRightPosition = containerView.center.x + 280
        containerViewSwipedLeftPosition = containerView.center.x
        
        singleMessageSnoozed = false


        // Do any additional setup after loading the view.
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        print("Shake it baby")
        if singleMessageSnoozed == true{
            self.messageImageView.frame.origin.x = 0
            self.messagesFeed.transform = CGAffineTransformMakeTranslation(0, 0)
        }
    }
    

    
    
    // FUNCTIONS
    @IBAction func didPan(sender: UIPanGestureRecognizer) {
        let location = sender.locationInView(view)
        let translation = sender.translationInView(view)
    
        
        // Pan Began
        if sender.state == .Began {
            NSLog("you started panning: \(initialCenter)")
    
        
        
        // Pan Changed
        } else if sender.state == .Changed {
            NSLog("translation: \(translation)")
            
            messageImageView.center = CGPoint(x: translation.x + initialCenter.x, y: initialCenter.y)
            
            
            // Alpha Conversions
            let laterIconConvertedAlpha = convertValue(translation.x, r1Min: 0, r1Max: -60, r2Min: 0, r2Max: 1)
            laterIcon.alpha = laterIconConvertedAlpha
            
            let archiveIconConvertedAlpha = convertValue(translation.x, r1Min: 0, r1Max: 60, r2Min: 0, r2Max: 1)
            archiveIcon.alpha = archiveIconConvertedAlpha
            
            
            // Icon Translation Conversions
            let leftSwipeIconViewConvertedTranslation = convertValue(translation.x, r1Min: -60, r1Max: -320, r2Min: 0, r2Max: -260)
            let rightSwipeIconViewConvertedTranslation = convertValue(translation.x, r1Min: 60, r1Max: 320, r2Min: 0, r2Max: 260)

            
            
            
            // Swipe left, grey rbg, snap back
            if translation.x <= 0 && translation.x > -60 {
                messageView.backgroundColor = UIColor.grayColor()
                laterIcon.hidden = false
                listIcon.hidden = true
                archiveIcon.hidden = true
                deleteIcon.hidden = true
            }
            
            // Swipe left, yellow rgb, swipe left
            else if translation.x < -60 && translation.x > -260 {
                messageView.backgroundColor = UIColor.yellowColor()
                laterIcon.hidden = false
                listIcon.hidden = true
                archiveIcon.hidden = true
                deleteIcon.hidden = true
                laterIcon.transform = CGAffineTransformMakeTranslation(leftSwipeIconViewConvertedTranslation, 0)
            }
            
            // Swipe left, brown rgb, swipe left
            else if translation.x <= -260 {
                messageView.backgroundColor = UIColor.brownColor()
                laterIcon.hidden = true
                listIcon.hidden = false
                archiveIcon.hidden = true
                deleteIcon.hidden = true
                listIcon.transform = CGAffineTransformMakeTranslation(leftSwipeIconViewConvertedTranslation, 0)

            }
            
            // Swipe right, gray rgb, snap back
            else if translation.x >= 0 && translation.x < 60 {
                messageView.backgroundColor = UIColor.grayColor()
                laterIcon.hidden = true
                listIcon.hidden = true
                archiveIcon.hidden = false
                deleteIcon.hidden = true

            }
            
            // Swipe right, green rgb, swipe right
            else if translation.x >= 60 && translation.x < 260 {
                messageView.backgroundColor = UIColor.greenColor()
                laterIcon.hidden = true
                listIcon.hidden = true
                archiveIcon.hidden = false
                deleteIcon.hidden = true
                archiveIcon.transform = CGAffineTransformMakeTranslation(rightSwipeIconViewConvertedTranslation, 0)
            }
            
            // Swipe right, red rgb, swipe right
            else if translation.x >= 260 {
                messageView.backgroundColor = UIColor.redColor()
                laterIcon.hidden = true
                listIcon.hidden = true
                archiveIcon.hidden = true
                deleteIcon.hidden = false
                deleteIcon.transform = CGAffineTransformMakeTranslation(rightSwipeIconViewConvertedTranslation, 0)
            }
    
        
        
        
        
        // Pan Ended
        } else if sender.state == .Ended {
            NSLog("you finished panning: \(location)")
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                // Swipe left, snap back
                if translation.x <= 0 && translation.x > -60 {
                    self.messageImageView.center.x = self.initialCenter.x
                }
                    
                    // Swipe left, finish swipe, show reschedule view
                else if translation.x < -60 && translation.x > -260 {
                    self.messageImageView.center.x = self.swipedLeftPosition
                    self.laterIcon.transform = CGAffineTransformMakeTranslation(-320, 0)
                    self.singleMessageSnoozed = true
                    
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        self.laterIcon.alpha = 0
                    })
                    
                    UIView.animateWithDuration(0.3, delay: 0.3, options: [], animations: { () -> Void in
                        self.rescheduleView.alpha = 1
                        }, completion: nil)
                }
                    
                    // Swipe left, finish swipe, show list view
                else if translation.x <= -260 {
                    self.messageImageView.center.x = self.swipedLeftPosition
                    self.listIcon.transform = CGAffineTransformMakeTranslation(-320, 0)
                    self.singleMessageSnoozed = true
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        self.listIcon.alpha = 0
                    })
                    
                    UIView.animateWithDuration(0.3, delay: 0.3, options: [], animations: { () -> Void in
                        self.listView.alpha = 1
                        }, completion: nil)
                }
                    
                    // Swipe right, snap back
                else if translation.x >= 0 && translation.x < 60 {
                    self.messageImageView.center.x = self.initialCenter.x
                }
                    
                    // Swipe right, finish swipe, hide message
                else if translation.x >= 60 && translation.x < 260 {
                    self.messageImageView.center.x = self.swipedRightPosition
                    self.archiveIcon.transform = CGAffineTransformMakeTranslation(320, 0)
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        self.archiveIcon.alpha = 0
                    })
                    
                    UIView.animateWithDuration(0.3, delay: 0.3, options: [], animations: { () -> Void in
                        self.messagesFeed.transform = CGAffineTransformMakeTranslation(0, -86)
                        }, completion: nil)
                }
                    
                    // Swipe right, finish swipe, hide message
                else if translation.x >= 260 {
                    self.messageImageView.center.x = self.swipedRightPosition
                    self.deleteIcon.transform = CGAffineTransformMakeTranslation(320, 0)
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        self.deleteIcon.alpha = 0
                    })
                    
                    UIView.animateWithDuration(0.3, delay: 0.3, options: [], animations: { () -> Void in
                        self.messagesFeed.transform = CGAffineTransformMakeTranslation(0, -86)
                        }, completion: nil)
                }
            })
        }
    }

    @IBAction func didTapRescheduleView(sender: UITapGestureRecognizer) {
        UIView.animateWithDuration(0.3) { () -> Void in
            self.rescheduleView.alpha = 0
            self.messagesFeed.transform = CGAffineTransformMakeTranslation(0, -86)
        }
    }
   
    
    @IBAction func didTapListView(sender: UITapGestureRecognizer) {
        UIView.animateWithDuration(0.3) { () -> Void in
            self.listView.alpha = 0
            self.messagesFeed.transform = CGAffineTransformMakeTranslation(0, -86)
        }
    }
    
    @IBAction func didEdgePan(sender: UIScreenEdgePanGestureRecognizer) {
        let translation = sender.translationInView(view)
        let velocity = sender.velocityInView(view)
        
        if sender.state == .Began {
            print("started panning")
            containerViewInitialCenter = containerView.center
            
        } else if sender.state == .Changed {
            print("did pan")
            containerView.center = CGPoint(x: translation.x + containerViewInitialCenter.x, y: containerViewInitialCenter.y)
            
        } else if sender.state == .Ended {
            print("finished panning")
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                if velocity.x > 0 {
                    self.containerView.center.x = self.containerViewSwipedRightPosition
                } else if velocity.x < 0 {
                    self.containerView.center.x = self.containerViewInitialCenter.x
                }
            })
        }
    }
    
    @IBAction func didTapMenuView(sender: UITapGestureRecognizer) {
        UIView.animateWithDuration(0.3) { () -> Void in
            self.containerView.center.x = self.containerViewSwipedLeftPosition
        }
    }

 
    
    
    
    
    
}
