//
//  MoodPickerViewController.swift
//  MoodePicker
//
//  Created by Ahmed Khalaf on 2/2/19.
//  Copyright © 2019 Ahmed Khalaf. All rights reserved.
//

import UIKit

class MoodPickerViewController: UIViewController {
    // Credits: https://gist.github.com/iandundas/59303ab6fd443b5eec39
    let emojis = [UInt32](0x1F601...0x1F64F).compactMap({ UnicodeScalar($0) }).map({ String($0) })
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var spacing: CGFloat = 0
    private var cellSize: CGSize = .zero
    private var index = 0
    
    override func viewDidLayoutSubviews() {
        cellSize = CGSize(width: collectionView.bounds.width / 4, height: collectionView.bounds.height)
        spacing = collectionView.bounds.width / 2 - cellSize.width / 2
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { (_) in
            self.cellSize = CGSize(width: self.collectionView.bounds.width / 4, height: self.collectionView.bounds.height)
            self.spacing = self.collectionView.bounds.width / 2 - self.cellSize.width / 2
            
            self.collectionView.performBatchUpdates({
                
            }, completion: { (_) in
                self.collectionView.scrollToItem(at: IndexPath(row: self.index, section: 0), at: .centeredHorizontally, animated: false)
            })
        }, completion: nil)
    }
}

class MoodCell: UICollectionViewCell {
    
    var emoji = "" {
        didSet {
            label.text = emoji
        }
    }
    
    @IBOutlet private weak var label: UILabel!
}

extension MoodPickerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emojis.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MoodCell
        cell.emoji = emojis[indexPath.row]
        return cell
    }
}

extension MoodPickerViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
    }
}

extension MoodPickerViewController: UICollectionViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        var targetIndex = (targetContentOffset.pointee.x + cellSize.width / 2) / cellSize.width
        targetIndex = velocity.x > 0 ? ceil(targetIndex) : floor(targetIndex)
        targetIndex = targetIndex.clamped(minValue: 0, maxValue: CGFloat(emojis.count - 1))
        targetContentOffset.pointee.x = targetIndex * cellSize.width
        
        index = Int(targetIndex)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}

fileprivate extension CGFloat {
    func clamped(minValue: CGFloat, maxValue: CGFloat) -> CGFloat {
        return Swift.min(maxValue, Swift.max(minValue, self))
    }
}
