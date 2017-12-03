//
//  ScrollExtensionView.swift
//  Joyle
//
//  Created by Сергей Гаврилко on 02.12.17.
//  Copyright © 2017 Сергей Гаврилко. All rights reserved.
//

import UIKit

extension ViewController: UIScrollViewDelegate{

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if (scrollView == cV){
            if (cV.contentOffset.y > 0){
                underTopView.layer.shadowOpacity = 0.06
            }
            else{
                underTopView.layer.shadowOpacity = 0.0
            }
        }
        else if (scrollView == more_scrollView){
            if (more_scrollView.contentOffset.y > 0){
                more_titleView.layer.shadowOpacity = 0.06
            }
            else{
                more_titleView.layer.shadowOpacity = 0.0
            }
        }
    }
    
}
