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

class InterstitialViewController: UIViewController {
    
    var adUnit: AdUnit!
    var interstitial: ADGInterstitial?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAndLoadADGInterstitial()
    }

    func setupAndLoadADGInterstitial() {
        setupPBInterstitial()
        setupADGInterstitial()
        loadInterstitial()
    }
    
    
    func setupPBInterstitial() {
        Prebid.shared.prebidServerHost = PrebidHost.Appnexus
        Prebid.shared.prebidServerAccountId = "bfa84af2-bd16-4d35-96ad-31c6bb888df0"
        Prebid.shared.storedAuctionResponse = ""
        
        adUnit = InterstitialAdUnit(configId: "625c6125-f19e-4d5b-95c5-55501526b2a4")
        
//        Advanced interstitial support
//        adUnit = InterstitialAdUnit(configId: "625c6125-f19e-4d5b-95c5-55501526b2a4", minWidthPerc: 50, minHeightPerc: 70)

    }
    
    func setupADGInterstitial() {
        interstitial = ADGInterstitial()
        interstitial!.setLocationId("48549")    // 管理画面から払い出された広告枠ID
        interstitial!.delegate = self
        interstitial!.rootViewController = self
    }
    
    func loadInterstitial() {
        print("Google Mobile Ads SDK version: \(ADGConstants.version())")
        
        adUnit.fetchDemand(adObject: self.interstitial!) { (resultCode: ResultCode) in
            print("Prebid demand fetch for ADG \(resultCode.name())")
            self.interstitial?.preload()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension InterstitialViewController: ADGInterstitialDelegate {
    
    func adgManagerViewControllerReceiveAd(_ adgManagerViewController: ADGManagerViewController) {
        print("Received an ad.")
        self.interstitial?.show()
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
            self.interstitial?.preload()
        }
    }
    
    func adgManagerViewControllerDidTapAd(_ adgManagerViewController: ADGManagerViewController) {
        print("Did tap an ad.")
    }
    
    func adgInterstitialClose() {
        print("Closed interstitial ads")
    }
    
}
