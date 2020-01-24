/*   Copyright 2018-2019 Prebid.org, Inc.

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

import UIKit

import PrebidMobile

import ADG


class BannerController: UIViewController {

   @IBOutlet var appBannerView: UIView!

    

    var adUnit: AdUnit!
    
    var adgBanner: ADGManagerViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        enableCOPPA()
//        addFirstPartyData(adUnit: bannerUnit)
//        setStoredResponse()
//        setRequestTimeoutMillis()
        loadADGBanner()
    }

    override func viewDidDisappear(_ animated: Bool) {
        // important to remove the time instance
        adUnit?.stopAutoRefresh()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.adgBanner?.resumeRefresh()
    }

    
    func setupPBBanner() {
        Prebid.shared.prebidServerHost = .Appnexus
        Prebid.shared.prebidServerAccountId = "bfa84af2-bd16-4d35-96ad-31c6bb888df0"
        Prebid.shared.storedAuctionResponse = ""
        
        adUnit = BannerAdUnit(configId: "6ace8c7d-88c0-4623-8117-75bc3f0a2e45", size: CGSize(width: 300, height: 250))
        adUnit.setAutoRefreshMillis(time: 35000)
    }
    
    func loadADGBanner() {
        setupPBBanner()
        
        adgBanner = ADGManagerViewController(locationID: "48549", adType: .adType_Rect, rootViewController: self)
        adgBanner!.addAdContainerView(self.appBannerView)
        adgBanner!.delegate = self
        
        adUnit.fetchDemand(adObject: adgBanner!) { (resultCode: ResultCode) in
            print("Prebid demand fetch for ADG \(resultCode.name())")
            self.adgBanner!.loadRequest()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func enableCOPPA() {
        Targeting.shared.subjectToCOPPA = true
    }
    
    func addFirstPartyData(adUnit: AdUnit) {
        //Access Control List
        Targeting.shared.addBidderToAccessControlList(Prebid.bidderNameAppNexus)
        
        //global user data
        Targeting.shared.addUserData(key: "globalUserDataKey1", value: "globalUserDataValue1")
        
        //global context data
        Targeting.shared.addContextData(key: "globalContextDataKey1", value: "globalContextDataValue1")
        
        //adunit context data
        adUnit.addContextData(key: "adunitContextDataKey1", value: "adunitContextDataValue1")
        
        //global context keywords
        Targeting.shared.addContextKeyword("globalContextKeywordValue1")
        Targeting.shared.addContextKeyword("globalContextKeywordValue2")
        
        //global user keywords
        Targeting.shared.addUserKeyword("globalUserKeywordValue1")
        Targeting.shared.addUserKeyword("globalUserKeywordValue2")
        
        //adunit context keywords
        adUnit.addContextKeyword("adunitContextKeywordValue1")
        adUnit.addContextKeyword("adunitContextKeywordValue2")
    }
    
    func setStoredResponse() {
        Prebid.shared.storedAuctionResponse = "111122223333"
    }
    
    func setRequestTimeoutMillis() {
        Prebid.shared.timeoutMillis = 5000
    }
    deinit {
        // インスタンスの破棄
        adgBanner = nil
    }
}

extension BannerController: ADGManagerViewControllerDelegate {
    
    func adgManagerViewControllerReceiveAd(_ adgManagerViewController: ADGManagerViewController) {
        print("Received an ad.")
    }
    
    func adgManagerViewControllerFailed(toReceiveAd adgManagerViewController: ADGManagerViewController, code: kADGErrorCode) {
        print("Failed to receive an ad.")
        // エラー時のリトライは特段の理由がない限り必ず記述するようにしてください。
        switch code {
        case .adgErrorCodeNeedConnection, // ネットワーク不通
        .adgErrorCodeExceedLimit, // エラー多発
        .adgErrorCodeNoAd: // 広告レスポンスなし
            break
        default:
            adgManagerViewController.loadRequest()
        }
    }
    
    func adgManagerViewControllerDidTapAd(_ adgManagerViewController: ADGManagerViewController) {
        print("Did tap an ad.")
    }
}

