////
////  ViewController.swift
////  test-omg
////
////  Created by Olesya Khurmuzakiy on 11.03.2024.
////
//
import UIKit

class ViewController: UIViewController {

    private let cellReuseIdentifier = "horizontalCell"
    private var updateTimer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)

        updateTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateVisibleCells), userInfo: nil, repeats: true)
    }

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds)
        tableView.dataSource = self
        tableView.register(HorizontalStackCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        view.addSubview(tableView)
        return tableView
    }()

    private func createLabel(withText text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textAlignment = .center
        label.backgroundColor = .quaternaryLabel
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        label.widthAnchor.constraint(equalToConstant: 50).isActive = true
        label.heightAnchor.constraint(equalToConstant: 50).isActive = true
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(labelTapped)))
        return label
    }

    @objc private func labelTapped(_ sender: UITapGestureRecognizer) {
        guard let label = sender.view as? UILabel else { return }

        UIView.animate(withDuration: 0.5, animations: {
            let scaleFactor: CGFloat = 0.8
            label.transform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
        }) { _ in
            UIView.animate(withDuration: 0.5, animations: {
                label.transform = CGAffineTransform.identity
            })
        }
    }

    @objc private func updateVisibleCells() {
        guard let visibleCells = tableView.visibleCells as? [HorizontalStackCell] else {
            return
        }
        for cell in visibleCells {
            let visibleSubViews = cell.stackView.subviews.filter { subview in
                let subviewFrameInSuperview = subview.convert(subview.bounds, to: tableView)
                return tableView.bounds.intersects(subviewFrameInSuperview)
            }
            if let randomSubview = visibleSubViews.randomElement() as? UILabel {
                randomSubview.text = "\(Int.random(in: 0...100))"
            }
        }
    }
}

extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let physicalMemory = ProcessInfo.processInfo.physicalMemory
        let availableRows = Int(physicalMemory) / (4 * 1024)
        let numRows = min(Int.max, availableRows)
        
        return Int.random(in: 100...numRows)
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as? HorizontalStackCell ?? HorizontalStackCell(style: .default, reuseIdentifier: cellReuseIdentifier)

        cell.stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for _ in 0..<Int.random(in: 11...20) {
            let label = createLabel(withText: "\(Int.random(in: 0...100))")
            cell.stackView.addArrangedSubview(label)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
}
