//
//  WalkThroughViewController.swift
//  ruler-ios
//
//  Created by Tigran Arsenyan on 11/20/21.
//

import UIKit

class WalkThroughViewController: UIViewController {

    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollViewsContentView: UIView!
    @IBOutlet private weak var pageControl: UIPageControl!
    @IBOutlet private weak var continueButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        
        initUI()
    }
    
    private func initUI() {
        continueButton.layer.cornerRadius = 25
        
        pageControl.setIndicatorImage(UIImage(named: "pageControlActive"), forPage: 0)
        pageControl.preferredIndicatorImage = UIImage(named: "pageControlDisabled")
    }
    
    private func getCurrentPage() -> Int {
        return Int(floorf(Float(scrollView.contentOffset.x) / Float(scrollView.frame.size.width)))
    }
    
    @IBAction func pageControlDidChangeValue(_ sender: UIPageControl) {
        let currentPage = sender.currentPage
        scrollView.setContentOffset(CGPoint(x: scrollView.bounds.width * CGFloat(currentPage), y: 0), animated: true)
    }
    
    @IBAction func skipAction(_ sender: UIButton) {
        // save in user defaults
        UserSeenWalkThroughScene().execute()
        
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "RulerViewController") as? RulerViewController else { return }
        vc.modalPresentationStyle = .fullScreen
        
        dismiss(animated: false)
        present(vc, animated: true)
    }
    
    @IBAction func continueAction(_ sender: UIButton) {
        let currentPage = pageControl.currentPage
        
        if currentPage == 2 {
            // ended all pages
            // subscribe action
            UserSeenWalkThroughScene().execute()
            return
        }
        
        scrollView.setContentOffset(CGPoint(x: scrollView.bounds.width * CGFloat(currentPage + 1), y: 0), animated: true)
    }
}

extension WalkThroughViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // setting the pagecontroll current page when the scroll view changed it's page
        pageControl.currentPage = getCurrentPage()
        
        if pageControl.currentPage == 2 {
            continueButton.setTitle("Subscribe", for: .normal)
        } else {
            continueButton.setTitle("Continue", for: .normal)
        }
    }
}
