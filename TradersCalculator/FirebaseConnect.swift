////
////  FirebaseConnect.swift
////  CarsAndOwners
////
////  Created by Yaroslav Zhurbilo on 10.07.17.
////  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
////
//
//import Foundation
//import Firebase
//import FirebaseAuth
//
//class FirebaseConnect {
//    
//    var ref: DatabaseReference!  // Reference variable for the Database
//    var handle: AuthStateDidChangeListenerHandle! // Variable to handle Firebase Listener
//    
//    init() {
//        self.configureDatabase()
//    }
//    
//    // Configure the Firebase database
//    func configureDatabase() {
//        
//        // Make a reference to the database
//        ref = Database.database().reference()
//        
//        // Check if Firebase user is authenticated
//        firebaseAuthCheck()
//        
//    }
//    
//    // Check if Firebase user is authenticated
//    func firebaseAuthCheck() {
//        handle = Auth.auth().addStateDidChangeListener { auth, user in
//            if user != nil {
//                
//            } else {
//                self.firebaseAuth() // Authenticate to the Database
//            }
//        }
//    }
//    
//    // Authenticate to the Database
//    func firebaseAuth() {
//        Auth.auth().signIn(withEmail: "traderscalculator@gmail.com", password: "Around657-Uncle-bob", completion: { (user, error) in
//            
//            //TODO: Make error handler
//            
//        })
//    }
//}
//
