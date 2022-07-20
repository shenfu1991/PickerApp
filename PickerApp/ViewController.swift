//
//  ViewController.swift
//  PickerApp
//
//  Created by zhihong Meng on 2022/6/21.
//

import UIKit
import SDWebImage

class ViewController: UIViewController {

    @IBOutlet weak var imgView: UIImageView!
    
    let path = "/Users/xuanyuan/Desktop/101010-AI"
    var imgs: [String] = []
    var names: [String] = []
    var currentImgPath = ""
    var currentIndex = -1
    var currentName = ""
    var total = 0
    var remain = 0
    var sNames: [String] = []
    var sNamesIndex: Int = 0

    @IBOutlet weak var label: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listFilesFromDocumentsFolder()
        imgView.image = nil
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
    
    
    @IBAction func sUpAction(_ sender: Any) {
        let url = URL(fileURLWithPath: currentImgPath)
        let tUrl = "/Users/xuanyuan/Desktop/all/sUp/\(currentName)"
        try? FileManager.default.moveItem(atPath: url.path, toPath: tUrl)
        nextImage()
    }
    
    
    @IBAction func sDownAction(_ sender: Any) {
        let url = URL(fileURLWithPath: currentImgPath)
        let tUrl = "/Users/xuanyuan/Desktop/all/sDown/\(currentName)"
        try? FileManager.default.moveItem(atPath: url.path, toPath: tUrl)
        nextImage()
    }
    
    @IBAction func showAction(_ sender: Any) {
        nextImage()
    }
    
    func listFilesFromDocumentsFolder() {
        let fm = FileManager.default
        let items = try? fm.contentsOfDirectory(atPath: path)
        guard let its = items else {
            return
        }
        imgs = []
        names = []
        for item in its {
            //            print("Found \(item)")
            let full = "\(path)/\(item)"
            imgs.append(full)
            names.append(item)
        }
        total = names.count
        remain = names.count-currentIndex-1
        label.text = "\(remain)/\(total)"
        

        
        
//        debugPrint(imgs)
        
//        readFile()
//        writeToFile()
    }
    
    func readFile() {
        let path = Bundle.main.path(forResource: "AI", ofType: "plist")
        let dic = NSDictionary(contentsOfFile: path!)
        let arr = dic?["pics"] as? [String] ?? []
        debugPrint(arr.count)
    }
    
    func writeToFile() {
        let p = "/Users/xuanyuan/Desktop/AI.plist"
        let dic = ["pics": names]
        let info = dic as NSDictionary
        do {
            info.write(toFile: p, atomically:true)
        }catch {
            debugPrint(error)
        }
    }
    
    func nextImage() {
        currentIndex += 1
        currentImgPath = imgs[currentIndex]
        currentName = names[currentIndex]
        remain = names.count-currentIndex-1
        label.text = "\(remain)/\(total)"
        let img = UIImage(contentsOfFile: currentImgPath)
        imgView.image = img
    }
    
    
    
    @IBAction func regAction(_ sender: Any) {
//        let path = Bundle.main.path(forResource: "AI", ofType: "plist")
//        if let dic = NSDictionary(contentsOfFile: path!) as? [String: Any] {
//            if let ns = dic["pics"] as? [String] {
//                sNames = ns
//                goReg()
//            }
//        }
//        getClass()
        moveFiles()
    }
    
    func goReg() {
        let name = sNames[sNamesIndex]
        let str = "https://us6.xuanyuanhuangdi.org/AI/" + name
        imgView.sd_setImage(with: URL(string: str)) { img, error, type, _ in
            if let img = img {
                let mmm = x_Bot()
                let result =  try? mmm.prediction(input: x_BotInput(imageWith: (img.cgImage)!))
                let res = result?.classLabel ?? ""
                var text = ""
                if let dic = result?.classLabelProbs {
                    text = " \(dic)"
                }
                debugPrint(text)
                debugPrint("=====")
                debugPrint(res)
                let rate = result?.classLabelProbs[res] ?? 0
                let restt = "\(res)"
                self.label.text = "\(self.sNamesIndex+1)/\(self.sNames.count)\n" + restt
//                if rate >= 0.9 {
                  self.sendResult(res: res, name: name.replacingOccurrences(of: ".png", with: ""))
//                }
                DispatchQueue.main.asyncAfter(deadline: .now()+0.05) {
                    self.goNext()
                }
            }else{
                DispatchQueue.main.asyncAfter(deadline: .now()+0.05) {
                    self.goNext()
                }
            }
        }
    }
    
