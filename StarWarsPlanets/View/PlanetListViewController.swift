//
//  PlanetListViewController.swift
//  SyscoAssignment
//
//  Created by Mithsen on 2022-05-27.
//

import RxCocoa
import RxSwift
import UIKit

final class PlanetListViewController: UIViewController {
    
    private let viewModel = PlanetListViewModel()
    private var router = PlanetListRouter()
    private let disposeBag = DisposeBag()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: UITableViewCell.description())
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        tableView.refreshControl = refreshControl
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableFooterView = UIView(frame: .zero)
        return tableView
    }()
    
    private lazy var footerView: UIView = {
        let view = UIView(frame: CGRect(
                            x: 0,
                            y: 0,
                            width: view.frame.size.width,
                            height: 100)
        )
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        return refreshControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        layout()
        bind()
        configureTableView()
        refreshControl.addTarget(self, action: #selector(refreshControlTriggered), for: .valueChanged)
    }
    private func configureNavBar() {
      navigationItem.title = "PLANETS"
    }
    
    private func layout() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
        ])
    }

    private func bind() {
        tableViewBind()
        
        viewModel.bind(view: self, router: router)
        
        viewModel.isLoadingSpinnerAvaliable.subscribe { [weak self] spiningType in
            guard let spiningType = spiningType.element,
                  let self = self else { return }
            
            switch spiningType {
            case .main:
                self.view.showSpinner()
            case .footer:
//                self.tableView.tableFooterView = self.viewSpinner
                self.tableView.tableFooterView = self.footerView
                self.tableView.tableFooterView!.showSpinner()
            case .none:
                self.tableView.tableFooterView = UIView(frame: .zero)
                self.view.removeSpinner()
                self.tableView.tableFooterView!.removeSpinner()
            }
        }
        .disposed(by: disposeBag)

        viewModel.refreshControlCompelted.subscribe { [weak self] _ in
            guard let self = self else { return }
            self.refreshControl.endRefreshing()
        }
        .disposed(by: disposeBag)
    }

    private func configureTableView() {
      let nibName = Constants.PlanetCellKeys.nibName.rawValue
      let reuseIdentifier = Constants.PlanetCellKeys.reuseIdentifier.rawValue
      tableView.rowHeight = UITableView.automaticDimension
      tableView.register(UINib(nibName: nibName, bundle: Bundle.main), forCellReuseIdentifier: reuseIdentifier)
    }

    private func tableViewBind() {
        viewModel.items.bind(to: tableView.rx.items) { tableView, _, item in
            let cellIdentifier: String = Constants.PlanetCellKeys.reuseIdentifier.rawValue
            guard let cell = tableView
                .dequeueReusableCell(withIdentifier: cellIdentifier) as? PlanetTableViewCell else {
              fatalError("Error dequing cell: \(cellIdentifier)")
            }
            cell.planetDetail = item
            return cell
        }
        .disposed(by: disposeBag)
        
        // Bind a model selected handler
        tableView.rx.modelSelected(PlanetDetail.self).bind { planet in
            print(planet.name ?? "")
            self.router.naviagteToDetailView(planetDetail: planet)
        }.disposed(by: disposeBag)
        
        
        tableView.rx.didScroll.subscribe { [weak self] _ in
            guard let self = self else { return }
            let offSetY = self.tableView.contentOffset.y
            let contentHeight = self.tableView.contentSize.height

            if offSetY > (contentHeight - self.tableView.frame.size.height - 100) {
                self.viewModel.fetchMoreDatas.onNext(())
            }
        }
        .disposed(by: disposeBag)
    }
    
    @objc private func refreshControlTriggered() {
        viewModel.refreshControlAction.onNext(())
    }
}
