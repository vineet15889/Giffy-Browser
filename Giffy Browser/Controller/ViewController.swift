//
//  ViewController.swift
//  Giffy Browser
//
//  Created by Vineet Rai on 19/03/21.
//

import UIKit

class ViewController: UIViewController {
    let query = Query()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.perform(query: "", offset: 0, pageSize: 25) // initial load
    }

    fileprivate func perform(query: String, offset: Int, pageSize: Int) {
        return self.query.query(query: query, offset: offset, limit: pageSize).send { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self.process(data)
                case .error(let error):
                    self.displayError(error)
                }
            }
        }
    }

    fileprivate func process(_ data: (Data)) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.processInBackground(data)
        }
    }
    
    fileprivate func processInBackground(_ data: (Data)) {
        let result = GiffyModel.process(data)
        DispatchQueue.main.async {
            switch result {
            case .success(let gifData):
                guard gifData.data.count >= 1 else {
                    return
                }
                
                // display first result right away
//                self.display(gifData.data[0])
//                self.tableViewAdaptorSection.itemCount = gifData.pagination.total_count
//                self.setDataForRange(gifData)
            case .error(let error):
                self.displayError(error)
            }
        }
    }
    
    fileprivate func displayError(_ error: (Error)) {
        print(error)
        let alert = UIAlertController(title: "NetworkError", message: "error \(error)", preferredStyle: .actionSheet)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: {})
        })
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: {})
    }

}

