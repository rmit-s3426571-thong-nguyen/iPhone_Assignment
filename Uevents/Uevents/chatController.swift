//
//  chatController.swift
//  Uevents
//
//  Created by Thong Nguyen on 15/05/2016.
//  Copyright © 2016 ThongNguyen. All rights reserved.
//
//  These codes has been following this tutorial
//  https://www.raywenderlich.com/122148/firebase-tutorial-real-time-chat
//  Educational purposes only


import UIKit
import FirebaseAuth
import FirebaseDatabase
import JSQMessagesViewController

class chatController: JSQMessagesViewController, UIPopoverPresentationControllerDelegate {
    
    let ref = FIRDatabase.database().reference()
    var messageRef: FIRDatabaseReference? = nil
    var user: FIRUser? = nil
    
    
    var messages = [JSQMessage]()
    
    var outgoingBubbleImageView: JSQMessagesBubbleImage!
    var incomingBubbleImageView: JSQMessagesBubbleImage!
    
    var messageQuery: FIRDatabaseQuery? = nil
    
    private func setupBubble(){
        let factory = JSQMessagesBubbleImageFactory()
        outgoingBubbleImageView = factory.outgoingMessagesBubbleImageWithColor(UIColor(red: 255/255, green: 105/255, blue: 105/255, alpha: 1))
        incomingBubbleImageView = factory.incomingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleLightGrayColor())
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBubble()
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSizeZero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero
        
        // Fix for tabbar covering message input field
        self.edgesForExtendedLayout = UIRectEdge.None
        messageRef = ref.child("messages")
    }
    override func collectionView(collectionView: JSQMessagesCollectionView!,
                                 messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        
        let message = messages[indexPath.item]
        
        if message.senderId == senderId {
            return outgoingBubbleImageView
        } else {
            return incomingBubbleImageView
        }
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        let message = messages[indexPath.item];
        
        if message.senderDisplayName == senderDisplayName {
            return nil;
        }
        
        if indexPath.item > 0 {
            let previousMessage = messages[indexPath.item - 1];
            if previousMessage.senderDisplayName == message.senderDisplayName {
                return nil;
            }
        }
        
        return NSAttributedString(string:message.senderDisplayName)
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        let message = messages[indexPath.item]
        

        if message.senderDisplayName == senderDisplayName {
            return CGFloat(0.0);
        }
        
        if indexPath.item > 0 {
            let previousMessage = messages[indexPath.item - 1];
            if previousMessage.senderDisplayName == message.senderDisplayName {
                return CGFloat(0.0);
            }
        }
        
        return kJSQMessagesCollectionViewCellLabelHeightDefault
    }

    
    override func collectionView(collectionView: JSQMessagesCollectionView!,avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    override func collectionView(collectionView: JSQMessagesCollectionView!,
                                 messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! JSQMessagesCollectionViewCell
        
        let message = messages[indexPath.item]
        if message.senderId == senderId {
            cell.textView!.textColor = UIColor.whiteColor()
        } else {
            cell.textView!.textColor = UIColor.blackColor()
        }
        
        return cell
    }
    
    func addMessage(id: String, text: String, senderDisplayName: String) {
        
        //let message = JSQMessage(senderId: id, text: text)
        let message = JSQMessage(senderId: id, displayName: senderDisplayName, text: text)
        messages.append(message)
    }
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        let itemRef = messageRef!.childByAutoId()
        let messageItem = [
            "text": text,
            "senderId": senderId,
            "senderDisplayName": senderDisplayName
        ]
        itemRef.setValue(messageItem)
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        finishSendingMessage()
        
    }
    
    /**
     Listen for new messages
     */
    private func observeMessages() -> FIRDatabaseQuery {
        let messagesQuery = messageRef!.queryLimitedToLast(25)
        
        messagesQuery.observeEventType(.ChildAdded) { (snapshot: FIRDataSnapshot!) in
            let id = snapshot.value!["senderId"] as! String
            let text = snapshot.value!["text"] as! String
            let senderDisplayName = snapshot.value!["senderDisplayName"] as! String
            
            self.addMessage(id, text: text,senderDisplayName: senderDisplayName)
            self.finishReceivingMessage()
        }
        JSQSystemSoundPlayer.jsq_playMessageReceivedAlert()
        JSQSystemSoundPlayer.jsq_playMessageReceivedSound()
        return messagesQuery
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Add a listener for new messages
        if messageQuery == nil {
            messageQuery = observeMessages()
        }
    }
    
    /**
     Show Giphy picker
     */
    override func didPressAccessoryButton(sender: UIButton!) {
        let storyboard = self.storyboard
        let controller = storyboard?.instantiateViewControllerWithIdentifier("GiphyPicker") as! GiphyPickerController
        
        controller.delegate = self
        
        // present the controller
        // on iPad, this will be a Popover
        // on iPhone, this will be an action sheet
        controller.modalPresentationStyle = UIModalPresentationStyle.Popover
        presentViewController(controller, animated: true, completion: nil)
        
        // configure the Popover presentation controller
        let popController = controller.popoverPresentationController!
        popController.permittedArrowDirections = UIPopoverArrowDirection.Any
        popController.barButtonItem = self.toolbarItems?.first
        popController.delegate = self
    }
    
}

extension chatController: GiphyPickerDelegate {
    func pickedGif(gif: GiphyGif) {
        
        let itemRef = self.messageRef!.childByAutoId()
        let messageItem = [
            "text": gif.url,
            "senderId": self.senderId,
            "senderDisplayName": self.senderDisplayName
        ]
        itemRef.setValue(messageItem)
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        
        self.finishSendingMessage()
    }
}
