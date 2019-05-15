//
//  TeamDetailViewModel.swift
//  SportsApp
//
//  Created by Felipe Correa on 11/24/18.
//  Copyright (c) 2018 Test CondorLabs LTD. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

struct TeamDetailViewInfo {
    var name: String?
    var founded: String?
    var description: String?
    var stadiumName: String?
    var stadiumImageUrl: String?
    var jersey: String?
    var jerseyImageUrl: String?
}

struct FooterInfo {
    let title: String
    let detail: String
    let moreInfo: Bool
}

protocol TeamDetailViewOutput {
    func configure(input: TeamDetailViewModel.Input) -> TeamDetailViewModel.Output
    func footerTablewDataSource() -> RxTableViewSectionedReloadDataSource<SectionModel<String, FooterInfo>>
}

struct NextEvent {
    let title: String?
    let matchDate: String?
}

class TeamDetailViewModel: RxViewModelType, RxViewModelModuleType, TeamDetailViewOutput {
    
    typealias FooterSection = SectionModel<String, FooterInfo>
    
    // MARK: In/Out struct
    struct InputDependencies {
        weak var coordinator: TeamDetailCoordinatorType?
        let teamServices: TeamServicesInput
    }
    
    struct Input {
        let appearState: Observable<ViewAppearState>
        let footerItemDidSelectedAtIndex: Driver<IndexPath>
    }
    
    struct Output {
        let title: Observable<String?>
        let state: Observable<ModelState>
        let viewInfo: Observable<TeamDetailViewInfo?>
        let footerSections: Observable<[FooterSection]>
    }
    
    // MARK: Dependencies
    private let dep: InputDependencies
    private let moduleInputData: ModuleInputData
    
    // MARK: Properties
    private let bag = DisposeBag()
    private let modelState: RxViewModelStateProtocol = RxViewModelState()
    
    private let viewInfoUpdated = BehaviorRelay<TeamDetailViewInfo?>(value: nil)
    private let availableSocialNetworks = BehaviorRelay<[SocialNetwork]>(value: [])
    private let nextEvents = BehaviorRelay<[Event]>(value: [])
    private let sections = BehaviorRelay<[FooterSection]>(value: [])
    // MARK: Observables
    private let title = BehaviorRelay<String?>(value: nil)
    private let outputModuleAction = PublishSubject<OutputModuleActionType>()
    
    // MARK: - initializer
    
    init(dependencies: InputDependencies, moduleInputData: ModuleInputData) {
        self.dep = dependencies
        self.moduleInputData = moduleInputData
        self.prepareViewInfo(with: moduleInputData.team)
        self.title.accept(moduleInputData.team.name)
        guard let teamId = moduleInputData.team.teamId else { return }
        
        //get events
        dependencies.teamServices.getNextFiveEvents(of: teamId) { (events, _) in
            if events != nil {
                self.nextEvents.accept(events!)
                self.updateSections()
            }
        }
    }
    
    // MARK: - TeamDetailViewOutput
    
    func configure(input: Input) -> Output {
        // Configure input
        input.appearState.subscribe(onNext: { _ in
            // .didLoad and etc
        }).disposed(by: bag)
        
        input.footerItemDidSelectedAtIndex
            .drive(onNext: { [unowned self] (indexPath) in
                self.footerItemDidSelectedAtIndex(indexPath: indexPath)
            }).disposed(by: bag)
        
        // Configure output
        return Output(
            title: title.asObservable(),
            state: modelState.state.asObservable(),
            viewInfo: viewInfoUpdated.asObservable(),
            footerSections: sections.asObservable()
        )
    }
    
    // MARK: - Module configuration
    
    func configureModule(input: ModuleInput?) -> ModuleOutput {
        // Configure input signals
        
        // Configure module output
        return ModuleOutput(
            moduleAction: outputModuleAction.asObservable()
        )
    }
    
    private func footerItemDidSelectedAtIndex(indexPath: IndexPath) {
        switch indexPath.section {
        case 1: // Social Network did selected
            let socialNwk = availableSocialNetworks.value[indexPath.row]
            self.dep.coordinator?.presentWebView(page: socialNwk.url)
        default:
            break
        }
    }
    
    // MARK: - Additional
    
    deinit {
        print("-- TeamDetailViewModel dead")
    }
}

extension TeamDetailViewModel {
    private func prepareViewInfo(with team: Team) {
        //swiftlint:disable line_length
        let info = TeamDetailViewInfo(name: team.name,
                                      founded: "\(NSLocalizedString("DETAIL_SINCE", comment: "")) \(team.formedYear ?? "N/A")",
                                      description: team.teamDescriptionEN,
                                      stadiumName: team.stadium,
                                      stadiumImageUrl: team.stadiumThumb,
                                      jersey: "\(NSLocalizedString("DETAIL_CURRENT_JERSEY", comment: ""))",
                                      jerseyImageUrl: team.jerse)
        self.viewInfoUpdated.accept(info)
        
        self.availableSocialNetworks.accept(team.socialNetworks)
        updateSections()
    }
    
    private func prepareSocialNetworkSection(with list: [SocialNetwork]) -> [FooterInfo] {
        let socialNetworks = list.map { (socialNetwork) -> FooterInfo in
            let info = FooterInfo(title: socialNetwork.type.rawValue + ":",
                                  detail: socialNetwork.url,
                                  moreInfo: true )
            return info
        }
        return socialNetworks
    }
    
    private func prepareNextEvents(with events: [Event]) -> [FooterInfo] {
       
        let wrapper = events.map { (event) -> FooterInfo in
            var date = NSLocalizedString("DETAIL_DATE", comment: "") + " "
            if let startDate = event.startDate, let startTime = event.startTime {
                date += startDate + ", " + startTime
            } else {
                date += "N/A"
            }
            let info = FooterInfo(title: event.name! + ":",
                                  detail: date,
                                  moreInfo: false )
            return info
        }
        return wrapper
    }
    
    private func updateSections() {
        let events = self.prepareNextEvents(with: self.nextEvents.value)
        let socialN = self.prepareSocialNetworkSection(with: self.availableSocialNetworks.value)
        let section = FooterSection(model: NSLocalizedString("DETAIL_NEXT_FIVE_EVENTS", comment: ""), items: events)
        let section2 = FooterSection(model: NSLocalizedString("DETAIL_SOCIAL_NETWORKS", comment: ""), items: socialN)
        self.sections.accept([section, section2])
    }
}

extension TeamDetailViewModel {
    private func tableViewDataSourceUI() -> TableViewSectionedDataSource<FooterSection>.ConfigureCell {
        return { (dataSource, tableView, indexPath, item) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel?.text = item.title
            cell.detailTextLabel?.text = item.detail
            cell.accessoryType = item.moreInfo ? .disclosureIndicator : .none
            return cell
        }
    }
    
    func footerTablewDataSource() -> RxTableViewSectionedReloadDataSource<FooterSection> {
        let dataSource = RxTableViewSectionedReloadDataSource<FooterSection>(configureCell: tableViewDataSourceUI())
        dataSource.titleForHeaderInSection = { dataS, index in
            return dataS.sectionModels[index].model
        }
        return dataSource
    }
}
