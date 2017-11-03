//
//  GCDMain.swift
//  ShareYourTravel
//
//  Created by Daeyun Ethan Kim on 04/09/2017.
//  Copyright © 2017 Daeyun Ethan Kim. All rights reserved.
//


import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}


