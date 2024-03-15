//
//  MainViewModel.swift
//  Table&Collection
//
//  Created by Vitaly Anpilov on 13.03.2024.
//

import Foundation

protocol MainViewModelProtocol {
    var verticalItems: [VerticalItem] { get set }
    var updateRandomCell: (([Int]) -> Void)? { get set }
    var updateTableView: (() -> Void)? { get set }
    
    func getData()
}


class MainViewModel: MainViewModelProtocol {
    private var timer: DispatchSourceTimer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
    private let backgroundQueue = DispatchQueue.global(qos: .background)
    private let backgroundLock = NSLock()
    
    var verticalItems: [VerticalItem] = []
    var updateTableView: (() -> Void)?
    var updateRandomCell: (([Int]) -> Void)?
    
    func getData() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let items = self.loadData()
            DispatchQueue.main.async {
                self.verticalItems = items
                self.updateTableView?()
                self.startTimerForUpdate()
            }
        }
    }
    
    private func loadData() -> [VerticalItem] {
        var items: [VerticalItem] = []
        let itemsCount = Int.random(in: 101...150)
        for _ in 0..<itemsCount {
            var horizontalItems: [HorizontalItem] = []
            let horizontalCount = Int.random(in: 11...15)
            for _ in 0..<horizontalCount {
                horizontalItems.append(HorizontalItem(number: Int.random(in: 1...100)))
            }
            items.append(VerticalItem(horizontalItems: horizontalItems))
        }
        return items
    }
    
    private func startTimerForUpdate() {
        timer.schedule(deadline: .now(), repeating: .seconds(Constants.timerInterval))
        timer.setEventHandler { [weak self] in
            self?.updateRandomHorizontalItem();
        }
        timer.resume()
    }
    
    func updateRandomHorizontalItem() {
        backgroundQueue.async { [self] in
            backgroundLock.lock()
            var updateIndicies = [Int]()
            for index in verticalItems.indices {
                let randomIndex = Int.random(in: 0..<verticalItems[index].horizontalItems.count)
                let updatedRandomNumber = Int.random(in: 1...100)
                verticalItems[index].horizontalItems[randomIndex].number = updatedRandomNumber
                updateIndicies.append(randomIndex)
            }
            updateRandomCell?(updateIndicies)
            backgroundLock.unlock()
        }
    }
}
