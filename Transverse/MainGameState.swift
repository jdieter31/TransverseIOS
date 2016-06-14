//
//  MainGameState.swift
//  Transverse
//
//  Created by Justin on 5/21/16.
//  Copyright © 2016 Justin. All rights reserved.
//

import Foundation
import GLKit
import OpenGLES
import AVFoundation
import GameKit

class MainGameState : NSObject, UnityAdsDelegate, AdColonyDelegate, GKGameCenterControllerDelegate {
    
    //Schedule game events cause by touch events
    var scheduledLoss: Bool = false
    var scheduledRestart: Bool = false
    var scheduledEndGame: Bool = false
    var scheduledSecondChance: Bool = false
    var scheduledControlSwitch: Bool = false
    
    var currentRenderer: SolidRenderType?
    
    var lineRenderType: SolidRenderType?
    var greyRenderType: SolidRenderType?
    var titleRenderType: SolidRenderType?
    
    var highScore: Int = 0
    
    var leftPointer: UITouch?
    var rightPointer: UITouch?
    
    var score: Int = 0
    var scoreText: Text?
    
    var gameViewController: GameViewController
    
    var leftDown: Bool = false
    var rightDown: Bool = false
    
    var leftCircle: Circle?
    var rightCircle: Circle?
    
    var verticalTranslate: GLKMatrix4?
    
    var leftFingerTrail: FingerTrail?
    var rightFingerTrail: FingerTrail?
    
    var viewProjectionMatrix: GLKMatrix4? = nil
    var width: Float = 0
    var height: Float = 0

    var verticalChange: Float = 0
    
    var started: Bool = false
    
    var lastMoveCalc: Int64 = 0
    var speed: Float = 150
    
    var circlesInView: Bool = true
    var wallsInView: Bool = true
    
    var endCurrentGenerate: Float = 0
    
    var sectionsInView:[Section] = [Section]()
    
    var leftX: Float = 0
    var leftY: Float = 0
    var rightX: Float = 0
    var rightY: Float = 0
    var lastLeftX: Float = 0
    var lastLeftY: Float = 0
    var lastRightX: Float = 0
    var lastRightY: Float = 0
    var lastVerticalChange: Float = 0
    
    var hadSecondChance: Bool = false
    var inSecondChanceMenu: Bool = false
    
    var startingSecondChance: Bool = false
    var startingSecondChanceRectangle: RoundedRectangle?
    var secondChanceTapAndHoldText: Text?
    var toRetryText: Text?
    var leftSecondChanceCircle: Circle?
    var rightSecondChanceCircle: Circle?
    
    var secondChanceBox: RoundedRectangle?
    var endGameButton: RoundedRectangle?
    var endText: Text?
    var gameText: Text?
    var secondChanceButton: RoundedRectangle?
    var secondChanceText: Text?
    var watchVideoText: Text?
    var darkRedRenderType: SolidRenderType?
    
    var animatingColorChange: Bool = false
    var timeOfChange: Int64 = 0
    var previousRenderType: SolidRenderType?
    var previousBackgroundRenderType: SolidRenderType?
    var mixRenderType: SolidRenderType?
    var mixBackgroundRenderType: SolidRenderType?
    
    var defaultBackgroundRenderer: SolidRenderType?
    
    var currentSection: Section?
    
    var redRenderType: SolidRenderType?
    var inLossMenu: Bool = false
    var animatingLoss: Bool = false
    var timeOfLoss: Int64 = 0
    var loseScoreRectangle: RoundedRectangle?
    var loseScoreNumberText: Text?
    var loseScoreText: Text?
    var highScoreBox: RoundedRectangle?
    var highScoreText: Text?
    var retryRectangle: RoundedRectangle?
    var retryText: Text?
    
    var backgroundRectangle: Rectangle?
    
    var leftWall: Rectangle?
    var centerDivider: Rectangle?
    var rightWall: Rectangle?
    
    var backgroundRenderType: SolidRenderType?
    var scoreRectangleRenderType: SolidRenderType?
    
    var lastSpeedCalculation: Int64 = -1
    
    var titleRectangle: RoundedRectangle?
    var titleText: Text?
    var tapToStartRectangle: RoundedRectangle?
    var tapAndHoldText: Text?
    var toStartText: Text?
    
    var titleInView: Bool = true
    var titleAlpha: Float = 1
    var lastTitleCalculation: Int64 = -1
    
    var sectionToPass: Float = 0
    var nextSectionToPass: Float = 0
    
    var titleHighScoreBox: RoundedRectangle?
    var titleHighScoreText: Text?
    
    var leaderboardBox: RoundedRectangle?
    var leaderboardImage: Image?
    
    var achievementBox: RoundedRectangle?
    var achievementImage: Image?
    
    var switchControlSchemeBox: RoundedRectangle?
    var switchControlsText: Text?
    
    var rightDragRectangle: Rectangle?
    var leftDragRectangle: Rectangle?
    
    var leftArrowsLeftText: Text?
    var leftArrowsRightText: Text?
    var rightArrowsLeftText: Text?
    var rightArrowsRightText: Text?
    
    var outerDragRightCircle: Circle?
    var outerDragLeftCircle: Circle?
    
    var dragRightCircle: Circle?
    var dragLeftCircle: Circle?
    
    var dragInfoBox: Rectangle?
    var dragAndHoldOnBothSidesToStart: Text?
    
    var dragOffset: Float = 0
    
    var purchasedSecondChance: Bool = false
    
    var purchaseSecondChanceBox: RoundedRectangle?
    var buyNoAdsAndText: Text?
    var secondChancesText: Text?
    
    var loseAchievementBox: RoundedRectangle?
    var loseAchievementImage: Image?
    var loseLeaderboardBox: RoundedRectangle?
    var loseLeaderboardImage: Image?
    var loseShareBox: RoundedRectangle?
    var shareText: Text?
    
    var gamesPlayedSinceAd: Int = 0
    var initialAd: Bool = true
    let initialAds: Int = 2
    let gamesPerAd: Int = 5
    
    var dragControlScheme: Bool = false
    var showIndicator: Bool = false
    
    var fbCircle: Circle?
    var fbImage: Image?
    
    var twitterCircle: Circle?
    var twitterImage: Image?
    
    var fbRenderType: SolidRenderType?
    var twitterRenderType: SolidRenderType?
    
    var succesSoundAudio: AVAudioPlayer?
    var lossSoundAudio: AVAudioPlayer?
    
    init(viewController: GameViewController) {
        
        gameViewController = viewController
        
        super.init()
        
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "Main Menu")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
        
        AdColony.configureWithAppID("app09b63d44677f48e6ab", zoneIDs: ["vz6ae2ce67fcf642c1b1", "vz27856e528ba4462fbe"], delegate: self, logging: false)
        
        UnityAds.sharedInstance().delegate = self
        
        readHighScore()
        let defaults = NSUserDefaults.standardUserDefaults()
        dragControlScheme = defaults.boolForKey("dragControlScheme")
        showIndicator = defaults.boolForKey("showIndicator")
        
        greyRenderType = SolidRenderType()
        greyRenderType?.alpha = 1
        greyRenderType?.color = (0.4, 0.4, 0.4)
        
        lineRenderType = SolidRenderType()
        lineRenderType?.alpha = 1
        lineRenderType?.color = (0.322, 0.808, 1.0)
        verticalTranslate = GLKMatrix4Identity
        
        backgroundRenderType = SolidRenderType()
        defaultBackgroundRenderer = backgroundRenderType
        backgroundRenderType?.color = (0.95, 0.95, 0.95)
        scoreRectangleRenderType = SolidRenderType()
        scoreRectangleRenderType?.color = (1, 1, 1)
        redRenderType = SolidRenderType()
        redRenderType?.color = (1, 0.3, 0.3)
        redRenderType?.alpha = 1
        darkRedRenderType = SolidRenderType()
        darkRedRenderType?.color = (0.784,0.137, 0.263)
        darkRedRenderType?.alpha = 1
        titleRenderType = SolidRenderType()
        titleRenderType?.color = (0.204, 0.553, 0.686)
        titleRenderType?.alpha = 1
        fbRenderType = SolidRenderType()
        fbRenderType?.color = (0.231, 0.349, 0.596)
        fbRenderType?.alpha = 1
        twitterRenderType = SolidRenderType()
        twitterRenderType?.color = (0.333, 0.675, 0.933)
        twitterRenderType?.alpha = 1
        currentRenderer = greyRenderType
        