    func goNext() {
        sNamesIndex += 1
        if sNamesIndex >= sNames.count {
//            exit(0)
            self.label.text = "all done"
            return
        }
        goReg()
    }
    
    func sendResult(res: String,name: String) {
        
        let url = "https://bn.xuanyuanhuangdi.org/sentResult/\(res)/\(name)"
        NetwokingManager.request(method: .get, URLString: url, parameters: nil) { [weak self] res in
            guard let self = self else { return }
            
        } failure: { error in
            
        }
        
    }
    
    func getClass() {
        let url = "https://bn.xuanyuanhuangdi.org/getResult"
        NetwokingManager.request(method: .get, URLString: url, parameters: nil) { [weak self] res in
            guard let self = self else { return }
//            debugPrint(res)
            guard let result = res as? [String: Any] else {
                return
            }
            
            if let arr = result["mid"] as? [String] {
                for name in arr {
                    let url = "/Users/xuanyuan/Desktop/AI/\(name).png"
                    let tUrl = "/Users/xuanyuan/Desktop/all/mid/\(name).png"
                    try? FileManager.default.moveItem(atPath: url, toPath: tUrl)
                }
            }
            
            if let arr = result["down"] as? [String] {
                for name in arr {
                    let url = "/Users/xuanyuan/Desktop/AI/\(name).png"
                    let tUrl = "/Users/xuanyuan/Desktop/all/down/\(name).png"
                    try? FileManager.default.moveItem(atPath: url, toPath: tUrl)
                }
            }
            
            if let arr = result["up"] as? [String] {
                for name in arr {
                    let url = "/Users/xuanyuan/Desktop/AI/\(name).png"
                    let tUrl = "/Users/xuanyuan/Desktop/all/up/\(name).png"
                    try? FileManager.default.moveItem(atPath: url, toPath: tUrl)
                }
            }
            
            if let arr = result["sDown"] as? [String] {
                for name in arr {
                    let url = "/Users/xuanyuan/Desktop/AI/\(name).png"
                    let tUrl = "/Users/xuanyuan/Desktop/all/sDown/\(name).png"
                    try? FileManager.default.moveItem(atPath: url, toPath: tUrl)
                }
            }
            
            if let arr = result["sUp"] as? [String] {
                for name in arr {
                    let url = "/Users/xuanyuan/Desktop/AI/\(name).png"
                    let tUrl = "/Users/xuanyuan/Desktop/all/sUp/\(name).png"
                    try? FileManager.default.moveItem(atPath: url, toPath: tUrl)
                }
            }
            
            
            
        } failure: { error in
            
        }
    }
    
    func moveFiles() {
        let mmm = try? High15()
        
        for (idx,url) in imgs.enumerated() {
            
                let img = UIImage(contentsOfFile: url)
                let result =  try? mmm!.prediction(input: High15Input(imgWith: (img?.cgImage)!))
                let res = result?.classLabel ?? ""
                var rate: Double = 0
                if let info = result?.Identity {
                    rate = info[res] ?? 0
                }
                if rate >= 0.99 {
                    let name = names[idx]
                    let tUrl = "/Users/xuanyuan/Desktop/all/\(res)/\(name)"
                    try? FileManager.default.moveItem(atPath: url, toPath: tUrl)
                }
                //            debugPrint("\(res): \(rate)")
                label.text = "\(idx+1)/\(total)"
        }
        
      
    }
    
}

