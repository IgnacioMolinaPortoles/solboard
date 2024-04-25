//
//  AssetsMapper.swift
//  Solboard
//
//  Created by Ignacio Molina Portoles on 23/04/2024.
//

import Foundation


struct AssetsMapper {
    static func map(response: AssetByOwnerResponse?) -> [AssetItemViewModel] {
        return map(response?.result?.items ?? [], onAssetDetailTap: nil)
    }
    
    static func map(_ items: [AssetItem], onAssetDetailTap: (() -> Void)?) -> [AssetItemViewModel] {
        var assetsViewModel: [AssetItemViewModel] = []
        
        items.forEach({ item in
            assetsViewModel.append(AssetItemViewModel(from: item))
        })
        
        return assetsViewModel
    }
}
