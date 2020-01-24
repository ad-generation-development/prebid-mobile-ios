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

import Foundation
import WebKit

public class Utils: NSObject {

    /**
     * The class is created as a singleton object & used
     */
    @objc
    public static let shared = Utils()

    /**
     * The initializer that needs to be created only once
     */
    private override init() {
        super.init()

    }

@objc public func removeHBKeywords (adObject: AnyObject) {

    let adServerObject: String = String(describing: type(of: adObject))
    if (adServerObject == .ADG_Object_Name || adServerObject == .ADG_Interstitial_Name) {
        let hasADGMember = adObject.responds(to: NSSelectorFromString(":setParams"))
        
        if (hasADGMember) {
            if (adObject.value(forKey: "Params") != nil) {
                var existingDict: [String: Any] = adObject.value(forKey: "Params") as! [String: Any]
                for (key, _)in existingDict {
                    if (key.starts(with: "hb_")) {
                        existingDict[key] = nil
                    }
                }
                adObject.setValue( existingDict, forKey: "customTargeting")
            }
        }
    }
}

@objc func validateAndAttachKeywords (adObject: AnyObject, bidResponse: BidResponse) {

    let adServerObject: String = String(describing: type(of: adObject))
    if (adServerObject == .ADG_Object_Name || adServerObject == .ADG_Interstitial_Name) {
        let hasADGMember = adObject.responds(to: NSSelectorFromString(":setParams"))
        
        if (hasADGMember) {
            if (adObject.value(forKey: "Params") != nil) {
                var existingDict: [String: Any] = adObject.value(forKey: "Params") as! [String: Any]
                for (key, _)in existingDict {
                    if (key.starts(with: "hb_")) {
                        existingDict[key] = nil
                    }
                }
                adObject.setValue( existingDict, forKey: "customTargeting")
            }
        }
    }
}

    @available(iOS, deprecated, message: "Please migrate to - AdViewUtils.findPrebidCreativeSize(_:success:failure:)")
    public func findPrebidCreativeSize(_ adView: UIView, completion: @escaping (CGSize?) -> Void) {

        AdViewUtils.findPrebidCreativeSize(adView, success: completion) { (error) in
            Log.warn("Missing failure handler, please migrate to - AdViewUtils.findPrebidCreativeSize(_:success:failure:)")
            completion(nil) // backwards compatibility
        }

    }

}
