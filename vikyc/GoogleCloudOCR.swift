//
//  GoogleCloudOCR.swift
//  vikyc
//
//  Created by Aditya Chauhan on 21/06/19.
//  Copyright © 2019 Aditya Chauhan. All rights reserved.
//

import Foundation
import Alamofire

class GoogleCloudOCR {
    private let apiKey = "AIzaSyBmHjIq9FWDpVVFzux7J1fSsv48ku0-6nw"
    private var apiURL: URL{
        return URL(string: "https://vision.googleapis.com/v1/images:annotate?key=\(apiKey)")!
    }
    
    func detect(from image: UIImage, completion: @escaping (String?) -> Void){
        guard let base64Image = base64EncodeImage(image) else{
            print("Error while encoding image to base 64 format")
            completion(nil)
            return
        }
        
        callGoogleVisionApi(with: base64Image, completion: completion)
        
    }
    
    private func callGoogleVisionApi(with base64EncodedImage: String, completion: @escaping (String?) -> Void){
        
        let parameters: Parameters = [
            "requests": [
                [
                    "image": [
                        "content": base64EncodedImage
                    ],
                    "features": [
                        [
                            "type" : "TEXT_DETECTION"
                        ]
                    ]
                ]
            ]
        ]
        let headers: HTTPHeaders = [
            "X-Ios-Bundle-Identifier" : Bundle.main.bundleIdentifier ?? "",
        ]
        Alamofire.request(
            apiURL,
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers:  headers).responseData { response in
                if response.result.isFailure{
                    
                    completion(nil)
                    return
                }
                guard let data = response.result.value else{
                    
                    completion(nil)
                    return
                }
                let ocrResponse = try? JSONDecoder().decode(GoogleCloudOCRResponse.self, from: data)
                
                completion(ocrResponse?.responses[0].annotations[0].text)
                
            }
    }
    
    private func base64EncodeImage(_ image: UIImage) -> String? {
        return image.pngData()?.base64EncodedString(options: .endLineWithCarriageReturn)
    }
}
