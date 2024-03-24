//
//  Stats_MKApp.swift
//  Stats MK
//
//  Created by Pascal Alberti on 17/01/2024.
//

import SwiftUI
import SwiftData
import FirebaseCore
import RxSwift

@main
    struct Stats_MKApp: App {
    
    @ObservedObject var router: Router
    
    //Repositories
    let authRepository: AuthenticationRepository
    let preferencesRepository: PreferencesRepository
    let databaseRepository: DatabaseRepository
    let firebaseRepository: FirebaseRepository
    let fetchUseCase: FetchUseCase
    
    //Screens
    let loginView: LoginView
    let signupView: SignupView
    let warView: WarView
    let profileView: ProfileView
    let registryView: RegistryMenuView
    let statsMenuView: StatsMenuView
    let navigationView: NavigationView
    let currentWarView: CurrentWarView
    let teamListView: TeamListView
    let splashView: SplashScreenView
    let trackListView: TrackListView
    
    
    init() {
        FirebaseApp.configure()
        
        let router = Router()
        let preferences = PreferencesRepository()
        let database = DatabaseRepository()

        let firebase = FirebaseRepository(
            preferences: preferences, 
            database: database
        )
        let auth = AuthenticationRepository(preferencesRepository: preferences)
        
        let fetchUsecase = FetchUseCase(
            firebaseRepository: firebase, 
            preferencesRepository: preferences,
            databaseRepository: database,
            authenticationRepository: auth
        )
        
        self.router = router
        self.authRepository = auth
        self.preferencesRepository = preferences
        self.databaseRepository = database
        self.firebaseRepository = firebase
        self.fetchUseCase = fetchUsecase
        
        let warVM = WarViewModel(
            preferences: preferences,
            database: database,
            firebase: firebase,
            fetch: fetchUsecase
        )
        
        let currentWarVM = CurrentWarViewModel(
            firebaseRepository: firebase,
            databaseRepository: database,
            authenticationRepository: auth,
            preferencesrepository: preferences,
            fetchUseCase: fetchUsecase,
            onBack: { router.navigateBack() }
        )
        
        let teamListVM = TeamListViewModel(databaseRepository: database)
        let splashVM = SplashScreenViewModel(
            onFetchSuccess: { router.navigate(to: .main)},
            authenticationRepository: authRepository,
            preferencesRepository: preferences,
            fetchUseCase: fetchUsecase
        )
        let trackListVM = TrackListViewModel(preferences: preferences, firebase: firebase)
        let subPlayerVM = SubPlayerViewModel(firebase: firebase, database: database, preferences: preferences)
        let penaltyVM = PenaltyViewModel(firebase: firebase, database: database, preferences: preferences)
        
        let loginVM = LoginViewModel(
            onLoginSuccess: { router.navigateToHome() },
            authenticationRepository: authRepository,
            preferencesRepository: preferencesRepository,
            fetchUseCase: fetchUseCase
        )
        let signupVM = SignupViewModel(
            authenticationRepository: auth,
            firebaseRepository: firebase,
            onSignupSuccess: { router.navigateToHome() }
        )
        
        //Screens
        self.loginView = LoginView(
            viewModel: loginVM,
            onSignupClick: { router.navigate(to: .signup) }
        )
        self.signupView = SignupView(
            viewModel: signupVM,
            onLoginClick: { router.navigateBack() }
        )
        self.profileView =  ProfileView(
            onBack: { router.navigateBack() },
            onLogout: { router.navigateToRoot() },
            viewModel: ProfileViewModel(authenticationRepository: auth, databaseRepository: database)
        )
        self.registryView = RegistryMenuView(
            onProfileClick: { router.navigate(to: .profile) }
        )
        self.warView = WarView(
            viewModel: warVM,
            onWarClick: { id in router.navigate(to: .warDetails(warId: id)) },
            onCurrentWarClick: { router.navigate(to: .currentWar)},
            onCreateWarClick: { router.navigate(to: .teamList)  }
        )
        self.statsMenuView = StatsMenuView()
        self.navigationView = NavigationView(
            registryView: registryView,
            warView: warView,
            statsMenuView: statsMenuView
        )
        self.currentWarView = CurrentWarView(
            viewModel: currentWarVM,
            subViewModel: subPlayerVM,
            penaltyViewModel: penaltyVM,
            onBack: { router.navigateBack() },
            onTrackClick: { warId, trackId, trackIndex, warTrackIndex in router.navigate(to: .trackDetails(warId: warId, trackId: trackId, trackIndex: trackIndex, warTrackIndex: warTrackIndex))},
            onNextTrackClick: { router.navigate(to: .trackList) },
            onWarFinish: { router.navigateToHome() }
        )
        self.teamListView = TeamListView(
            viewModel: teamListVM,
            onBack: { router.navigateToHome() },
            onTeamClick: { teamId in router.navigate(to: .playersList(teamId: teamId))}
        )
        self.splashView = SplashScreenView(
            viewModel: splashVM
        )
        self.trackListView = TrackListView(
            viewModel: trackListVM,
            warTrackIndex: nil,
            onBack: { router.navigateBack() },
            onTrackSelected: { map in router.navigate(to: .positions(trackIndex: map.trackIndex))}
        )

    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.navPath) {
                if authRepository.user == nil {
                    loginView
                        .navigationDestination(for: Router.Destination.self) { destination in
                            switch (destination) {
                            case .signup: signupView
                            case .main: navigationView
                            case .profile: profileView
                            case .login: loginView
                            case .currentWar: currentWarView
                            case .teamList: teamListView
                            case .trackList: trackListView
                            case let .warDetails(warId): WarDetailsView(
                                viewModel: WarDetailsViewModel(
                                    databaseRepository: databaseRepository,
                                    warId: warId
                                ),
                                onBack: { router.navigateBack() },
                                onTrackClick: { warId, trackId in router.navigate(to: .trackDetails(warId: warId, trackId: trackId, trackIndex: nil, warTrackIndex: nil))}
                                
                            )
                            case let .trackDetails(warId, trackId, trackIndex, warTrackIndex): TrackDetailsView(
                                viewModel: TrackDetailsViewModel(
                                    databaseRepository: databaseRepository,
                                    preferencesRepository: preferencesRepository,
                                    warId: warId,
                                    trackId: trackId,
                                    trackIndex: trackIndex
                                ),
                                trackListViewModel: TrackListViewModel(preferences: preferencesRepository, firebase: firebaseRepository),
                                positionViewModel: PositionViewModel(
                                    preferences: preferencesRepository,
                                    database: databaseRepository,
                                    firebase: firebaseRepository,
                                    trackIndex: trackIndex ?? 0,
                                    warTrackIndex: warTrackIndex,
                                    goToResult: { _ in }
                                ),
                                warTrackResultViewModel: WarTrackResultViewModel(
                                    preferences: preferencesRepository,
                                    database: databaseRepository,
                                    firebase: firebaseRepository,
                                    trackIndex: warTrackIndex ?? 0
                                ),
                                onBack: { router.navigateBack() }
                            )
                            case let .playersList(teamId): PlayersListView(
                                viewModel: PlayersListViewModel(
                                    database: databaseRepository,
                                    preferences: preferencesRepository,
                                    firebase: firebaseRepository,
                                    fetch: fetchUseCase,
                                    teamId: teamId
                                ),
                                onBack: { router.navigateBack() }, onWarCreated: {
                                    router.navigateToHome()
                                    router.navigate(to: .currentWar)
                                })
                            case let .positions(trackIndex): PositionView(
                                viewModel: PositionViewModel(
                                    preferences: preferencesRepository,
                                    database: databaseRepository,
                                    firebase: firebaseRepository,
                                    trackIndex: trackIndex,
                                    warTrackIndex: nil,
                                    goToResult: { trackIndex in router.navigate(to: .warTrackResult(trackIndex: trackIndex)) }
                                ),
                                onBack: { router.navigateBack()},
                                onTrackEdited: {}
                            )
                            case let .warTrackResult(trackIndex): WarTrackResultView(
                                viewModel: WarTrackResultViewModel(
                                    preferences: preferencesRepository,
                                    database: databaseRepository,
                                    firebase: firebaseRepository,
                                    trackIndex: nil
                                ),
                                onBack: { router.navigateBack() },
                                onValidate: {
                                    router.navigateBack()
                                    router.navigateBack()
                                    router.navigateBack()
                                }
                            
                            )
                                
                            default: Spacer()
                            }
                        }
                } else {
                    splashView
                        .navigationDestination(for: Router.Destination.self) { destination in
                            switch (destination) {
                            case .signup: signupView
                            case .main: navigationView
                            case .profile: profileView
                            case .login: loginView
                            case .currentWar: currentWarView
                            case .teamList: teamListView
                            case .trackList: trackListView
                            case let .warDetails(warId): WarDetailsView(
                                viewModel: WarDetailsViewModel(
                                    databaseRepository: databaseRepository,
                                    warId: warId
                                ),
                                onBack: { router.navigateBack() },
                                onTrackClick: { warId, trackId in router.navigate(to: .trackDetails(warId: warId, trackId: trackId, trackIndex: nil, warTrackIndex: nil))}
                            )
                            case let .trackDetails(warId, trackId, trackIndex, warTrackIndex): TrackDetailsView(
                                viewModel: TrackDetailsViewModel(
                                    databaseRepository: databaseRepository,
                                    preferencesRepository: preferencesRepository,
                                    warId: warId,
                                    trackId: trackId,
                                    trackIndex: trackIndex
                                ),
                                trackListViewModel: TrackListViewModel(preferences: preferencesRepository, firebase: firebaseRepository),
                                positionViewModel: PositionViewModel(
                                    preferences: preferencesRepository,
                                    database: databaseRepository,
                                    firebase: firebaseRepository,
                                    trackIndex: trackIndex ?? 0,
                                    warTrackIndex: warTrackIndex,
                                    goToResult: { _ in }
                                ),
                                warTrackResultViewModel : WarTrackResultViewModel(
                                    preferences: preferencesRepository,
                                    database: databaseRepository,
                                    firebase: firebaseRepository,
                                    trackIndex: warTrackIndex ?? 0
                                ),
                                onBack: { router.navigateBack() }
                            )
                                
                            case let .playersList(teamId): PlayersListView(
                                viewModel: PlayersListViewModel(
                                    database: databaseRepository,
                                    preferences: preferencesRepository,
                                    firebase: firebaseRepository,
                                    fetch: fetchUseCase,
                                    teamId: teamId
                                ),
                                onBack: { router.navigateBack() },
                                onWarCreated: {
                                    router.navigateToHome()
                                    router.navigate(to: .currentWar)
                                }
                            )
                            case let .positions(trackIndex): PositionView(
                                viewModel: PositionViewModel(
                                    preferences: preferencesRepository,
                                    database: databaseRepository,
                                    firebase: firebaseRepository,
                                    trackIndex: trackIndex,
                                    warTrackIndex: nil,
                                    goToResult: { trackIndex in router.navigate(to: .warTrackResult(trackIndex: trackIndex)) }
                                ),
                                onBack: { router.navigateBack()},
                                onTrackEdited: {}
                            )
                            case let .warTrackResult(trackIndex): WarTrackResultView(
                                viewModel: WarTrackResultViewModel(
                                    preferences: preferencesRepository,
                                    database: databaseRepository,
                                    firebase: firebaseRepository,
                                    trackIndex: nil
                                ),
                                onBack: { router.navigateBack() },
                                onValidate: { 
                                    router.navigateBack()
                                    router.navigateBack()
                                    router.navigateBack()
                                }
                            
                            )
                                
                            default: Spacer()
                            }
                        }
                }
            }
            .environmentObject(router)
        }
    }
}