        let successSoundURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("sound_success", ofType: "caf")!)
        let lossSoundURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("loss", ofType: "caf")!)
        do {
            succesSoundAudio = try AVAudioPlayer(contentsOfURL: successSoundURL)
            lossSoundAudio = try AVAudioPlayer(contentsOfURL: lossSoundURL)
            succesSoundAudio?.prepareToPlay()
            lossSoundAudio?.prepareToPlay()
        } catch {
            print("Failed to load files")
        }
        
    }
    
    func readHighScore() {
        let defaults = NSUserDefaults.standardUserDefaults()
        highScore = defaults.integerForKey("highScore")
    }
    
    func handleTouchEvent(touch: UITouch) {
        let touchPoint: CGPoint = touch.locationInView(gameViewController.view)
        let x: Float = Float(touchPoint.x)
        let y: Float = Float(touchPoint.y)
        switch touch.phase {
        case UITouchPhase.Began:
            if (!started) {
                if(!dragControlScheme && !rightDown && rightCircle!.containsPoint(x, y: y)){
                    rightDown = true
                    rightPointer = touch
                    rightX = x
                    rightY = y
                    lastRightX = x
                    lastRightY = y
                } else if (!dragControlScheme && !leftDown && leftCircle!.containsPoint(x, y: y)) {
                    leftX = x
                    leftY = y
                    lastLeftX = x
                    lastLeftY = y
                    leftDown = true
                    leftPointer = touch
                } else if (leaderboardBox!.containsPoint(x, y: y)) {
                    let tracker = GAI.sharedInstance().defaultTracker
                    tracker.set(kGAIScreenName, value: "Leaderboard")
                    
                    let builder = GAIDictionaryBuilder.createScreenView()
                    tracker.send(builder.build() as [NSObject : AnyObject])
                    let gcVC: GKGameCenterViewController = GKGameCenterViewController()
                    gcVC.gameCenterDelegate = self
                    gcVC.viewState = GKGameCenterViewControllerState.Leaderboards
                    gcVC.leaderboardIdentifier = "top_score"
                    gcVC.modalPresentationStyle = UIModalPresentationStyle.CurrentContext
                    gameViewController.presentViewController(gcVC, animated: true, completion: nil)
                } else if (achievementBox!.containsPoint(x, y: y)) {
                    let tracker = GAI.sharedInstance().defaultTracker
                    tracker.set(kGAIScreenName, value: "Achievements")
                    
                    let builder = GAIDictionaryBuilder.createScreenView()
                    tracker.send(builder.build() as [NSObject : AnyObject])
                    let gcVC: GKGameCenterViewController = GKGameCenterViewController()
                    gcVC.gameCenterDelegate = self
                    gcVC.viewState = GKGameCenterViewControllerState.Achievements
                    gcVC.modalPresentationStyle = UIModalPresentationStyle.CurrentContext
                    gameViewController.presentViewController(gcVC, animated: true, completion: nil)
                } /* else if (!purchasedSecondChance && purchaseSecondChanceBox != nil && purchaseSecondChanceBox!.containsPoint(x, y: y)) {
                    //IAP TODO
                } */ else if (switchControlSchemeBox!.containsPoint(x, y: y)) {
                    scheduledControlSwitch = true
                } else if (fbCircle!.containsPoint(x, y: y)) {
                    UIApplication.sharedApplication().openURL(NSURL(string: "http://www.facebook.com/provectusstudios")!)
                } else if (twitterCircle!.containsPoint(x, y: y)) {
                    UIApplication.sharedApplication().openURL(NSURL(string: "http://twitter.com/provectustudios")!)
                } else if (dragControlScheme && x > 15 && x < width/2 - 7.5) {
                    leftX = x
                    leftY = height/2
                    lastLeftX = x
                    lastLeftY = height/2
                    leftDown = true
                    leftPointer = touch
                } else if (dragControlScheme && x > width/2 + 7.5 && x < width - 15) {
                    rightDown = true
                    rightPointer = touch
                    rightX = x
                    rightY = height/2
                    lastRightX = x
                    lastRightY = height/2
                }
                
                if (rightDown && leftDown) {
                    let tracker = GAI.sharedInstance().defaultTracker
                    tracker.set(kGAIScreenName, value: "Gameplay")
                    
                    let builder = GAIDictionaryBuilder.createScreenView()
                    tracker.send(builder.build() as [NSObject : AnyObject])
                    started = true
                    lastMoveCalc = Int64(NSDate().timeIntervalSince1970*1000)
                }
            }
            if (startingSecondChance) {
                if (!dragControlScheme && !rightDown && rightSecondChanceCircle!.containsPoint(x, y: y + verticalChange)) {
                    rightDown = true
                    rightPointer = touch
                    rightX = x
                    rightY = y
                    lastRightX = rightX
                    lastRightY = rightY
                } else if (!leftDown && leftSecondChanceCircle!.containsPoint(x, y: y + verticalChange)) {
                    leftX = x
                    leftY = y
                    lastLeftX = leftX
                    lastLeftY = leftY
                    leftDown = true
                    leftPointer = touch
                } else if (dragControlScheme && x > 15 && x < width/2 - 7.5) {
                    leftX = x
                    leftY = height/2
                    lastLeftX = x
                    lastLeftY = height/2
                    leftDown = true
                    leftPointer = touch
                } else if (dragControlScheme && x > width/2 + 7.5 && x < width - 15) {
                    rightDown = true
                    rightPointer = touch
                    rightX = x
                    rightY = height/2
                    lastRightX = x
                    lastRightY = height/2
                }
                if (rightDown && leftDown) {
                    leftFingerTrail = ColorFingerTrail(width: 7, length: height/2)
                    (leftFingerTrail as! ColorFingerTrail).color = (0.322, 0.808, 1)
                    rightFingerTrail = ColorFingerTrail(width: 7, length: height/2)
                    (rightFingerTrail as! ColorFingerTrail).color = (0.322, 0.808, 1)
                    startingSecondChance = false
                    scheduledLoss = false
                    started = true
                    lastMoveCalc = Int64(NSDate().timeIntervalSince1970*1000)
                }
            }
            if (inLossMenu) {
                if (retryRectangle!.containsPoint(x, y: y)) {
                    scheduledRestart = true
                } else if (loseShareBox!.containsPoint(x, y: y)) {
                    let tracker = GAI.sharedInstance().defaultTracker
                    
                    tracker.send(GAIDictionaryBuilder.createEventWithCategory("Social", action: "Share", label: nil, value: nil).build() as [NSObject : AnyObject])
                    
                    
                    UIGraphicsBeginImageContextWithOptions(gameViewController.view.bounds.size, true, 0)
                    gameViewController.view.drawViewHierarchyInRect(gameViewController.view.bounds, afterScreenUpdates: true)
                    let image = UIGraphicsGetImageFromCurrentImageContext()
                    UIGraphicsEndImageContext()
                    
                    let text = "I scored \(score) points on #Transverse! Can you beat it? http://itunes.apple.com/app/id1123840539"
                    
                    let activityVC = UIActivityViewController(activityItems: [image, text], applicationActivities: nil)
                    
                    gameViewController.presentViewController(activityVC, animated: true, completion: nil)
                } else if (loseAchievementBox!.containsPoint(x, y: y)) {
                    let tracker = GAI.sharedInstance().defaultTracker
                    tracker.set(kGAIScreenName, value: "Achievements")
                    
                    let builder = GAIDictionaryBuilder.createScreenView()
                    tracker.send(builder.build() as [NSObject : AnyObject])
                    
                    let gcVC: GKGameCenterViewController = GKGameCenterViewController()
                    gcVC.gameCenterDelegate = self
                    gcVC.viewState = GKGameCenterViewControllerState.Achievements
                    gcVC.modalPresentationStyle = UIModalPresentationStyle.CurrentContext
                    gameViewController.presentViewController(gcVC, animated: true, completion: nil)
                } else if (loseLeaderboardBox!.containsPoint(x, y: y)) {
                    let tracker = GAI.sharedInstance().defaultTracker
                    tracker.set(kGAIScreenName, value: "Leaderboard")
                    
                    let builder = GAIDictionaryBuilder.createScreenView()
                    tracker.send(builder.build() as [NSObject : AnyObject])
                    
                    let gcVC: GKGameCenterViewController = GKGameCenterViewController()
                    gcVC.gameCenterDelegate = self
                    gcVC.viewState = GKGameCenterViewControllerState.Leaderboards
                    gcVC.leaderboardIdentifier = "top_score"
                    gcVC.modalPresentationStyle = UIModalPresentationStyle.CurrentContext
                    gameViewController.presentViewController(gcVC, animated: true, completion: nil)
                }
            }
            if (inSecondChanceMenu) {
                if (endGameButton!.containsPoint(x, y: y)) {
                    inSecondChanceMenu = false
                    scheduledEndGame = true
                } else if (secondChanceButton!.containsPoint(x, y: y)) {
                    if (purchasedSecondChance) {
                        scheduledSecondChance = true
                    } else {
                        let rand = drand48()
                        if(rand > 0.5) {
                            if (UnityAds.sharedInstance().setZone("rewardedVideo") && UnityAds.sharedInstance().canShow()) {
                                UnityAds.sharedInstance().show()
                            }
                        } else {
                            AdColony.playVideoAdForZone("vz6ae2ce67fcf642c1b1", withDelegate: nil, withV4VCPrePopup: false, andV4VCPostPopup: false)
                        }
                    }
                }
            }
        case UITouchPhase.Ended, UITouchPhase.Cancelled:
            if (!started) {
                if (rightDown && touch == rightPointer) {
                    rightDown = false
                    rightPointer = nil
                }
                if (leftDown && touch == leftPointer) {
                    leftDown = false
                    leftPointer = nil
                }
            } else if (startingSecondChance) {
                if (rightDown && touch == rightPointer) {
                    rightDown = false
                    rightPointer = nil
                }
                if (leftDown && touch == leftPointer) {
                    leftDown = false
                    leftPointer = nil
                }
            } else if (!inLossMenu) {
                if (touch == leftPointer || touch == rightPointer) {
                    scheduledLoss = true
                }
            }
        case UITouchPhase.Moved:
            if (started) {
                if (touch == leftPointer) {
                    leftX = x
                    if (!dragControlScheme) {
                        leftY = y
                    }
                }
                if (touch == rightPointer) {
                    rightX = x
                    if (!dragControlScheme) {
                        rightY = y
                    }
                }
            }
        default:
            break
        }
    }
    
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func updateHighScore(score: Int) {
        highScore = score
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(highScore, forKey: "highScore")
        defaults.synchronize()
    }
    
    func handleLoss() {
        if (!hadSecondChance) {
            createSecondChanceMenu()
        } else {
            finishGame()
        }
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            self.lossSoundAudio?.currentTime = 0
            self.lossSoundAudio?.play()
        })
    }
    
    func createSecondChance() {
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "Gameplay")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
        
        if let currentSection = currentSection {
            currentSection.empty()
            
            if (height/2 + verticalChange <= sectionToPass) {
                sectionsInView[sectionsInView.indexOf({$0 === currentSection})! + 1].empty()
            }
        }
        scheduledSecondChance = false
        inSecondChanceMenu = false
        hadSecondChance = true
        startingSecondChance = true
        rightDown = false
        leftDown = false
        
        leftSecondChanceCircle = Circle()
        leftSecondChanceCircle?.precision = 360
        leftSecondChanceCircle?.radius = height/10
        rightSecondChanceCircle = Circle()
        rightSecondChanceCircle?.precision = 360
        rightSecondChanceCircle?.radius = height/10
        leftSecondChanceCircle?.centerX = width/4
        leftSecondChanceCircle?.centerY = height/2 + verticalChange
        leftSecondChanceCircle?.centerZ = 0
        rightSecondChanceCircle?.centerX = 3*width/4
        rightSecondChanceCircle?.centerY = height/2 + verticalChange
        rightSecondChanceCircle?.centerZ = 0
        leftSecondChanceCircle?.refresh()
        rightSecondChanceCircle?.refresh()
        
        dragLeftCircle = Circle()
        dragLeftCircle?.precision = 60
        dragLeftCircle?.radius = height/60
        dragRightCircle = Circle()
        dragRightCircle?.precision = 60
        dragRightCircle?.radius = height/60
        dragLeftCircle?.centerX = width/4
        dragLeftCircle?.centerY = height/2
        dragLeftCircle?.centerZ = 0
        dragRightCircle?.centerX = 3 * width / 4
        dragRightCircle?.centerY = height/2
        dragRightCircle?.centerZ = 0
        dragLeftCircle?.refresh()
        dragRightCircle?.refresh()
        
        if (!dragControlScheme) {
            startingSecondChanceRectangle = RoundedRectangle()
            startingSecondChanceRectangle?.width = 2*width/3
            startingSecondChanceRectangle?.center = (width/2, height/2 + verticalChange, 0)
            startingSecondChanceRectangle?.height = height/4
            startingSecondChanceRectangle?.cornerRadius = 10
            startingSecondChanceRectangle?.precision = 60
            startingSecondChanceRectangle?.refresh()
            secondChanceTapAndHoldText = Text()
            secondChanceTapAndHoldText?.setFont("FFF Forward")
            secondChanceTapAndHoldText?.text = "Tap and hold"
            secondChanceTapAndHoldText?.textSize = ((height/4)/3)
            secondChanceTapAndHoldText?.originX = width/2 - secondChanceTapAndHoldText!.getWidth()/2
            secondChanceTapAndHoldText?.originY = height/2 - (height/4)/3 + verticalChange
            secondChanceTapAndHoldText?.originZ = 0
            secondChanceTapAndHoldText?.refresh()
            toRetryText = Text()
            toRetryText?.setFont("FFF Forward")
            toRetryText?.text = "to continue!"
            toRetryText?.textSize = ((height/4)/3)
            toRetryText?.originX = width/2 - toRetryText!.getWidth()/2
            toRetryText?.originY = height/2 + verticalChange
            toRetryText?.originZ = 0
            toRetryText?.refresh()
        } else {
            outerDragLeftCircle = Circle()
            outerDragLeftCircle?.precision  = 360
            outerDragLeftCircle?.radius = height/15
            outerDragRightCircle = Circle()
            outerDragRightCircle?.precision = 360
            outerDragRightCircle?.radius = height/15
            outerDragLeftCircle?.centerX = width/4
            outerDragLeftCircle?.centerY = height/2 + verticalChange
            outerDragLeftCircle?.centerZ = 0
            outerDragRightCircle?.centerX = 3*width/4
            outerDragRightCircle?.centerY = height/2 + verticalChange
            outerDragRightCircle?.centerZ = 0
            outerDragLeftCircle?.refresh()
            outerDragRightCircle?.refresh()
            rightDragRectangle = Rectangle()
            rightDragRectangle?.origin = (width/2 + 7.5, height/2 + verticalChange, 0)
            rightDragRectangle?.height = height / 8
            rightDragRectangle?.width = width/2 - 22.5
            rightDragRectangle?.refresh()
            leftDragRectangle = Rectangle()
            leftDragRectangle?.origin = (15, height/2 + verticalChange, 0)
            leftDragRectangle?.height = height / 8
            leftDragRectangle?.width = width/2 - 22.5
            leftDragRectangle?.refresh()
            
            leftArrowsLeftText = Text()
            leftArrowsLeftText?.text = "<<<"
            leftArrowsLeftText?.setFont("FFF Forward")
            leftArrowsLeftText?.textSize = height/12
            leftArrowsLeftText?.originX = 15 + (width - 45)/8 - leftArrowsLeftText!.getWidth()/2
            leftArrowsLeftText?.originY = 9 * height / 16 - height/24 + verticalChange
            leftArrowsLeftText?.originZ = 0
            leftArrowsLeftText?.refresh()
            
            leftArrowsRightText = Text()
            leftArrowsRightText?.text = ">>>"
            leftArrowsRightText?.setFont("FFF Forward")
            leftArrowsRightText?.textSize = height/12
            leftArrowsRightText?.originX = 15 + 3*(width - 45)/8 - leftArrowsRightText!.getWidth()/2
            leftArrowsRightText?.originY = 9 * height / 16 - height/24 + verticalChange
            leftArrowsRightText?.refresh()
            
            rightArrowsLeftText = Text()
            rightArrowsLeftText?.text = "<<<"
            rightArrowsLeftText?.setFont("FFF Forward")
            rightArrowsLeftText?.textSize = height/12
            rightArrowsLeftText?.originX = 30 + 5*(width - 45)/8 - rightArrowsLeftText!.getWidth()/2
            rightArrowsLeftText?.originY = 9 * height / 16 - height/24 + verticalChange
            rightArrowsLeftText?.originZ = 0
            rightArrowsLeftText?.refresh()
            
            rightArrowsRightText = Text()
            rightArrowsRightText?.text = ">>>"
            rightArrowsRightText?.setFont("FFF Forward")
            rightArrowsRightText?.textSize = height/12
            rightArrowsRightText?.originX = 30 + 7*(width - 45)/8 - rightArrowsRightText!.getWidth()/2
            rightArrowsRightText?.originY = 9 * height / 16 - height/24 + verticalChange
            rightArrowsRightText?.refresh()
            
            dragInfoBox = Rectangle()
            dragInfoBox?.origin = (15, height/2 - height/12 - height/11 + verticalChange, 0)
            dragInfoBox?.width = width - 30
            dragInfoBox?.height = height/12
            dragInfoBox?.refresh()
            
            dragAndHoldOnBothSidesToStart = Text()
            dragAndHoldOnBothSidesToStart?.text = "Drag and hold on both sides to continue!"
            dragAndHoldOnBothSidesToStart?.setFont("FFF Forward")
            dragAndHoldOnBothSidesToStart?.textSize = height/16
            dragAndHoldOnBothSidesToStart?.originX = width/2 - dragAndHoldOnBothSidesToStart!.getWidth()/2
            dragAndHoldOnBothSidesToStart?.originY = height/2 - height/11 - height/24 - height/32 + verticalChange
            dragAndHoldOnBothSidesToStart?.originZ = 0
            dragAndHoldOnBothSidesToStart?.refresh()
            
            dragOffset = verticalChange
        }
    }
    
    func createSecondChanceMenu() {
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "Second Chance Menu")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
        
        hadSecondChance = true
        inSecondChanceMenu = true
        
        secondChanceBox = RoundedRectangle()
        secondChanceBox?.width = 2*width/3
        secondChanceBox?.center = (width/2, height/2, 0)
        secondChanceBox?.height = (height/3)
        secondChanceBox?.cornerRadius = 10
        secondChanceBox?.precision = 60
        secondChanceBox?.refresh()
        
        endGameButton = RoundedRectangle()
        endGameButton?.width = (2 * width / 9)
        endGameButton?.center = (width/2 - width/3 + width/9 + width/36, height/2, 0)
        endGameButton?.height = (height/4)
        endGameButton?.cornerRadius = 10
        endGameButton?.precision = 60
        endGameButton?.refresh()
        
        endText = Text()
        endText?.setFont("FFF Forward")
        endText?.text = "End"
        endText?.textSize = (height/10)
        endText?.originX = width/2 - width/3 + width/9 + width/36 - endText!.getWidth()/2
        endText?.originY = height/2 - height/10
        endText?.originZ = 0
        endText?.refresh()
        
        gameText = Text()
        gameText?.setFont("FFF Forward")
        gameText?.text = "Game"
        gameText?.textSize = (height/10)
        gameText?.originX = width/2 - width/3 + width/9 + width/36 - gameText!.getWidth()/2
        gameText?.originY = height/2
        gameText?.originZ = 0
        gameText?.refresh()
        
        secondChanceButton = RoundedRectangle()
        secondChanceButton?.width = (13 * width / 36)
        secondChanceButton?.center = (width/2 - width/3 + width/36 + 2*width/9 + width/36 + 13 * width / 72, height/2, 0)
        secondChanceButton?.height = (height/4)
        secondChanceButton?.cornerRadius = 10
        secondChanceButton?.precision = 60
        secondChanceButton?.refresh()
        
        secondChanceText = Text()
        secondChanceText?.setFont("FFF Forward")
        secondChanceText?.text = "Second Chance"
        secondChanceText?.textSize = (height/12)
        if (purchasedSecondChance) {
            secondChanceText?.originX = width/2 - width/3 + width/36 + 2*width/9 + width/36 + 13 * width / 72 - secondChanceText!.getWidth()/2
            secondChanceText?.originY = height/2 - height/24
            secondChanceText?.originZ = 0
        } else {
            secondChanceText?.originX = width / 2 - width / 3 + width / 36 + 2 * width / 9 + width / 36 + 13 * width / 72 - secondChanceText!.getWidth() / 2
            secondChanceText?.originY = height / 2 - height / 12
            secondChanceText?.originZ = 0
        }
        secondChanceText?.refresh()
        if (!purchasedSecondChance) {
            watchVideoText = Text()
            watchVideoText?.setFont("FFF Forward")
            watchVideoText?.text = "Watch Video"
            watchVideoText?.textSize = height / 12
            watchVideoText?.originX = width / 2 - width / 3 + width / 36 + 2 * width / 9 + width / 36 + 13 * width / 72 - watchVideoText!.getWidth() / 2
            watchVideoText?.originY = height / 2
            watchVideoText?.originZ = 0
            watchVideoText?.refresh()
        }
    }
    
    func unlockAchievements() {
        if (score == 0) {
            let achievement = GKAchievement(identifier: "zeropoint")
            achievement.percentComplete = 100
            achievement.showsCompletionBanner = true
            GKAchievement.reportAchievements([achievement], withCompletionHandler: { (error: NSError?) -> Void in
                if error != nil {
                    print(error!.localizedDescription)
                } else {
                    print("Game center achievement submitted")
                }
            })
        }
        if (score >= 10) {
            let achievement = GKAchievement(identifier: "tenpoint")
            achievement.percentComplete = 100
            achievement.showsCompletionBanner = true
            GKAchievement.reportAchievements([achievement], withCompletionHandler: { (error: NSError?) -> Void in
                if error != nil {
                    print(error!.localizedDescription)
                } else {
                    print("Game center achievement submitted")
                }
            })
        }
        if (score >= 20) {
            let achievement = GKAchievement(identifier: "twentypoint")
            achievement.percentComplete = 100
            achievement.showsCompletionBanner = true
            GKAchievement.reportAchievements([achievement], withCompletionHandler: { (error: NSError?) -> Void in
                if error != nil {
                    print(error!.localizedDescription)
                } else {
                    print("Game center achievement submitted")
                }
            })
        }
        if (score >= 30) {
            let achievement = GKAchievement(identifier: "thirtypoint")
            achievement.percentComplete = 100
            achievement.showsCompletionBanner = true
            GKAchievement.reportAchievements([achievement], withCompletionHandler: { (error: NSError?) -> Void in
                if error != nil {
                    print(error!.localizedDescription)
                } else {
                    print("Game center achievement submitted")
                }
            })
        }
        if (score >= 40) {
            let achievement = GKAchievement(identifier: "fourtypoint")
            achievement.percentComplete = 100
            achievement.showsCompletionBanner = true
            GKAchievement.reportAchievements([achievement], withCompletionHandler: { (error: NSError?) -> Void in
                if error != nil {
                    print(error!.localizedDescription)
                } else {
                    print("Game center achievement submitted")
                }
            })
        }
        if (score >= 50) {
            let achievement = GKAchievement(identifier: "fiftypoint")
            achievement.percentComplete = 100
            achievement.showsCompletionBanner = true
            GKAchievement.reportAchievements([achievement], withCompletionHandler: { (error: NSError?) -> Void in
                if error != nil {
                    print(error!.localizedDescription)
                } else {
                    print("Game center achievement submitted")
                }
            })
        }
        if (score >= 100) {
            let achievement = GKAchievement(identifier: "hundredpoint")
            achievement.percentComplete = 100
            achievement.showsCompletionBanner = true
            GKAchievement.reportAchievements([achievement], withCompletionHandler: { (error: NSError?) -> Void in
                if error != nil {
                    print(error!.localizedDescription)
                } else {
                    print("Game center achievement submitted")
                }
            })
        }
    }

    func gcReportScore() {
        let leaderboardID = "top_score"
        let sScore = GKScore(leaderboardIdentifier: leaderboardID)
        sScore.value = Int64(score)
        
        GKScore.reportScores([sScore], withCompletionHandler: { (error: NSError?) -> Void in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                print("Game center score submitted")
            }
        })
    }
    
    func finishGame() {
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "Loss Menu")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
        tracker.send(GAIDictionaryBuilder.createEventWithCategory("Game", action: "Finished Game", label: nil, value: score).build() as [NSObject : AnyObject])
        
        gcReportScore()
        
        if (score > highScore) {
            updateHighScore(score)
        }
        unlockAchievements()
        
        inLossMenu = true
        animatingLoss = true
        scheduledEndGame = false
        timeOfLoss = Int64(NSDate().timeIntervalSince1970*1000)
        loseScoreRectangle = RoundedRectangle()
        loseScoreRectangle?.center = (width/4, height/2, 0)
        loseScoreRectangle?.width = width / 3
        loseScoreRectangle?.height = 2 * height / 3
        loseScoreRectangle?.cornerRadius = 10
        loseScoreRectangle?.precision = 60
        loseScoreRectangle?.refresh()
        loseScoreNumberText = Text()
        loseScoreNumberText?.setFont("FFF Forward")
        loseScoreNumberText?.textSize = height / 3
        loseScoreNumberText?.text = "\(score)"
        loseScoreNumberText?.originX = width / 4 - loseScoreNumberText!.getWidth() / 2
        loseScoreNumberText?.originY = height / 2 - 2 * height / 9
        loseScoreNumberText?.originZ = 0
        loseScoreNumberText?.refresh()
        loseScoreText = Text()
        loseScoreText?.setFont("FFF Forward")
        loseScoreText?.text = "Points"
        loseScoreText?.textSize = ((2*height/3)/5)
        loseScoreText?.originX = width/4 - loseScoreText!.getWidth()/2
        loseScoreText?.originY = height/2 + height / 8
        loseScoreText?.originZ = 0
        loseScoreText?.refresh()
        highScoreBox = RoundedRectangle()
        highScoreBox?.center = (17*width/24, 4*height/15, 0)
        highScoreBox?.cornerRadius = 10
        highScoreBox?.height = height/5
        highScoreBox?.width = (3*width/7)
        highScoreBox?.precision = 60
        highScoreBox?.refresh()
        highScoreText = Text()
        highScoreText?.setFont("FFF Forward")
        highScoreText?.text = "Best: \(highScore)"
        highScoreText?.textSize = ((2*height/3)/5)
        highScoreText?.originX = 17*width/24 - highScoreText!.getWidth()/2
        highScoreText?.originY = 4*height/15 - ((height/3)/5)
        highScoreText?.originZ = 0
        highScoreText?.refresh()
        retryRectangle = RoundedRectangle()
        retryRectangle?.center = (17*width/24, 11*height/15, 0)
        retryRectangle?.cornerRadius = 10
        retryRectangle?.height = height/5
        retryRectangle?.width = 3*width/7
        retryRectangle?.precision = 60
        retryRectangle?.refresh()
        retryText = Text()
        retryText?.setFont("FFF Forward")
        retryText?.text = "Restart"
        retryText?.textSize = ((2*height/3)/5)
        retryText?.originX = 17*width/24 - highScoreText!.getWidth()/2
        retryText?.originY = 11*height/15 - ((height/3)/5)
        retryText?.originZ = 0
        retryText?.refresh()
        
        loseShareBox = RoundedRectangle()
        loseShareBox?.height = height/5
        loseShareBox?.width = width/4
        loseShareBox?.center = (17*width/24, height/2, 0)
        loseShareBox?.precision = 60
        loseShareBox?.cornerRadius = 10
        loseShareBox?.refresh()
        shareText = Text()
        shareText?.setFont("FFF Forward")
        shareText?.text = "Share"
        shareText?.textSize = ((2*height/3)/5)
        shareText?.originX = 17*width/24 - shareText!.getWidth()/2
        shareText?.originY = height/2 - (height/3)/5
        shareText?.originZ = 0
        shareText?.refresh()
        
        loseLeaderboardBox = RoundedRectangle()
        loseLeaderboardBox?.height = height/5
        loseLeaderboardBox?.width = height/5
        loseLeaderboardBox?.center = (17*width/24 - width/8 - width/50 - height/10, height/2, 0)
        loseLeaderboardBox?.precision = 60
        loseLeaderboardBox?.cornerRadius = 10
        loseLeaderboardBox?.refresh()
        
        let leaderboardImageHeight: Float = 5*(height/5)/8
        let leaderboardImageWidth: Float = leaderboardImageHeight * (196.0/210.0)
        let leaderboardCenterX: Float = 17*width/24 - width/8 - width/50 - height/10
        loseLeaderboardImage = Image()
        loseLeaderboardImage?.textureHandle = Textures.leaderboardTexture
        loseLeaderboardImage?.vertices = [
            leaderboardCenterX - leaderboardImageWidth/2, height/2 - leaderboardImageHeight/2, 0,
            leaderboardCenterX - leaderboardImageWidth/2, height/2 + leaderboardImageHeight/2, 0,
            leaderboardCenterX + leaderboardImageWidth/2, height/2 + leaderboardImageHeight/2, 0,
            leaderboardCenterX + leaderboardImageWidth/2, height/2 - leaderboardImageHeight/2, 0
        ]
        loseLeaderboardImage?.drawOrder = [
            0,1,2,0,2,3
        ]
        loseLeaderboardImage?.uvCoordinates = [
            0,0,
            0,1,
            1,1,
            1,0
        ]
        
        loseAchievementBox = RoundedRectangle()
        loseAchievementBox?.height = height/5
        loseAchievementBox?.width = height/5
        loseAchievementBox?.center = (17*width/24 + width/8 + width/50 + height/10, height/2, 0)
        loseAchievementBox?.precision = 60
        loseAchievementBox?.cornerRadius = 10
        loseAchievementBox?.refresh()
        
        let achievementImageWidth: Float = 5*(height/5)/8
        let achievementImageHeight: Float = achievementImageWidth * (215.0/256.0)
        let achievementCenterX: Float = 17*width/24 + width/8 + width/50 + height/10
        loseAchievementImage = Image()
        loseAchievementImage?.textureHandle = Textures.trophyTexture
        loseAchievementImage?.vertices = [
            achievementCenterX - achievementImageWidth/2, height/2 - achievementImageHeight/2, 0,
            achievementCenterX - achievementImageWidth/2, height/2 + achievementImageHeight/2, 0,
            achievementCenterX + achievementImageWidth/2, height/2 + achievementImageHeight/2, 0,
            achievementCenterX + achievementImageWidth/2, height/2 - achievementImageHeight/2, 0
        ]
        loseAchievementImage?.drawOrder = [
            0,1,2,0,2,3
        ]
        loseAchievementImage?.uvCoordinates = [
            0,0,
            0,1,
            1,1,
            1,0
        ]
    }
    
    func handleSectionTouch() {
        //Read all position variables into stable variable so they don't change during computation
        let leftXStable: Float = leftX
        let leftYStable: Float = leftY
        let rightXStable: Float = rightX
        let rightYStable: Float = rightY
        
        var leftPast: Bool = false
        
        leftFingerTrail!.addTopPoint(leftXStable, y: leftYStable + verticalChange)
        if (wallsInView) {
            if (leftWall!.lineSegmentCrosses(lastLeftX, startY: lastLeftY + lastVerticalChange, endX: leftXStable, endY: leftYStable + verticalChange)
                || rightWall!.lineSegmentCrosses(lastLeftX, startY: lastLeftY + lastVerticalChange, endX: leftXStable, endY: leftYStable + verticalChange)
                || centerDivider!.lineSegmentCrosses(lastLeftX, startY: lastLeftY + lastVerticalChange, endX: leftXStable, endY: leftYStable + verticalChange)) {
                if (!scheduledLoss && !inSecondChanceMenu) {
                    handleLoss()
                    return
                }
            }
        }
        for section in sectionsInView {
            if (section.handleTouchMove(lastLeftX, endX: leftXStable, startY: lastLeftY + lastVerticalChange, endY: leftYStable + verticalChange, rightSide: false)) {
                if (!scheduledLoss && !inSecondChanceMenu) {
                    handleLoss()
                    return
                }
            }
        }
        if (leftYStable + verticalChange <= sectionToPass) {
            leftPast = true
        }
        
        
        var rightPast: Bool = false
        rightFingerTrail!.addTopPoint(rightXStable, y: rightYStable + verticalChange)
        if (wallsInView) {
            if (leftWall!.lineSegmentCrosses(lastRightX, startY: lastRightY + lastVerticalChange, endX: rightXStable, endY: rightYStable + verticalChange)
                || rightWall!.lineSegmentCrosses(lastRightX, startY: lastRightY + lastVerticalChange, endX: rightXStable, endY: rightYStable + verticalChange)
                || centerDivider!.lineSegmentCrosses(lastRightX, startY: lastRightY + lastVerticalChange, endX: rightXStable, endY: rightYStable + verticalChange)) {
                if (!scheduledLoss && !inSecondChanceMenu) {
                    handleLoss()
                    return
                }
            }
        }
        for section in sectionsInView {
            if(section.handleTouchMove(lastRightX, endX: rightXStable, startY: lastRightY + lastVerticalChange, endY: rightYStable + verticalChange, rightSide: true)) {
                if (!scheduledLoss && !inSecondChanceMenu) {
                    handleLoss()
                    return
                }
            }
        }
        if (rightYStable + verticalChange <= sectionToPass) {
            rightPast = true
        }
        lastLeftX = leftXStable
        lastLeftY = leftYStable
        lastRightX = rightXStable
        lastRightY = rightYStable
        lastVerticalChange = verticalChange
        if (leftPast && rightPast) {
            score += 1
            refreshScore()
            if let currentSection = currentSection {
                self.currentSection = sectionsInView[sectionsInView.indexOf({$0 === currentSection})! + 1]
            } else {
                self.currentSection = sectionsInView[0]
            }
            sectionToPass = nextSectionToPass
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                self.succesSoundAudio?.currentTime = 0
                self.succesSoundAudio?.play()
            })
        }
    }
    
    func calculateMove() {
        let time = Int64(NSDate().timeIntervalSince1970*1000)
        let dt = time - lastMoveCalc
        if (dt < 0 || dt > 200) {
            lastMoveCalc = time
            return
        }
        let newVerticalChange = (Float(dt)/1000.0)*speed
        verticalChange -= newVerticalChange
        if (dragControlScheme) {
            rightY = min(height/2 - verticalChange + dragOffset,  17 * height / 24)
            leftY = rightY
        }
        verticalTranslate = GLKMatrix4Translate(verticalTranslate!, 0, newVerticalChange, 0)
        for (i, _) in sectionsInView.enumerate().reverse() {
            let section = sectionsInView[i]
            if (section.startY - section.length > verticalChange + height) {
                sectionsInView.removeAtIndex(i)
            }
        }
        if (wallsInView) {
            if (verticalChange < -height) {
                wallsInView = false
                leftWall = nil
                rightWall = nil
                centerDivider = nil
            }
        }
        if (circlesInView) {
            if (verticalChange < -height/2 - height/10) {
                leftCircle = nil
                rightCircle = nil
                circlesInView = false
            }
        }
        lastMoveCalc = time
    }
    
    func adjustSpeed() {
        speed = 90 * log(2 + Float(score)) + 100
    }
    
    func getSection() -> Section {
        let section: DoubleSection = DoubleSection()
        
        //Logistic function of score
        let difficulty: Float = 1.0/(1.0 + pow(Float(M_E), -(Float(score) - 20.0)/10.0))
        section.difficulty = difficulty
        
        return section
    }
    
    func generateSections() {
        if (endCurrentGenerate >= verticalChange - 10) {
            let section = getSection()
            section.generate(0, width: width, startY: endCurrentGenerate)
            section.refresh()
            endCurrentGenerate = endCurrentGenerate - section.length
            nextSectionToPass = endCurrentGenerate
            sectionsInView.append(section)
        }
    }
    
    func triggerRestart() {
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "Main Menu")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
        hadSecondChance = false
        inSecondChanceMenu = false
        scheduledRestart = false
        scheduledLoss = false
        inLossMenu = false
        started = false
        score = 0
        leftDown = false
        rightDown = false
        titleInView = true
        circlesInView = true
        wallsInView = true
        currentSection = nil
        lastVerticalChange = 0
        verticalChange = 0
        titleAlpha = 1
        lastTitleCalculation = -1
        sectionToPass = 0
        nextSectionToPass = 0
        endCurrentGenerate = 0
        dragOffset = 0
        currentRenderer = greyRenderType
        backgroundRenderType = defaultBackgroundRenderer
        verticalTranslate = GLKMatrix4Identity
        sectionsInView = [Section]()
        refreshDimensions(width, height: height, viewProjectionMatrix: viewProjectionMatrix!, force: true)
        
        
        if (!purchasedSecondChance) {
            gamesPlayedSinceAd += 1
            if (initialAd && gamesPlayedSinceAd >= initialAds) {
                gamesPlayedSinceAd = gamesPerAd
                initialAd = false
            }
            if (gamesPlayedSinceAd >= gamesPerAd) {
                let rand = drand48()
                if (rand > 0.5) {
                    AdColony.playVideoAdForZone("vz27856e528ba4462fbe", withDelegate: nil)
                } else {
                    if (UnityAds.sharedInstance().setZone("video") && UnityAds.sharedInstance().canShow()) {
                        UnityAds.sharedInstance().show()
                    }
                }
                gamesPlayedSinceAd = 0
            }
        }
        
    }
    
    func onDrawFrame() {
        if (scheduledRestart) {
            triggerRestart()
        }
        if (scheduledEndGame) {
            finishGame()
        }
        if (scheduledSecondChance) {
            createSecondChance()
        }
        if (scheduledControlSwitch) {
            if (showIndicator && dragControlScheme) {
                showIndicator = true
                dragControlScheme = false
            } else if (showIndicator) {
                showIndicator = false
            } else {
                dragControlScheme = true
                showIndicator = true
            }
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setBool(showIndicator, forKey: "showIndicator")
            defaults.setBool(dragControlScheme, forKey: "dragControlScheme")
            defaults.synchronize()
            refreshDimensions(width, height: height, viewProjectionMatrix: viewProjectionMatrix!, force: true)
            scheduledControlSwitch = false
        }
        if (animatingColorChange) {
            var dt = Int64(NSDate().timeIntervalSince1970*1000) - timeOfChange
            if (dt > 300) {
                animatingColorChange = false
                dt = 300
            }
            var red = ((300.0 - Float(dt))/300.0)*previousRenderType!.color.red + (Float(dt)/300.0)*currentRenderer!.color.red
            var blue = ((300.0 - Float(dt))/300.0)*previousRenderType!.color.blue + (Float(dt)/300.0)*currentRenderer!.color.blue
            var green = ((300.0 - Float(dt))/300.0)*previousRenderType!.color.green + (Float(dt)/300.0)*currentRenderer!.color.green
            mixRenderType!.color = (red, green, blue)
            if (currentRenderer!.dual) {
                let red2 = ((300.0 - Float(dt))/300.0)*previousRenderType!.color2!.red + (Float(dt)/300.0)*currentRenderer!.color2!.red
                let blue2 = ((300.0 - Float(dt))/300.0)*previousRenderType!.color2!.blue + (Float(dt)/300.0)*currentRenderer!.color2!.blue
                let green2 = ((300.0 - Float(dt))/300.0)*previousRenderType!.color2!.green + (Float(dt)/300.0)*currentRenderer!.color2!.green
                mixRenderType!.color2 = (red2, green2, blue2)
            }
            
            
            red = ((300.0 - Float(dt))/300.0)*previousBackgroundRenderType!.color.red + (Float(dt)/300.0)*backgroundRenderType!.color.red
            blue = ((300.0 - Float(dt))/300.0)*previousBackgroundRenderType!.color.blue + (Float(dt)/300.0)*backgroundRenderType!.color.blue
            green = ((300.0 - Float(dt))/300.0)*previousBackgroundRenderType!.color.green + (Float(dt)/300.0)*backgroundRenderType!.color.green
            mixBackgroundRenderType!.color = (red, green, blue)
            if (backgroundRenderType!.dual){
                let red2 = ((300.0 - Float(dt))/300.0)*previousBackgroundRenderType!.color2!.red + (Float(dt)/300.0)*backgroundRenderType!.color2!.red
                let blue2 = ((300.0 - Float(dt))/300.0)*previousBackgroundRenderType!.color2!.blue + (Float(dt)/300.0)*backgroundRenderType!.color2!.blue
                let green2 = ((300.0 - Float(dt))/300.0)*previousBackgroundRenderType!.color2!.green + (Float(dt)/300.0)*backgroundRenderType!.color2!.green
                mixBackgroundRenderType!.color2 = (red2, green2, blue2)
            }
            
            mixBackgroundRenderType!.matrix = viewProjectionMatrix
            mixBackgroundRenderType!.alpha = 1
            mixBackgroundRenderType!.drawShape(backgroundRectangle!)
        } else {
            backgroundRenderType!.matrix = viewProjectionMatrix
            backgroundRenderType!.alpha = 1
            backgroundRenderType!.drawShape(backgroundRectangle!)
        }
        scoreRectangleRenderType!.matrix = viewProjectionMatrix
        scoreRectangleRenderType!.alpha = 1
        titleRenderType!.matrix = viewProjectionMatrix
        if (!started) {
            greyRenderType!.matrix = viewProjectionMatrix
            lineRenderType!.matrix = viewProjectionMatrix
            titleRenderType!.alpha = 1
            fbRenderType!.matrix = viewProjectionMatrix
            twitterRenderType!.matrix = viewProjectionMatrix
            fbRenderType!.alpha = 1
            twitterRenderType!.alpha = 1
            greyRenderType!.drawShape(leftWall!)
            greyRenderType!.drawShape(centerDivider!)
            greyRenderType!.drawShape(rightWall!)
            titleRenderType!.drawShape(titleRectangle!)
            backgroundRenderType!.drawText(titleText!)
            
            fbRenderType!.drawShape(fbCircle!)
            backgroundRenderType!.drawImage(fbImage!)
            
            twitterRenderType!.drawShape(twitterCircle!)
            backgroundRenderType!.drawImage(twitterImage!)
            
            if (!dragControlScheme) {
                titleRenderType!.drawShape(tapToStartRectangle!)
                backgroundRenderType!.drawText(tapAndHoldText!)
                backgroundRenderType!.drawText(toStartText!)
            } else {
                titleRenderType!.drawShape(leftDragRectangle!)
                titleRenderType!.drawShape(rightDragRectangle!)
                titleRenderType!.drawShape(dragInfoBox!)
                backgroundRenderType!.drawText(dragAndHoldOnBothSidesToStart!)
                greyRenderType!.drawShape(outerDragLeftCircle!)
                greyRenderType!.drawShape(outerDragRightCircle!)
                backgroundRenderType!.drawText(leftArrowsLeftText!)
                backgroundRenderType!.drawText(leftArrowsRightText!)
                backgroundRenderType!.drawText(rightArrowsLeftText!)
                backgroundRenderType!.drawText(rightArrowsRightText!)
            }
                
            titleRenderType!.drawShape(titleHighScoreBox!)
            backgroundRenderType!.drawText(titleHighScoreText!)
            
            titleRenderType!.drawShape(leaderboardBox!)
            backgroundRenderType!.drawImage(leaderboardImage!)
            
            titleRenderType!.drawShape(achievementBox!)
            backgroundRenderType!.drawImage(achievementImage!)
            
            titleRenderType!.drawShape(switchControlSchemeBox!)
            backgroundRenderType!.drawText(switchControlsText!)
            
            /* if (!purchasedSecondChance) {
                titleRenderType!.drawShape(purchaseSecondChanceBox!)
                backgroundRenderType!.drawText(buyNoAdsAndText!)
                backgroundRenderType!.drawText(secondChancesText!)
            } */
            
            if (dragControlScheme) {
                if (leftDown) {
                    lineRenderType!.drawShape(dragLeftCircle!)
                } else {
                    backgroundRenderType!.drawShape(dragLeftCircle!)
                }
                if (rightDown) {
                    lineRenderType!.drawShape(dragRightCircle!)
                } else {
                    backgroundRenderType!.drawShape(dragRightCircle!)
                }
            } else {
                if (leftDown) {
                    lineRenderType!.drawShape(leftCircle!)
                } else {
                    greyRenderType!.drawShape(leftCircle!)
                }
                if (rightDown) {
                    lineRenderType!.drawShape(rightCircle!)
                } else {
                    greyRenderType!.drawShape(rightCircle!)
                }
            }
            
            if (!dragControlScheme && showIndicator) {
                lineRenderType!.drawShape(dragLeftCircle!)
                lineRenderType!.drawShape(dragRightCircle!)
            }
        } else if (inLossMenu || inSecondChanceMenu) {
            let verticalTranslateMVP: GLKMatrix4 = GLKMatrix4Multiply(viewProjectionMatrix!, verticalTranslate!)
            currentRenderer!.matrix = verticalTranslateMVP
            currentRenderer!.alpha = 1
            if (wallsInView) {
                currentRenderer!.drawShape(leftWall!)
                currentRenderer!.drawShape(centerDivider!)
                currentRenderer!.drawShape(rightWall!)
            }
            for section in sectionsInView {
                section.draw(verticalTranslateMVP, renderType: currentRenderer!)
            }
            redRenderType!.matrix = viewProjectionMatrix
            redRenderType!.alpha = 1
            defaultBackgroundRenderer!.alpha = 1
            defaultBackgroundRenderer!.matrix = viewProjectionMatrix
            darkRedRenderType!.matrix = viewProjectionMatrix
            darkRedRenderType!.alpha = 1
            if (inLossMenu) {
                if (animatingLoss) {
                    let dt = Int64(NSDate().timeIntervalSince1970*1000) - timeOfLoss
                    let alpha = Float(dt)*(1.0/1000.0)
                    if (alpha > 1) {
                        animatingLoss = false
                    }
                    redRenderType!.alpha = alpha
                    redRenderType!.drawShape(loseScoreRectangle!)
                    redRenderType!.drawShape(highScoreBox!)
                    redRenderType!.drawShape(retryRectangle!)
                    redRenderType!.drawShape(loseShareBox!)
                    redRenderType!.drawShape(loseAchievementBox!)
                    redRenderType!.drawShape(loseLeaderboardBox!)
                    defaultBackgroundRenderer!.drawText(loseScoreNumberText!)
                    defaultBackgroundRenderer!.drawText(loseScoreText!)
                    defaultBackgroundRenderer!.drawText(highScoreText!)
                    defaultBackgroundRenderer!.drawText(retryText!)
                    defaultBackgroundRenderer!.drawText(shareText!)
                    defaultBackgroundRenderer!.drawImage(loseAchievementImage!)
                    defaultBackgroundRenderer!.drawImage(loseLeaderboardImage!)
                } else {
                    redRenderType!.drawShape(loseScoreRectangle!)
                    redRenderType!.drawShape(highScoreBox!)
                    redRenderType!.drawShape(retryRectangle!)
                    redRenderType!.drawShape(loseShareBox!)
                    redRenderType!.drawShape(loseLeaderboardBox!)
                    redRenderType!.drawShape(loseAchievementBox!)
                    defaultBackgroundRenderer!.drawText(loseScoreNumberText!)
                    defaultBackgroundRenderer!.drawText(loseScoreText!)
                    defaultBackgroundRenderer!.drawText(highScoreText!)
                    defaultBackgroundRenderer!.drawText(retryText!)
                    defaultBackgroundRenderer!.drawText(shareText!)
                    defaultBackgroundRenderer!.drawImage(loseLeaderboardImage!)
                    defaultBackgroundRenderer!.drawImage(loseAchievementImage!)
                }
            }
            
            if (inSecondChanceMenu) {
                redRenderType!.drawShape(secondChanceBox!)
                darkRedRenderType!.drawShape(endGameButton!)
                darkRedRenderType!.drawShape(secondChanceButton!)
                defaultBackgroundRenderer!.drawText(gameText!)
                defaultBackgroundRenderer!.drawText(endText!)
                defaultBackgroundRenderer!.drawText(secondChanceText!)
                if (!purchasedSecondChance) {
                    defaultBackgroundRenderer!.drawText(watchVideoText!)
                }
                greyRenderType!.matrix = viewProjectionMatrix
                defaultBackgroundRenderer!.matrix = viewProjectionMatrix
                if (score < 10) {
                    greyRenderType!.drawText(scoreText!)
                } else {
                    defaultBackgroundRenderer!.drawText(scoreText!)
                }
            }
        } else if (startingSecondChance) {
            let verticalTranslateMVP: GLKMatrix4 = GLKMatrix4Multiply(viewProjectionMatrix!, verticalTranslate!)
            greyRenderType!.alpha = 1
            currentRenderer!.alpha = 1
            titleRenderType!.alpha = 1
            titleRenderType!.matrix = verticalTranslateMVP
            greyRenderType!.matrix = verticalTranslateMVP
            currentRenderer!.matrix = verticalTranslateMVP
            defaultBackgroundRenderer!.matrix = verticalTranslateMVP
            lineRenderType!.matrix = verticalTranslateMVP
            if (wallsInView) {
                currentRenderer!.drawShape(leftWall!)
                currentRenderer!.drawShape(centerDivider!)
                currentRenderer!.drawShape(rightWall!)
            }
            for section in sectionsInView {
                section.draw(verticalTranslateMVP, renderType: currentRenderer!)
            }
            if (!dragControlScheme) {
                titleRenderType!.drawShape(startingSecondChanceRectangle!)
                defaultBackgroundRenderer!.drawText(secondChanceTapAndHoldText!)
                defaultBackgroundRenderer!.drawText(toRetryText!)
                if (leftDown) {
                    lineRenderType!.drawShape(leftSecondChanceCircle!)
                } else {
                    greyRenderType!.drawShape(leftSecondChanceCircle!)
                }
                if (rightDown) {
                    lineRenderType!.drawShape(rightSecondChanceCircle!)
                } else {
                    greyRenderType!.drawShape(rightSecondChanceCircle!)
                }
            } else {
                titleRenderType!.drawShape(leftDragRectangle!)
                titleRenderType!.drawShape(rightDragRectangle!)
                titleRenderType!.drawShape(dragInfoBox!)
                defaultBackgroundRenderer!.drawText(dragAndHoldOnBothSidesToStart!)
                greyRenderType!.drawShape(outerDragLeftCircle!)
                greyRenderType!.drawShape(outerDragRightCircle!)
                defaultBackgroundRenderer!.drawText(leftArrowsLeftText!)
                defaultBackgroundRenderer!.drawText(leftArrowsRightText!)
                defaultBackgroundRenderer!.drawText(rightArrowsLeftText!)
                defaultBackgroundRenderer!.drawText(rightArrowsRightText!)
                
                lineRenderType!.matrix = viewProjectionMatrix
                defaultBackgroundRenderer!.matrix = viewProjectionMatrix
                if (leftDown) {
                    lineRenderType!.drawShape(dragLeftCircle!)
                } else {
                    defaultBackgroundRenderer!.drawShape(dragLeftCircle!)
                }
                if (rightDown) {
                    lineRenderType!.drawShape(dragRightCircle!)
                } else {
                    defaultBackgroundRenderer!.drawShape(dragRightCircle!)
                }
            }
            
            lineRenderType!.matrix = viewProjectionMatrix
            if (!dragControlScheme && showIndicator) {
                lineRenderType!.drawShape(dragLeftCircle!)
                lineRenderType!.drawShape(dragRightCircle!)
            }
            
            greyRenderType?.matrix = viewProjectionMatrix
            defaultBackgroundRenderer?.matrix = viewProjectionMatrix
            if (score < 10) {
                greyRenderType!.drawText(scoreText!)
            } else {
                defaultBackgroundRenderer!.drawText(scoreText!)
            }
        } else {
            if (scheduledLoss) {
                handleLoss()
            }
            calculateMove()
            adjustSpeed()
            generateSections()
            handleSectionTouch()
            let verticalTranslateMVP: GLKMatrix4 = GLKMatrix4Multiply(viewProjectionMatrix!, verticalTranslate!)
            for section in sectionsInView {
                if (animatingColorChange) {
                    section.draw(verticalTranslateMVP, renderType: mixRenderType!)
                } else {
                    section.draw(verticalTranslateMVP, renderType: currentRenderer!)
                }
            }
            lineRenderType!.matrix = verticalTranslateMVP
            if (wallsInView) {
                if (animatingColorChange) {
                    mixRenderType!.matrix = verticalTranslateMVP
                    mixRenderType!.drawShape(leftWall!)
                    mixRenderType!.drawShape(centerDivider!)
                    mixRenderType!.drawShape(rightWall!)
                } else {
                    currentRenderer!.matrix = verticalTranslateMVP
                    currentRenderer!.drawShape(leftWall!)
                    currentRenderer!.drawShape(centerDivider!)
                    currentRenderer!.drawShape(rightWall!)
                }
            }
            if (titleInView) {
                let time = Int64(NSDate().timeIntervalSince1970*1000)
                let dt = time - lastTitleCalculation
                var sane: Bool = true
                if (lastTitleCalculation == -1 || dt <= 0) {
                    lastTitleCalculation = time
                    sane = false
                    defaultBackgroundRenderer!.alpha = titleAlpha
                    titleRenderType!.alpha = titleAlpha
                    fbRenderType!.alpha = titleAlpha
                    twitterRenderType!.alpha = titleAlpha
                    titleRenderType!.drawShape(titleRectangle!)
                    defaultBackgroundRenderer!.drawText(titleText!)
                    fbRenderType!.drawShape(fbCircle!)
                    defaultBackgroundRenderer!.drawImage(fbImage!)
                    twitterRenderType!.drawShape(twitterCircle!)
                    defaultBackgroundRenderer!.drawImage(twitterImage!)
                    if (!dragControlScheme) {
                        titleRenderType!.drawShape(tapToStartRectangle!)
                        defaultBackgroundRenderer!.drawText(tapAndHoldText!)
                        defaultBackgroundRenderer!.drawText(toStartText!)
                    } else {
                        titleRenderType!.drawShape(leftDragRectangle!)
                        titleRenderType!.drawShape(rightDragRectangle!)
                        titleRenderType!.drawShape(dragInfoBox!)
                        defaultBackgroundRenderer!.drawText(dragAndHoldOnBothSidesToStart!)
                        greyRenderType!.drawShape(outerDragLeftCircle!)
                        greyRenderType!.drawShape(outerDragRightCircle!)
                        defaultBackgroundRenderer!.drawText(leftArrowsLeftText!)
                        defaultBackgroundRenderer!.drawText(leftArrowsRightText!)
                        defaultBackgroundRenderer!.drawText(rightArrowsLeftText!)
                        defaultBackgroundRenderer!.drawText(rightArrowsRightText!)
                    }
                    titleRenderType!.drawShape(titleHighScoreBox!)
                    defaultBackgroundRenderer!.drawText(titleHighScoreText!)
                    titleRenderType!.drawShape(leaderboardBox!)
                    titleRenderType!.drawShape(achievementBox!)
                    titleRenderType!.drawShape(switchControlSchemeBox!)
                    defaultBackgroundRenderer!.drawText(switchControlsText!)
                    defaultBackgroundRenderer!.drawImage(achievementImage!)
                    defaultBackgroundRenderer!.drawImage(leaderboardImage!)
                    
                    /* if (!purchasedSecondChance) {
                        titleRenderType!.drawShape(purchaseSecondChanceBox!)
                        defaultBackgroundRenderer!.drawText(buyNoAdsAndText!)
                        defaultBackgroundRenderer!.drawText(secondChancesText!)
                    } */
                }
                if (sane) {
                    let alphaChange = Float(dt) * (1.0/500.0)
                    titleAlpha -= alphaChange
                    if (titleAlpha < 0) {
                        titleInView = false
                        titleAlpha = 0
                    }
                    lastTitleCalculation = time
                    titleRenderType!.alpha = titleAlpha
                    defaultBackgroundRenderer!.alpha = titleAlpha
                    fbRenderType!.alpha = titleAlpha
                    twitterRenderType!.alpha = titleAlpha
                    
                    titleRenderType!.drawShape(titleRectangle!)
                    fbRenderType!.drawShape(fbCircle!)
                    twitterRenderType!.drawShape(twitterCircle!)
                    titleRenderType!.drawShape(titleHighScoreBox!)
                    titleRenderType!.drawShape(leaderboardBox!)
                    titleRenderType!.drawShape(achievementBox!)

                    if (!dragControlScheme) {
                        titleRenderType!.drawShape(tapToStartRectangle!)
                        defaultBackgroundRenderer!.drawText(tapAndHoldText!)
                        defaultBackgroundRenderer!.drawText(toStartText!)
                    } else {
                        titleRenderType!.drawShape(leftDragRectangle!)
                        titleRenderType!.drawShape(rightDragRectangle!)
                        titleRenderType!.drawShape(dragInfoBox!)
                        defaultBackgroundRenderer!.drawText(dragAndHoldOnBothSidesToStart!)
                        greyRenderType!.drawShape(outerDragLeftCircle!)
                        greyRenderType!.drawShape(outerDragRightCircle!)
                        defaultBackgroundRenderer!.drawText(leftArrowsLeftText!)
                        defaultBackgroundRenderer!.drawText(leftArrowsRightText!)
                        defaultBackgroundRenderer!.drawText(rightArrowsLeftText!)
                        defaultBackgroundRenderer!.drawText(rightArrowsRightText!)
                    }
                    
                    titleRenderType!.drawShape(switchControlSchemeBox!)
                    defaultBackgroundRenderer!.drawText(switchControlsText!)
                    
                    defaultBackgroundRenderer!.drawText(titleText!)
                    defaultBackgroundRenderer!.drawText(titleHighScoreText!)
                    defaultBackgroundRenderer!.drawImage(achievementImage!)
                    defaultBackgroundRenderer!.drawImage(leaderboardImage!)
                    defaultBackgroundRenderer!.drawImage(fbImage!)
                    defaultBackgroundRenderer!.drawImage(twitterImage!)
                    
                    /* if (!purchasedSecondChance) {
                        titleRenderType!.drawShape(purchaseSecondChanceBox!)
                        defaultBackgroundRenderer!.drawText(buyNoAdsAndText!)
                        defaultBackgroundRenderer!.drawText(secondChancesText!)
                    } */
                    
                    defaultBackgroundRenderer!.alpha = 1
                    if (!titleInView) {
                        titleRectangle = nil
                        titleText = nil
                        tapToStartRectangle = nil
                        tapAndHoldText = nil
                        toStartText = nil
                    }
                }
            }
            if (circlesInView && !dragControlScheme) {
                lineRenderType!.drawShape(leftCircle!)
                lineRenderType!.drawShape(rightCircle!)
            }
            
            if (showIndicator) {
                var indicatorY : Float
                if (dragControlScheme) {
                    indicatorY = min(height/2 - verticalChange + dragOffset, 17*height/24)
                } else {
                    indicatorY = height/2
                }
                dragLeftCircle!.centerX = leftX
                dragLeftCircle!.centerY = indicatorY
                dragLeftCircle!.centerZ = 0
                dragLeftCircle!.refresh()
                dragRightCircle!.centerX  = rightX
                dragRightCircle!.centerY = indicatorY
                dragRightCircle!.centerZ = 0
                dragRightCircle!.refresh()
                lineRenderType!.matrix = viewProjectionMatrix
                lineRenderType!.drawShape(dragLeftCircle!)
                lineRenderType!.drawShape(dragRightCircle!)
            }
            
            leftFingerTrail!.draw(verticalTranslateMVP)
            rightFingerTrail!.draw(verticalTranslateMVP)
            greyRenderType!.matrix = viewProjectionMatrix
            defaultBackgroundRenderer!.matrix = viewProjectionMatrix
            if (score < 10) {
                greyRenderType!.drawText(scoreText!)
            } else {
                defaultBackgroundRenderer!.drawText(scoreText!)
            }
        }
    }
    
    func refreshDimensions(width: Float, height: Float, viewProjectionMatrix: GLKMatrix4, force: Bool) {
        if (!force && self.width == width && self.height == height) {
            return
        }
        self.width = width
        self.height = height
        self.viewProjectionMatrix = viewProjectionMatrix
        
        leftFingerTrail = ColorFingerTrail(width: 7, length: height/2)
        (leftFingerTrail as! ColorFingerTrail).color = (0.322, 0.808, 1)
        rightFingerTrail = ColorFingerTrail(width: 7, length: height/2)
        (rightFingerTrail as! ColorFingerTrail).color = (0.322, 0.808, 1)
        
        if (circlesInView && !dragControlScheme) {
            leftCircle = Circle()
            leftCircle?.precision = 360
            leftCircle?.radius = height/10
            rightCircle = Circle()
            rightCircle?.precision = 360
            rightCircle?.radius = height/10
            leftCircle?.centerX = width/4
            leftCircle?.centerY = height/2
            leftCircle?.centerZ = 0
            rightCircle?.centerX = 3*width/4
            rightCircle?.centerY = height/2
            rightCircle?.centerZ = 0
            leftCircle?.refresh()
            rightCircle?.refresh()
        }
        if (wallsInView) {
            leftWall = Rectangle()
            leftWall?.origin = (0, 0, 0)
            leftWall?.width = 15
            leftWall?.height = height
            leftWall?.refresh()
            centerDivider = Rectangle()
            centerDivider?.origin = (width/2 - 7.5, 0, 0)
            centerDivider?.width = 15
            centerDivider?.height = height
            centerDivider?.refresh()
            rightWall = Rectangle()
            rightWall?.origin = (width - 15, 0, 0)
            rightWall?.width = 15
            rightWall?.height = height
            rightWall?.refresh()
        }
        if (titleInView) {
            titleRectangle = RoundedRectangle()
            let titleRectangleWidth = 2*width/3
            titleRectangle?.width = titleRectangleWidth
            let titleRectangleY = height/5
            let titleRectangleHeight = height/5
            titleRectangle?.center = (width/2, titleRectangleY, 0)
            titleRectangle?.height = titleRectangleHeight
            titleRectangle?.cornerRadius = 10
            titleRectangle?.precision = 60
            titleRectangle?.refresh()
            titleText = Text()
            titleText?.setFont("FFF Forward")
            titleText?.text = "Transverse"
            titleText?.textSize = titleRectangleHeight - 10
            titleText?.originX = width/2 - titleText!.getWidth()/2
            titleText?.originY = titleRectangleY - (titleRectangleHeight - 10)/2
            titleText?.originZ = 0
            titleText?.refresh()
            
            fbCircle = Circle()
            fbCircle?.centerX = width/2 + width/3 + width/20
            fbCircle?.centerY = height/5
            fbCircle?.centerZ = 0
            fbCircle?.radius = width/30
            fbCircle?.precision = 360
            fbCircle?.refresh()
            
            let fbImageWidth: Float = width/25
            let fbImageHeight: Float = width/25
            fbImage = Image()
            fbImage?.textureHandle = Textures.fbTexture
            fbImage?.vertices = [
                width/2 + width/3 + width/20 - fbImageWidth/2, height/5 - fbImageHeight/2, 0,
                width/2 + width/3 + width/20 - fbImageWidth/2, height/5 + fbImageHeight/2, 0,
                width/2 + width/3 + width/20 + fbImageWidth/2, height/5 + fbImageHeight/2, 0,
                width/2 + width/3 + width/20 + fbImageWidth/2, height/5 - fbImageHeight/2, 0
            ]
            fbImage?.drawOrder = [
                0,1,2,0,2,3
            ]
            fbImage?.uvCoordinates = [
                0,0,
                0,1,
                1,1,
                1,0
            ]
            
            twitterCircle = Circle()
            twitterCircle?.centerX = width/2 - width/3 - width/20
            twitterCircle?.centerY = height/5
            twitterCircle?.centerZ = 0
            twitterCircle?.radius = width/30
            twitterCircle?.precision = 360
            twitterCircle?.refresh()
            
            let twitterImageWidth: Float = width/20
            let twitterImageHeight: Float = width/20
            twitterImage = Image()
            twitterImage?.textureHandle = Textures.twitterTexture
            twitterImage?.vertices = [
                width/2 - width/3 - width/20 - twitterImageWidth/2, height/5 - twitterImageHeight/2, 0,
                width/2 - width/3 - width/20 - twitterImageWidth/2, height/5 + twitterImageHeight/2, 0,
                width/2 - width/3 - width/20 + twitterImageWidth/2, height/5 + twitterImageHeight/2, 0,
                width/2 - width/3 - width/20 + twitterImageWidth/2, height/5 - twitterImageHeight/2, 0
            ]
            twitterImage?.drawOrder = [
                0,1,2,0,2,3
            ]
            twitterImage?.uvCoordinates = [
                0,0,
                0,1,
                1,1,
                1,0
            ]
            
            dragLeftCircle = Circle()
            dragLeftCircle?.precision = 60
            dragLeftCircle?.radius = height/60
            dragRightCircle = Circle()
            dragRightCircle?.precision = 60
            dragRightCircle?.radius = height/60
            dragLeftCircle?.centerX = width/4
            dragLeftCircle?.centerY = height/2
            dragLeftCircle?.centerZ = 0
            dragRightCircle?.centerX = 3 * width / 4
            dragRightCircle?.centerY = height/2
            dragRightCircle?.centerZ = 0
            dragLeftCircle?.refresh()
            dragRightCircle?.refresh()
            
            if (!dragControlScheme) {
                tapToStartRectangle = RoundedRectangle()
                tapToStartRectangle?.width = titleRectangleWidth
                tapToStartRectangle?.center = (width/2, height/2, 0)
                tapToStartRectangle?.height = (height/4)
                tapToStartRectangle?.cornerRadius = 10
                tapToStartRectangle?.precision = 60
                tapToStartRectangle?.refresh()
                tapAndHoldText = Text()
                tapAndHoldText?.setFont("FFF Forward")
                tapAndHoldText?.text =  "Tap and hold"
                tapAndHoldText?.textSize = (height/4)/3
                tapAndHoldText?.originX = width/2 - tapAndHoldText!.getWidth()/2
                tapAndHoldText?.originY = height/2 - (height/4)/3
                tapAndHoldText?.originZ = 0
                tapAndHoldText?.refresh()
                toStartText = Text()
                toStartText?.setFont("FFF Forward")
                toStartText?.text = "to start!"
                toStartText?.textSize = (height/4)/3
                toStartText?.originX = width/2 - toStartText!.getWidth()/2
                toStartText?.originY = height/2
                toStartText?.originZ = 0
                toStartText?.refresh()
            } else {
                outerDragLeftCircle = Circle()
                outerDragLeftCircle?.precision  = 360
                outerDragLeftCircle?.radius = height/15
                outerDragRightCircle = Circle()
                outerDragRightCircle?.precision = 360
                outerDragRightCircle?.radius = height/15
                outerDragLeftCircle?.centerX = width/4
                outerDragLeftCircle?.centerY = height/2
                outerDragLeftCircle?.centerZ = 0
                outerDragRightCircle?.centerX = 3*width/4
                outerDragRightCircle?.centerY = height/2
                outerDragRightCircle?.centerZ = 0
                outerDragLeftCircle?.refresh()
                outerDragRightCircle?.refresh()
                rightDragRectangle = Rectangle()
                rightDragRectangle?.origin = (width/2 + 7.5, height/2, 0)
                rightDragRectangle?.height = height / 8
                rightDragRectangle?.width = width/2 - 22.5
                rightDragRectangle?.refresh()
                leftDragRectangle = Rectangle()
                leftDragRectangle?.origin = (15, height/2, 0)
                leftDragRectangle?.height = height / 8
                leftDragRectangle?.width = width/2 - 22.5
                leftDragRectangle?.refresh()
                
                leftArrowsLeftText = Text()
                leftArrowsLeftText?.text = "<<<"
                leftArrowsLeftText?.setFont("FFF Forward")
                leftArrowsLeftText?.textSize = height/12
                leftArrowsLeftText?.originX = 15 + (width - 45)/8 - leftArrowsLeftText!.getWidth()/2
                leftArrowsLeftText?.originY = 9 * height / 16 - height/24
                leftArrowsLeftText?.originZ = 0
                leftArrowsLeftText?.refresh()
                
                leftArrowsRightText = Text()
                leftArrowsRightText?.text = ">>>"
                leftArrowsRightText?.setFont("FFF Forward")
                leftArrowsRightText?.textSize = height/12
                leftArrowsRightText?.originX = 15 + 3*(width - 45)/8 - leftArrowsRightText!.getWidth()/2
                leftArrowsRightText?.originY = 9 * height / 16 - height/24
                leftArrowsRightText?.refresh()
                
                rightArrowsLeftText = Text()
                rightArrowsLeftText?.text = "<<<"
                rightArrowsLeftText?.setFont("FFF Forward")
                rightArrowsLeftText?.textSize = height/12
                rightArrowsLeftText?.originX = 30 + 5*(width - 45)/8 - rightArrowsLeftText!.getWidth()/2
                rightArrowsLeftText?.originY = 9 * height / 16 - height/24
                rightArrowsLeftText?.originZ = 0
                rightArrowsLeftText?.refresh()
                
                rightArrowsRightText = Text()
                rightArrowsRightText?.text = ">>>"
                rightArrowsRightText?.setFont("FFF Forward")
                rightArrowsRightText?.textSize = height/12
                rightArrowsRightText?.originX = 30 + 7*(width - 45)/8 - rightArrowsRightText!.getWidth()/2
                rightArrowsRightText?.originY = 9 * height / 16 - height/24
                rightArrowsRightText?.refresh()
                
                dragInfoBox = Rectangle()
                dragInfoBox?.origin = (15, height/2 - height/12 - height/11, 0)
                dragInfoBox?.width = width - 30
                dragInfoBox?.height = height/12
                dragInfoBox?.refresh()
                
                dragAndHoldOnBothSidesToStart = Text()
                dragAndHoldOnBothSidesToStart?.text = "Drag and hold on both sides to start!"
                dragAndHoldOnBothSidesToStart?.setFont("FFF Forward")
                dragAndHoldOnBothSidesToStart?.textSize = height/16
                dragAndHoldOnBothSidesToStart?.originX = width/2 - dragAndHoldOnBothSidesToStart!.getWidth()/2
                dragAndHoldOnBothSidesToStart?.originY = height/2 - height/11 - height/24 - height/32
                dragAndHoldOnBothSidesToStart?.originZ = 0
                dragAndHoldOnBothSidesToStart?.refresh()
            }
            
            let bottomButtonHeight = height/6
            
            titleHighScoreBox = RoundedRectangle()
            titleHighScoreBox?.height = bottomButtonHeight
            titleHighScoreBox?.center = (width/2, 3*height/4, 0)
            titleHighScoreBox?.cornerRadius = 10
            titleHighScoreBox?.width = 11*width/32
            titleHighScoreBox?.precision = 60
            titleHighScoreBox?.refresh()
            
            titleHighScoreText = Text()
            titleHighScoreText?.setFont("FFF Forward")
            titleHighScoreText?.text = "Best: \(highScore)"
            titleHighScoreText?.textSize = (2*height/3)/5
            titleHighScoreText?.originX = width/2 - titleHighScoreText!.getWidth()/2
            titleHighScoreText?.originY = 3*height/4 - (2*height/3)/10
            titleHighScoreText?.originZ = 0
            titleHighScoreText?.refresh()
            
            switchControlSchemeBox = RoundedRectangle()
            switchControlSchemeBox?.height = height/10
            switchControlSchemeBox?.center = (width/2, 11 * height / 12, 0)
            switchControlSchemeBox?.cornerRadius = 10
            switchControlSchemeBox?.width = 11 * width / 32
            switchControlSchemeBox?.precision = 60
            switchControlSchemeBox?.refresh()
            
            switchControlsText = Text()
            switchControlsText?.setFont("FFF Forward")
            switchControlsText?.text = "Switch Controls"
            switchControlsText?.textSize = height/16
            switchControlsText?.originX = width/2 - switchControlsText!.getWidth()/2
            switchControlsText?.originY = 11*height/12 - height/32
            switchControlsText?.originZ = 0
            switchControlsText?.refresh()
            
            let leaderboardCenterX = width/2 - 11 * width / 64 - width / 36 - bottomButtonHeight/2
            
            leaderboardBox = RoundedRectangle()
            leaderboardBox?.height = bottomButtonHeight
            leaderboardBox?.width = bottomButtonHeight
            leaderboardBox?.cornerRadius = 10
            leaderboardBox?.precision = 60
            leaderboardBox?.center = (leaderboardCenterX, 4*height/5, 0)
            leaderboardBox?.refresh()
            
            let leaderboardImageHeight = 5*bottomButtonHeight/8
            let leaderboardImageWidth = leaderboardImageHeight * (196.0/210.0)
            
            leaderboardImage = Image()
            leaderboardImage?.textureHandle = Textures.leaderboardTexture
            leaderboardImage?.vertices = [
                leaderboardCenterX - leaderboardImageWidth/2, 4*height/5 - leaderboardImageHeight/2, 0,
                leaderboardCenterX - leaderboardImageWidth/2, 4*height/5 + leaderboardImageHeight/2, 0,
                leaderboardCenterX + leaderboardImageWidth/2, 4*height/5 + leaderboardImageHeight/2, 0,
                leaderboardCenterX + leaderboardImageWidth/2, 4*height/5 - leaderboardImageHeight/2, 0
            ]
            leaderboardImage?.drawOrder = [
                0,1,2,0,2,3
            ]
            leaderboardImage?.uvCoordinates = [
                0,0,
                0,1,
                1,1,
                1,0
            ]
            
            var achievementCenterX: Float
            
            /* if (!purchasedSecondChance) {
                achievementCenterX = width/2 - 11 * width / 64 - width / 36 - bottomButtonHeight - width/36 - bottomButtonHeight/2
                purchaseSecondChanceBox = RoundedRectangle()
                purchaseSecondChanceBox?.height = bottomButtonHeight
                purchaseSecondChanceBox?.width = width/4
                purchaseSecondChanceBox?.center = (width/2 + 11 * width/64 + width/36 + width/8, 4*height/5, 0)
                purchaseSecondChanceBox?.precision = 60
                purchaseSecondChanceBox?.cornerRadius = 10
                purchaseSecondChanceBox?.refresh()
                
                buyNoAdsAndText = Text()
                buyNoAdsAndText?.setFont("FFF Forward")
                buyNoAdsAndText?.text = "No Ads And"
                buyNoAdsAndText?.textSize = height/16
                buyNoAdsAndText?.originX = width/2 + 11 * width/64 + width/36 + width/8 - buyNoAdsAndText!.getWidth()/2
                buyNoAdsAndText?.originY = 4*height/5 - height/16
                buyNoAdsAndText?.originZ = 0
                buyNoAdsAndText?.refresh()
                
                secondChancesText = Text()
                secondChancesText?.setFont("FFF Forward")
                secondChancesText?.text = "Second Chances"
                secondChancesText?.textSize = height/16
                secondChancesText?.originX = width/2 + 11 * width/64 + width/36 + width/8 - secondChancesText!.getWidth()/2
                secondChancesText?.originY = 4*height/5
                secondChancesText?.originZ = 0
                secondChancesText?.refresh()
            } else { */
                achievementCenterX = width/2 + 11 * width / 64 + width / 36 + bottomButtonHeight/2
            //}
            
            achievementBox = RoundedRectangle()
            achievementBox?.height = bottomButtonHeight
            achievementBox?.width = bottomButtonHeight
            achievementBox?.cornerRadius = 10
            achievementBox?.precision = 60
            achievementBox?.center = (achievementCenterX, 4*height/5, 0)
            achievementBox?.refresh()
            
            let achievementImageWidth = 5*bottomButtonHeight/8
            let achievementImageHeight = achievementImageWidth * (215.0/256.0)
            achievementImage = Image()
            achievementImage?.textureHandle = Textures.trophyTexture
            achievementImage?.vertices = [
                achievementCenterX - achievementImageWidth/2, 4*height/5 - achievementImageHeight/2, 0,
                achievementCenterX - achievementImageWidth/2, 4*height/5 + achievementImageHeight/2, 0,
                achievementCenterX + achievementImageWidth/2, 4*height/5 + achievementImageHeight/2, 0,
                achievementCenterX + achievementImageWidth/2, 4*height/5 - achievementImageHeight/2, 0
            ]
            achievementImage?.drawOrder = [
                0,1,2,0,2,3
            ]
            achievementImage?.uvCoordinates = [
                0,0,
                0,1,
                1,1,
                1,0
            ]
        }

        backgroundRectangle = Rectangle()
        backgroundRectangle?.width = width
        backgroundRectangle?.height = height
        backgroundRectangle?.origin = (0, 0, 0)
        backgroundRectangle?.refresh()
        scoreText = Text()
        scoreText?.setFont("FFF Forward")
        scoreText?.textSize = 50
        scoreText?.text = "\(score)"
        scoreText?.originX = width - 25 - scoreText!.getWidth()
        scoreText?.originY = 3
        scoreText?.originZ = 0
        scoreText?.refresh()
    }
    
    func refreshScore() {
        scoreText?.text = "\(score)"
        scoreText?.originX = width - 25 - scoreText!.getWidth()
        scoreText?.originY = 3
        scoreText?.originZ = 0
        scoreText?.refresh()
        if (score != 0) {
            var brightness: Float
            var bgBrightness : Float
            var saturation: Float
            var bgSaturation: Float
            if (score < 5) {
                if (Float(drand48()) < 0.15) {
                    saturation = 0.5*Float(drand48())
                    brightness = 0.3*Float(drand48())
                } else {
                    saturation = 1
                    brightness = 0.55 + 0.3*Float(drand48())
                }
                bgSaturation = 0.1
                bgBrightness = 0.95
            } else if (score < 10) {
                if (Float(drand48()) < 0.15) {
                    saturation = 0.5*Float(drand48())
                    brightness = 0.3*Float(drand48())
                } else {
                    saturation = 1
                    brightness = 0.3 + 0.3*Float(drand48())
                }
                bgSaturation = 0.3
                bgBrightness = 0.90
            } else if (score < 15) {
                bgSaturation = 1
                bgBrightness = 0.55 + 0.3*Float(drand48())
                saturation = 0.1
                brightness = 0.95
            } else if (score < 20) {
                bgSaturation = 1
                bgBrightness = 0.55 + 0.3*Float(drand48())
                saturation = 0
                brightness = 0
            } else  if (score < 30) {
                saturation = 1
                brightness = 1
                bgSaturation = 0
                bgBrightness = 0
            } else if (score < 40) {
                saturation = 1
                brightness = 1
                bgSaturation = 0
                bgBrightness = 0
            } else {
                saturation = 0
                brightness = 0
                bgSaturation = 0.7
                bgBrightness = 1
            }
            
            
            let hue = Float(drand48())
            
            let renderType = SolidRenderType()
            let renderColor = UIColor(hue: CGFloat(hue), saturation: CGFloat(saturation), brightness: CGFloat(brightness), alpha: 1.0)
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            var alpha: CGFloat = 0
            
            renderColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
            renderType.color = (Float(red), Float(green), Float(blue))
            renderType.alpha = 1
            previousRenderType = currentRenderer
            currentRenderer = renderType
            
            let backgroundRenderType = SolidRenderType()
            let backgroundRenderColor = UIColor(hue: CGFloat(hue), saturation: CGFloat(bgSaturation), brightness: CGFloat(bgBrightness), alpha: 1.0)
            backgroundRenderColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
            backgroundRenderType.color = (Float(red), Float(green), Float(blue))
            backgroundRenderType.alpha = 1
            
            previousBackgroundRenderType = self.backgroundRenderType
            self.backgroundRenderType = backgroundRenderType
            
            mixRenderType = SolidRenderType()
            mixRenderType?.alpha = 1
            mixRenderType?.color = previousRenderType!.color
            
            mixBackgroundRenderType = SolidRenderType()
            mixBackgroundRenderType?.alpha = 1
            mixBackgroundRenderType?.color = previousBackgroundRenderType!.color
            
            if (score >= 30 && score < 40) {
                var hue2: Float
                var difference: Float
                repeat {
                    hue2 = Float(drand48())
                    difference = min(((hue2 - hue) + 1) % 1, (-(hue2 - hue) + 1) % 1)
                } while difference < (120.0/360.0)
                let renderColor2 = UIColor(hue: CGFloat(hue2), saturation: CGFloat(saturation), brightness: CGFloat(brightness), alpha: 1.0)
                renderColor2.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
                renderType.setDualColor((Float(red), Float(green), Float(blue)), width: width)
                if (!previousRenderType!.dual) {
                    previousRenderType?.setDualColor(previousRenderType!.color, width: width)
                }
                mixRenderType?.setDualColor(previousRenderType!.color2!, width: width)
            } else if (score >= 40) {
                var hue2: Float
                var difference: Float
                repeat {
                    hue2 = Float(drand48())
                    difference = min(((hue2 - hue) + 1) % 1, (-(hue2 - hue) + 1) % 1)
                } while difference < (120.0/360.0)
                let renderColor2 = UIColor(hue: CGFloat(hue2), saturation: CGFloat(bgSaturation), brightness: CGFloat(bgBrightness), alpha: 1.0)
                renderColor2.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
                backgroundRenderType.setDualColor((Float(red), Float(green), Float(blue)), width: width)
                if (!previousBackgroundRenderType!.dual) {
                    previousBackgroundRenderType?.setDualColor(previousBackgroundRenderType!.color, width: width)
                }
                mixBackgroundRenderType?.setDualColor(previousBackgroundRenderType!.color2!, width: width)
            }
            
            animatingColorChange = true
            timeOfChange = Int64(NSDate().timeIntervalSince1970*1000)
        }
    }
    
    func unityAdsVideoCompleted(rewardItemKey: String!, skipped: Bool) {
        if (!skipped && inSecondChanceMenu && UnityAds.sharedInstance().getZone() == "rewardedVideo") {
            scheduledSecondChance = true
        }
    }
    
    func onAdColonyV4VCReward(success: Bool, currencyName: String, currencyAmount amount: Int32, inZone zoneID: String) {
        print("finish")
        if (success) {
            scheduledSecondChance = true
        }
    }
}
