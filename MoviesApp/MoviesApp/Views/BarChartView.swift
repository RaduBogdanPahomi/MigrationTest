//
//  BarChartView.swift
//  MoviesApp
//
//  Created by Tudor Ghilvacs on 24.10.2022.
//

import UIKit

class BarChartView: UIView {
    //MARK: - Private properties
    private let mainLayer: CALayer = CALayer()
    private let scrollView: UIScrollView = UIScrollView()
    private let space: CGFloat = 10.0
    private let barWidth: CGFloat = 40.0
    private let contentSpace: CGFloat = 80
    
    //MARK: - Public properties
    var dataEntries: [Int] = [] {
        didSet {
            mainLayer.sublayers?.forEach({ $0.removeFromSuperlayer() })
            
            scrollView.contentSize = CGSize(width: frame.size.width,
                                            height: frame.size.height)
            mainLayer.frame = CGRect(x: 0,
                                     y: 0,
                                     width: scrollView.contentSize.width,
                                     height: scrollView.contentSize.height)
            
            for i in 0..<dataEntries.count{
                showEntry(index: i, value: dataEntries[i])
             }
        }
    }
    
    //MARK: - Public API
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    override func layoutSubviews() {
       scrollView.frame = CGRect(x: 0,
                                 y: 0,
                                 width: frame.size.width,
                                 height: frame.size.height)
    }
}

//MARK: - Private API
private extension BarChartView {
    func setupView() {
       scrollView.layer.addSublayer(mainLayer)
       addSubview(scrollView)
    }
    
    func showEntry(index: Int, value: Int) {
        let xPos: CGFloat = space + CGFloat(index) * 38.0
        let yPos: CGFloat = translateHeightValueToYPosition(value: Float(value) / Float(12))
        drawBar(xPos: xPos, yPos: yPos)
        drawTitle(xPos: xPos + 7.5, yPos: yPos, width: 15.0, height: 15.0, title: "\(index + 1)")
    }
    
    func drawBar(xPos: CGFloat, yPos: CGFloat) {
        let barLayer = CALayer()
        barLayer.frame = CGRect(x: xPos, y: frame.height - yPos - 25, width: 30, height: yPos)
        barLayer.backgroundColor = UIColor.darkGray.cgColor
        mainLayer.addSublayer(barLayer)
    }
    
    func drawTitle(xPos: CGFloat, yPos: CGFloat, width: CGFloat, height: CGFloat, title: String) {
        let textLayer = CATextLayer()
        textLayer.frame = CGRect(x: xPos, y: frame.height - 20.0, width: width, height: height)
        textLayer.foregroundColor = UIColor.tintColor.cgColor
        textLayer.alignmentMode = CATextLayerAlignmentMode.center
        textLayer.fontSize = 12
        textLayer.string = title
        mainLayer.addSublayer(textLayer)
    }
    
    func translateHeightValueToYPosition(value: Float) -> CGFloat {
        let height = CGFloat(value) * ((mainLayer.frame.height))
        return height
    }
}
