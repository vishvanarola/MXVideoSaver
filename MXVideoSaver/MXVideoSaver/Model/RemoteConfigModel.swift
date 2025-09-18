//
//  RemoteConfigModel.swift
//  MXVideoSaver
//
//  Created by vishva narola on 02/09/25.
//

import Foundation

struct RemoteAdsModel : Codable {
    var appOpen : String? = nil
    var banner : String? = nil
    var interstitial : String? = nil
    var native : String? = nil
    var rewardedInterstitial : String? = nil
    var intergap : Int? = nil
    var canShowUMP : Bool? = nil
    var restoreShow : Bool? = nil
    var premiumCloseShow : Bool? = nil
    var premiumHeader : String? = nil
    var isShowNativeSettings : Bool? = nil
    
    init() {
        
    }
}
