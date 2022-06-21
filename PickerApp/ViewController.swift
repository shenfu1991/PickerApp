//
//  ViewController.swift
//  PickerApp
//
//  Created by zhihong Meng on 2022/6/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imgView: UIImageView!
    
    let path = "/Users/xuanyuan/Desktop/AI"
    var imgs: [String] = []
    var names: [String] = []
    var currentImgPath = ""
    var currentIndex = -1
    var currentName = ""
    var total = 0
    var remain = 0
    
    @IBOutlet weak var label: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }


    @IBAction func upAction(_ sender: Any) {
        let url = URL(fileURLWithPath: currentImgPath)
        let tUrl = "/Users/xuanyuan/Desktop/all/up/\(currentName)"
        try? FileManager.default.moveItem(atPath: url.path, toPath: tUrl)
        nextImage()
    }
    
    
    @IBAction func midAction(_ sender: Any) {
        let url = URL(fileURLWithPath: currentImgPath)
        let tUrl = "/Users/xuanyuan/Desktop/all/mid/\(currentName)"
        try? FileManager.default.moveItem(atPath: url.path, toPath: tUrl)
        nextImage()
    }
    
    
    @IBAction func downAction(_ sender: Any) {
        let url = URL(fileURLWithPath: currentImgPath)
        let tUrl = "/Users/xuanyuan/Desktop/all/down/\(currentName)"
        try? FileManager.default.moveItem(atPath: url.path, toPath: tUrl)
        nextImage()
    }
    
    
    @IBAction func showAction(_ sender: Any) {
        listFilesFromDocumentsFolder()
        nextImage()
    }
    
    func listFilesFromDocumentsFolder() {
        let fm = FileManager.default
        let items = try? fm.contentsOfDirectory(atPath: path)
        guard let its = items else {
            return
        }
        imgs = []
        for item in its {
            //            print("Found \(item)")
            let full = "\(path)/\(item)"
            imgs.append(full)
            names.append(item)
        }
        total = names.count
//        debugPrint(imgs)
    }
    
    func nextImage() {
        currentIndex += 1
        currentImgPath = imgs[currentIndex]
        currentName = names[currentIndex]
        let img = UIImage(contentsOfFile: currentImgPath)
        imgView.image = img
        remain = names.count-currentIndex-1
        label.text = "\(remain)/\(total)"
    }
}

