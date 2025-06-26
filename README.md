# Wish Bubble App

A beautiful SwiftUI app for creating and sharing wishes with animated bubbles.

## New Social Feature

The app now includes a social feature that allows users to:

1. Share wishes with the community
2. Send energy to other users' wishes
3. See beautiful energy flow animations

### Setting Up Firebase

To enable the social features, you need to set up Firebase:

1. Create a Firebase project at [firebase.google.com](https://firebase.google.com)
2. Add an iOS app to your Firebase project
3. Download the `GoogleService-Info.plist` file and add it to your Xcode project
4. Add the Firebase SDK to your project using Swift Package Manager:
   - In Xcode, go to File > Add Packages
   - Enter the Firebase iOS SDK URL: https://github.com/firebase/firebase-ios-sdk
   - Select the following products:
     - FirebaseAuth
     - FirebaseFirestore
     - FirebaseFirestoreSwift
     - FirebaseStorage

### Firestore Database Structure

Create the following collections in your Firestore database:

1. **users**
   - id (auto-generated)
   - username (string)
   - profileImageURL (string, optional)
   - createdWishes (number)
   - energySent (number)
   - joinedDate (timestamp)

2. **wishes**
   - id (auto-generated)
   - userId (string)
   - username (string)
   - userProfileImageURL (string, optional)
   - text (string)
   - imageURL (string, optional)
   - isPublic (boolean)
   - energyCount (number)
   - createdAt (timestamp)

3. **energyTransfers**
   - id (auto-generated)
   - fromUserId (string)
   - fromUsername (string)
   - toWishId (string)
   - amount (number)
   - timestamp (timestamp)

### Security Rules

Add these Firestore security rules:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read: if true;
      allow create: if request.auth != null && request.auth.uid == userId;
      allow update: if request.auth != null && request.auth.uid == userId;
    }
    
    match /wishes/{wishId} {
      allow read: if true;
      allow create: if request.auth != null && request.resource.data.userId == request.auth.uid;
      allow update: if request.auth != null && (
        resource.data.userId == request.auth.uid || 
        request.resource.data.diff(resource.data).affectedKeys().hasOnly(['energyCount'])
      );
    }
    
    match /energyTransfers/{transferId} {
      allow read: if true;
      allow create: if request.auth != null && request.resource.data.fromUserId == request.auth.uid;
    }
  }
}
```

## Energy Animation

The energy flow animation uses:
- Bezier path calculations for smooth curved motion
- Particle system with randomized properties
- Burst effect at the destination
- Timer-based position updates for smooth animation

## Future Enhancements

Planned enhancements for the social feature:
- User profiles with statistics
- Wish categories and filtering
- Energy leaderboards
- Notification system for received energy
- Enhanced animation effects 