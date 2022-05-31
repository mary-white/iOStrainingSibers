//
//  StatisticViewController.swift
//  FennecFox
//
//  Created by student on 31.05.2022.
//

import UIKit

class StatisticViewController: UIViewController {
    
    @IBOutlet var minValueLabel : UILabel?
    @IBOutlet var maxValueLabel : UILabel?
    @IBOutlet var meanValueLabel : UILabel?
    
    var viewModel : StatisticViewModel = StatisticViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        let statistics = viewModel.statisticFromDataContainer()
        minValueLabel?.text = statistics.min
        maxValueLabel?.text = statistics.max
        meanValueLabel?.text = statistics.mean
    }
}
