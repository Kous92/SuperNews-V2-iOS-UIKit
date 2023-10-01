# SuperNews iOS V2 UIKit (English)

## Navigation plan
- [A brief history](#story)
- [Technical stack and architecture](#stack)
    + [Technical stack](#technology)
    + [Architecture](#architecture)
    + [Design patterns](#patterns)
    + [Architecture recap](#recap)
- [Important: before trying the iOS app](#important)
- [Features and screenshots](#features)
    + [Top headlines](#topHeadlines)
    + [Source selection for news](#sourceSelection)
    + [News search](#newsSearch)
    + [News map](#map)
    + [Detailed article view](#articleDetail)
    + [User settings](#settings)
- [Unit and UI tests](#testing)

## <a name="story"></a>A brief history

For this personal project which is **SuperNews**, everything starts in **2020**. 

I was doing my end-of-study internship with Capgemini, in Paris, more precisely in Issy-les-Moulineaux. My goal there was to be able to practice into the native iOS development, a job and a technology I've enjoyed immensely, being also a long-time Apple ecosystem enthusiast.

Internally, within the Paris DCX (Digital Customer eXperience) Mobile Factory Business Unit, during with iOS upskilling, one of the internal iOS leads suggested a technical exercise (as a technical test). And the technical test was the following:
- Develop an app that uses the **NewsAPI** REST API to display the articles in a `TableView`. On tap on an article, the article is displayed (`push` transition) in a new screen. This new screen displays the article details.

The goal is to show what we learned to use an API but above all to do so with different architectures, from classic **MVC**, to **MVVM** up to the **Clean Architecture** (**Clean Swift** variant). At the time, I had only carried out this test in **MVC**.

To see this technical test in detail, with my realizations that I redid in February 2023, [click here](https://github.com/Kous92/Test-technique-iOS-2020-Capgemini-Mobile-Factory-DCX-Paris).

**July** comes, in the lockdown of the worldwide **COVID** health crisis that we know, my internship stops here, and I was refused a permanent contract (due to a lack of customer projects and my insufficient technical level). I'm investing in a Mac mini so that I can continue my progress in native iOS despite the morale at his lowest level.

Over the monthes, I'm doing job interviews, almost everytime with IT consulting companies, and here, given my background, is a question I'm asked quite frequently: **Do you have made any personal projects ?**

And that's when it got me thinking about an idea, because there, you really had to pull out all the stops to show something concrete, a complete project, with outstanding features, because yes, a basic **TODO list** interface or only a `TableView` who downloads data from a **REST API**, it won't make the job. You have to go further. But before going further, the challenge here, is to have the server resources to make a concrete project, therefore a **REST API**. In general, it's not cheap when you don't have the financial means, so you're limited in the features you can offer.

We are in **March 2021**, it was then that I remembered what I have done during my end-of-study internship at Capgemini, my technical test. Having kept the subject and my code, so I took the opportunity to consult [NewsAPI documentation](https://newsapi.org) in depth. By consulting the different possible features, I have build my first app with the following features:
- Top headlines of favorite country.
- News search (in different languages)
- News map, my outstanding signature feature, by selecting a country from his marker, to consult the local top headlines of the related country.
- User settings: set the news search language and the country for the favorite top headlines.

On the technical side, I started with the following stack:
- **Xcode 12**, **Swift 5.4**, **UIKit** with **Storyboard**, **MVC** architecture (**UIKit** default one), **MapKit**, **CoreLocation**, **Alamofire** and **Kingfisher** as 3rd party installed framework with **CocoaPods**. For **unit and UI tests**, it's a beginning.

This first version took me 2-3 months to complete, which I then published on **GitHub**. [This old version is consultable here](https://github.com/Kous92/SuperNews-iOS-Swift5/tree/mvc).

Although I've done my utmost to promote this achievement, technically, it's not enough. I had to figure it out during the few (rare) technical tests and reviews I was able to have.

**October 2021**, I lauch the migration phase to **MVVM** architecture, It took me a lot of time to finally understand how to implement this architecture with **UIKit**, I was very lost with all of that things on the Internet. I've redesigned the user interface, I have started to isolate the business logic from the view, and implemented the use of **Combine** for the **data binding** between the **view** and the **ViewModel** (even if **RxSwift** is great for **UIKit** with **MVVM** architecture).

With these improvements, I felt a clear improvement in terms of logic, maintainability and unit tests (better code coverage). But over the time, I felt that I must do even better (on the one hand, because the job market is more and more technically demanding).
I published this new version on **GitHub** in december 2021, [that you can consult here](https://github.com/Kous92/SuperNews-iOS-Swift5/tree/main).

The technical stack was the following:
- **Xcode 13**, **Swift 5.5**, **UIKit** with **Storyboard**, **MVVM** architecture, **Combine**, **MapKit**, **CoreLocation**, **Alamofire** and **Kingfisher** as 3rd party installed framework with  **CocoaPods**, **XCTest** for **Unit and UI tests**.

This project version was for me, **"my loyal ally"** which I presented at every job interview to demonstrate my skills because it's a challenge as a junior to get a job as an iOS developer, very difficult due to actual economic context and customers requirements (IT consulting companies, recruitment offices).

**2022**, I managed to work at **Netgem** and **Withings**, for a 3 month period each. Then, at the end of **2022** and beginning of **2023**, I was committing myself to **"neo IT consulting company"** for recruitement on profile, so with a beggining as soon as a customer mission is won. That's when I became more aware than ever of advanced architectures (**MVP**, **VIPER**, **Clean Swift**, ...), of Software Craftsmanship principles (**KISS**, **DRY**, **YAGNI**, **SOLID**,...), to begin with **SwiftUI**, ...

The market situation was becoming very complicated (my commitment to the company ends here), and with all that I learned, I set myself a challenge, in **april 2023** to remake this app from scratch, but much more improvede: more advanced architecture, application of Software Craftsmanship principles (**KISS**, **DRY**, **YAGNI**, **SOLID**, **design patterns**, ...), but also with new features. Despite low morale (once again) and a break, the goals of this new version was the following:
- To be able to fully benefit advices from experienced/expert developers during code reviews to improve my code, making my app more performant, making better unit tests, ...
- To be in real condition when putting the app in production, first on **TestFlight** and maybe on the **App Store** if there is not too much constraints from the API, or anything else.
- To be confronted with more technical situations that I might encounter in a professional environment (framework migration, UI/UX optimizations, multithreading, production startup, ...).
- To do this same version of this iOS app in **SwiftUI**.
- To feel more and more confident, to be ready to look for a company again and find again a job as an iOS developer, by being better armed (from technical tests until validation of the trial period).

Here, we are in **September 2023**, and I show you my new version of **SuperNews**, that I publish for the first time on **TestFlight** through **App Store Connect**.

Moral: when the market is tight and you need to show recruiters, clients, **iOS leads** and project managers something concrete, personals projects are a good way to show his skills on a project even if this project won't be as complete ad a real project in company the fact that our technical resources are limited. A rich and complete personal project also tells the story behind this achievement

Ideally, is that this realization will be available on the **App Store**, but putting in to **TestFlight** is a big step, because not everyone can invest upfront 99$/year for the **Apple Developer Program** to have access to these resources.

On the next parts, you will have a full project description, at technical level, features and tests.

## <a name="stack"></a>Technical stack and architecture

In this section, I describe in detail the technical solution implemented in this project.
### <a name="technology"></a>Technical stack

Regarding technical stack, meaning the set of frameworks, technologies and tools that are used, here's what I propose below.

**Technology:**

The technical environment is **100% native iOS**, meaning with **<u>Apple's official technologies</u>**:
- **Xcode**: Official IDE for native iOS apps development. First with **Xcode 14** then **Xcode 15**.
- **Swift**: Apple's official programming language, used for every iOS app components. **Used version: 5.9**.

**Tools:**

There is the different tools that I use in this project:
- **Swift Package Manager**: Apple's official tool, a package manager directly integrated with **Swift** and **Xcode**, very useful to install and update 3rd party frameworks like **Alamofire**, **Kingfisher**, **RxSwift**...
- **GitHub**: An online code hosting platform for version control and collaboration with **Git**. It's here where all of the code and file history from the beginning to now.
- **Postman**: Tool to test the **REST APIs (web services)** with the different **HTTP** request than an **API** can propose.
- **App Store Connect**: Apple's official plateform for the management of the release of **iOS** and other Apple platform apps. This platform allows to publish apps on **TestFlight** and the **App Store**. It's through **Xcode** that the apps are archived and uploaded on **App Store Connect**.
- **TestFlight**: Plateform to test easily Apple platform beta version apps providing developers with valuable feedback from testers before publication on the **App Store**.

**Frameworks:**
- **UIKit**: Apple's historical **UI** framework to create native **iOS** application interfaces. This framework allows to build views in an imperative way (especially complex views with advanced animations), through step by step instruction to define a specific task. **UIKit** works through constaints (**Auto Layout**) to position views on screen. There are 3 ways to create views (programmatically, XIB or Storyboard), I choose to do it programmatically.
- **SwiftUI**: Apple's new generation **UI** framework released in 2019, which allows by a declarative way to build and live preview the views, through objects where we describe directly the properties (couleur, positionnement, taille, forme, ...). Here, I use it for live preview part for my views that I have realized with **UIKit** (especially the `ViewController`).
- **Swift Concurrency**: Integrated in **Swift** language since version **5.5**, framework that allows asynchronous tasks management and multithreading with a lighter and easier to read syntax (`async`, `await`, `actor`, `Task`, `@MainActor`)
- **MapKit**: Apple's **UI** allowing to use the iOS interactive map in a custom way (view, interactions,...).
- **Core Location**: Apple's framework for GPS location services.
- **Combine**: Apple's framework for reactive programming (equivalent of **RxSwift**), meaning with asynchronous data flows. The goal is to allow an entity to subscribe to a data stream and react at every event to execute actions. Used here for `data binding` of **MVVM** architecture.
- **XCTest**: Apple's framework for unit and UI tests.
- **SnapKit**: 3rd party framework tiers to for easier management of view constraints (**Auto Layout**). Note: with **SnapKit**, **UIKit** views are only made by code.
- **Kingfisher**: 3rd party framework to download from Internet and cache images in an asynchronous way.
- **Alamofire**: 3rd party framework to use in more elegant way the network requests.
- **AsyncLocationKit**: 3rd party framework to use `CoreLocation` with **Swift Concurrency** (`async/await`) logic instead of `delegate` or **completion handlers**.

My application supports also **localization**, currently in french and english, and I use the new Xcode 15 feature which is **String catalog** (`.xcstrings` format), which is easier to set and use than the older way.

### <a name="architecture"></a>Architecture

For this new version of **SuperNews**, the architecture has been reworked, starting with the **MVVM** version, but this time with a new set of **Software Craftsmanship** principles (design patterns, **Clean Code**, **SOLID**, ...). This base of **MVVM** is now nested in a **Clean Architecture**. Also for the navigation part, `Coordinator` is used, giving the **MVVM-C** variant.

I will describe below the architecture (**Clean Architecture with MVVM-C**) and the patterns that are used into this project.

### The Clean Architecture

The **Clean Architecture**, by Robert C. MARTIN (aka Uncle Bob), is an architecture principle allowing to organize and separate responsibilities in layers. This principle is independent of any technology, platform and also any architecture, indeed, we can use architectures like **MVVM**, **MVP**, **VIP**, **VIPER**,... and nest them in a **Clean Architecture** by applying the layer principles.

The 4 layers are represented in the diagram below by concentric circles running from outside to inside, each one having its responsibility:
- **External (UI or database)**: Visual part of the application or database, depending of the platform and the application.
- **Presentation**: The part which receives the user inputs to execute a specific use case (with or without input data) and also allowing to and also to set up output data in order to notify external layer to update itself with these new data.
- **Use case**: Specific business logicto a use case (REST API network call, fetching date from a database for a UI app, synchronization with a service, ...)
- **Entities**: Data models representing a specific logic. We call also this layer, domain.

Note: depending on platforms and implementations, **use case and entities** may become one for the **domain layer**.

![Clean Architecture Diagram](CleanArchitectureDiagram.jpg)<br>

Thanks of this layer organization, the **Clean Architecture** ensures independence, guaranteeing a flexible code being:
- **Independent of frameworks**: frameworks and 3rd party librairies must be thought as tools, not restrictive frameworks.
- **Independently testable**: tests must be able to be performed without dependencies between parts, and without any dependency to external elements (API, databases, …).
- **Independent of UI**: the UI must be easy to modify.
- **Independent of database**
- **Independent of any service or external system**: In short, the code must be independent of third parties over whom it has no control.


Regarding the relationship between layers, only an external layer can depend of an internal layer, and not the other way around. In addition, each layer is independent, dependency is achieved through abstraction, and not from concrete. The last principle of **SOLID** then applies, **D: Depency Inversion**. This architecture allows to ensure that changes made on the external layers don't have any impact on the internal layers, and thus maintain a stable application during external resources updates, as well as during tests and upgrades (migration of frameworks, databases, ...).

The **Clean Architecture** will facilitate code maintenance and testability (suitable for the implementation of **TDD: Test Driven Development**).

If I've applied the principles of **Clean Architecture** correctly, the migration of my component can be done easier in theory, like as example if I want to switch from **UIKit** to **SwiftUI** (provided that the views are adapted to the architecture components, regarding that **SwiftUI** views are value type views and not reference type with **UIKit** views).

### MVVM architecture (Clean Architecture's presentation layer)

**MVVM** architecture (**Model View ViewModel**) is a design pattern which allow to separate business logic and inputs of the **UI**. This architecture is made up of 3 elements:
- The **Model** represents the different data models of the application.
- The **View** represents the **UI** and the user inputs (tap on a button, text input, ...).
- The **View Model** is the intermediary between the view and the model. Its responsibilities are to react to the user's actions, to manage business logic (here, retrieve data from the model), and format retrieved data and update the view with attributes that the view will display through `data binding`.

In **MVVM**, the view have a reference with the view model, **<u>but not the other way around</u>** (which applies to **MVP** architecture), the view will subscribe to events sent by the view model.

`Data binding` is a link between the view and the view model, where the view through user interactions will send a signal to the view model to run a specific business logic. This signal will allow the update of the data of the model data and thus allow automatic refresh of the view. `Data binding` in iOS can be done with:
- Delegation (not recommended, more suitable for **MVP**, **VIPER**, **Clean Swift (VIP)** architectures)
- Callbacks (closures)
- Functional Reactive Programming (**RxSwift**, **Combine**), the solution I've chosen for this project, with **Combine**..

![MVVMDiagram](MVVMdiagramEnglish.png)<br>

- Main pros:
    + Suitable architecture to separate the view from business logic through a `ViewModel`.
    + `ViewController` lightened.
    + Business logic tests easier to do (Code coverage increased).
    + Suitable with **SwiftUI**, **MVVM** is even the default architecture.
    + Suitable with reactive programming (**RxSwift**, **Combine**).
- Cons:
    + `ViewModel` can be massive if the separation of the elements is not mastered, so it's hard to cut correctly structures, classes and methods in order to respect the 1st principle of **SOLID** being the **SRP: Single Responsibility Principle**. **MVVM-C** alternative with uses a `Coordinator` is useful to lighten the views and manage the navigation between views.
    + May be complex for very small projects.
    + Unsuitable for very large and complex projects, it will be better to switch to **VIPER** or **Clean Architecture (VIP, MVVM, Clean Swift, ...)**. **MVVM** can be integrated inside a **Clean Architecture**, which is the case in this project.
    + Complex mastery for beginners (especially with **UIKit**), mais plus simple avec **SwiftUI** (étant l'architecture "par défaut").

### The MVVM-C variant with Coordinator

Given that having well-decoupled code that respects the first principle of **SOLID (Single Responsibility Principle)** as closely as possible, **MVVM** architecture must be modified given that it does not respect this principle. For that, in addition to isolate the business logic in the domain layer, navigation will be isolated in a dedicated entity called the `Coordinator`. **MVVM** + `Coordinator` = **MVVM-C**.

The `Coordinator` is a pattern which organizes navigation flow logic between different screens (`ViewController`) and which isolates navigation logic from user interface.

The main aim of the `Coordinator` is to make code more modular and easier to test by reducing dependency between the different application components. It allows also to reduce the architecture complexity of the application by dividing the responsibilities of each component.

The `Coordinator` is set up with a class containing methods for displaying the first screen (from `AppDelegate` or `SceneDelegate`), navigate from a screen to an other, and attributes to manages references between different coordinators (as sub-flows). The communication principle between the view and the `Coordinator` is ideally implemented with the `delegate` in order to respect well the 4th and 5th **SOLID** principles, which will allow for example to pass data from a previous view, but also to facilitate testability and maintenance, since the view is decoupled from the `Coordinator`.

The `Coordinator` is one of the possible option to manage the navigation flow and therefore isolate the navigation logic between the views. There is others like `Router`, and **VIPER** architecture is an example which implements this this way of navigation.

We will remember that the `Coordinator` is a flow pattern:
- Manages navigation through streams and sub-streams, relieving the viewer of this responsibility.
- Decouples the different screens for custom navigation, whether during interactions on each screen, or when opening the application with deeplinks.
- Facilitates the testability of application components, as each navigation flow can be tested independently, for example to check that instances are returned or destroyed from unit tests.

But also a pattern which is difficult to learn, to understand and to apply by yourself. It's a pattern that gave me a lot of trouble. You must to be careful when managing references, which can easily cause retention cycles resulting in `memory leaks`.

In this project, we first make sure that each `ViewController` is independent of the others:
- An initializer is set up, it's the `Coordinator` which manages the `ViewController` instantiation with the dedicated `start()` method.
- No navigation interaction (`push`, `present`, `segue`, ...). It's up to the `Coordinator` to manage the navigation.

For each interaction between views, it's the associated `ViewModel` of the `ViewController` which will have a  `weak` reference to the `Coordinator` par through an abstraction with a `delegate`, the strong reference being indirectly from the `Coordinator` to the `ViewController` (which itself have a reference to the `ViewModel`).

### <a name="patterns">Used designs patterns

To set up the **Clean Architecture** and the different **Clean Code** and **SOLID** principles, here are the used different design patterns:
- **Delegation**: Pattern allowing a class to delegate some of it's responsibilities to an other class. It makes easier the communication between classes and emits messages from an object to an other when a specific event is triggered. Used with `Coordinator` (to communicate with the `ViewModel`), **UIKit** views like `TableView`, `CollectionView`, `MKMapView`, `SearchBar`, ...
- **Dependency injection**: Pattern where an object receives other objects Le pattern où un objet reçoit d'autres objets which it depends in a dynamic way in order to avoir a direct dependency between two classes. Dependency injection allows to reduce coupling, having a reusable, testable and maintainable code. Here, dependency injection is performed with an initializer by providing the instance(s) that object needs.
- **`Builder`**: Pattern allowing to initialize complex objects step by step. It allows you to produce different variations or representations of an object using the same construction code. Here in our case, it will be used to create the associated module of the current screen, meaning instantiate a `ViewController` with the dependencies it needs through dependency injections (It can also be adapted for unit tests). A complete layered module based on **Clean Architecture** is built like that:
    + `ViewController` -> `ViewModel` -> `UseCase` -> `Repository` -> `Service`
    + Example below:
```swift
final class TopHeadlinesModuleBuilder: ModuleBuilder {
    private var testMode = false
    
    func buildModule(testMode: Bool, coordinator: ParentCoordinator? = nil) -> UIViewController {
        self.testMode = testMode
        let topHeadlinesViewController = TopHeadlinesViewController()
        
        // Dependency injections
        let dataRepository = getRepository(testMode: testMode)
        let settingsRepository = getSettingsRepository(testMode: testMode)
        let userSettingsRepository = getUserSettingsRepository(testMode: testMode)
        let useCase = TopHeadlinesUseCase(dataRepository: dataRepository, sourceSettingsRepository: settingsRepository, userSettingsRepository: userSettingsRepository)
        let topHeadlinesViewModel = TopHeadlinesViewModel(useCase: useCase)
        topHeadlinesViewModel.coordinator = coordinator as? TopHeadlinesViewControllerDelegate
        
        // ViewModel injection
        topHeadlinesViewController.viewModel = topHeadlinesViewModel
        
        return topHeadlinesViewController
    }
    
    private func getRepository(testMode: Bool) -> SuperNewsRepository {
        return SuperNewsDataRepository(apiService: getDataService(testMode: testMode))
    }
    
    private func getSettingsRepository(testMode: Bool) -> SuperNewsSourceSettingsRepository {
        return SuperNewsSourceUserDefaultsRepository(settingsService: getSettingsService(testMode: testMode))
    }
    
    private func getUserSettingsRepository(testMode: Bool) -> SuperNewsSettingsRepository {
        return SuperNewsUserSettingsRepository(settingsService: getUserSettingsService(testMode: testMode))
    }
    
    private func getDataService(testMode: Bool) -> SuperNewsDataAPIService {
        return testMode ? SuperNewsMockDataAPIService(forceFetchFailure: false) : SuperNewsNetworkAPIService()
    }
    
    private func getSettingsService(testMode: Bool) -> SuperNewsLocalSettings {
        return testMode ? SuperNewsMockLocalSettings() : SuperNewsUserDefaultsLocalSettings()
    }
    
    private func getUserSettingsService(testMode: Bool) -> SuperNewsUserSettings {
        return testMode ? SuperNewsMockCountryLanguageSettings(with: "country") : SuperNewsUserDefaultsCountryLanguageSettings(with: "country")
    }
}
```
- **Coordinator**: The pattern which managing the navigation between screens.
- **DTO (Data Transfer Object)**: The pattern that enables data to be transferred in a more controlled way from the service layer (network, GPS, database, etc.) to the presentation layer and vice versa, in this case via the **Repository**. This is a simple object containing attributes, a `getter`, a `setter` and an initializer from the entities linked to the used service. Conversely, an entity can be created via a DTO (as a query object, for example).
- **Use case:** Pattern which manages business logic (which will order the actions to be performed, such as retrieving data), while remaining independent of any framework. The intermediary here between the `ViewModel` and the `Repository`. In the domain layer of **Clean Architecture** (**Use case + Entities**), entities are **DTO**.
- **Repository:** The pattern acting as an abstraction of external data layers (network, GPS, Bluetooth, databases, files,...). It is therefore a data input and output point, acting as an intermediary between the domain layer and the data layer. The `Repository` knows which service is used to retrieve and send data, but also the entities linked to the data layer. It also converts retrieved data into **DTO** and vice versa during a request.

### <a name="recap"></a>Architecture recap

For the architecture, I will describe you through diagrams how the architecture of my iOS app is built.

**Navigation logic through `Coordinator` below:**

![Coordinators diagram](SuperNewsCoordinatorDiagram.png)

From this logic, here is how a module is built up to form the different layers of **Clean Architecture**:

![Global architecture diagram](GlobalArchitectureDiagramEnglish.png)

Here is how a module is built, initially created by a `Builder`, where dependency injections take place between layers and returning the instantiated `ViewController` from the `Coordinator`:

![Architecture module diagram](ArchitectureModuleDiagramEnglish.png)
## <a name="important"></a>IMPORTANT: BEFORE TRYING THE iOS APP

If you want to test the application directly via **TestFlight**, [please click here from your iPhone/iPad](https://testflight.apple.com/join/SKj6fn5k).

If you want to run the app through Xcode with a build of the project, please read this part below.

The app uses **NewsAPI**'s **REST API**, an API key is required. To do this, get your key from the [NewsAPI website](https://newsapi.org/), in the **Account** section of the account you have created:<br>
![NewsAPI key page](NewsAPIKey.png)<br>

**For security reasons, the apiKey.plist file is not available in the GitHub repo.**.<br>

Once the key has been retrieved, create a **apiKey.plist** file, placing it in the same location in the `DataLayer` folder of the **Xcode** project. Then create a **String** type property with `apiKey` as key, and the API key that you retrieved as value. Take example below:
![NewsAPI plist](NewsApiKeyPlist.png)<br>

Or in the same file, by adding the code in XML format and inserting the API key between the `</string>` markups:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>apiKey</key>
	<string>YOUR API KEY</string>
</dict>
</plist>
```

The key will then be retrieved by the private function below from the `NewsAPIService` class, by reading the contents of the **plist** file created beforehand and initialized from the `SuperNewsNetworkAPIService` constructor.
```swift
final class SuperNewsNetworkAPIService: SuperNewsDataAPIService {
    private var apiKey: String = ""
    
    fileprivate func getApiKey() -> String? {
        guard let path = Bundle.main.path(forResource: "apiKey", ofType: "plist") else {
            print("[SuperNewsNetworkAPIService] ERROR: apiKey.plist file does not exists")
            return nil
        }
        
        guard let dictionary = NSDictionary(contentsOfFile: path) else {
            print("[SuperNewsNetworkAPIService] ERROR: Data not available")
            return nil
        }
        
        return dictionary.object(forKey: "apiKey") as? String
    }
    
    private func getAuthorizationHeader() -> HTTPHeaders {
        return [.authorization(bearerToken: apiKey)]
    }
    
    init() {
        self.apiKey = getApiKey() ?? ""
        ...
    }
}
```

## <a name="features"></a>Features and screenshots

There is the different features that I propose in the **SuperNews** application:
- Top headlines
- Source selection for news
- News search
- News map
- Detailed article view
- User settings

### <a name="topHeadlines"></a>Top headlines

By tapping on **Top headlines** in the bottom navigation bar, the news interface appears like this, with local news downloaded and displayed with their images (by default those for France or United States, the country changes according to the setting chosen).

By tapping on a news item in the list, a view showing details of the article appears, [more details here](#articleDetail).

By using the most of the **NewsAPI**'s REST API, here's a new feature: a horizontal scrolling view (`CollectionView`) will represent the different categories of news:
- Local news according to the country selected in the settings (France or United States by default).
-News from a particular media (your favorite).You can set it by tapping the [button at top left of screen to choose your favorite media](#sourceSelection).
- Business
- Entertainment
- General
- Health
- Science
- Sports
- Technology

These 7 news categories depend on the country selected in the settings, as for local news.

![TopHeadlinesGIF](TopHeadlinesEnglish.gif)

### <a name="sourceSelection"></a>Source selection for news

In this screen, you can choose a favorite news source from among those available. Sources are downloaded the first time and then displayed in a list.

The horizontal scrolling view acts as a filter to sort the list of sources according to 4 options:
- All sources: by default. The list of downloaded sources as is.
- By language: The sources are sorted in each section representing a language, here 14.
- By category: For all languages and countries, sources are sorted in each section of the list: Business, Entertainment, General, Health, Science, Sports, Technology.
- By country: Sources are sorted in each section representing a country, here 54.

For greater ease of use, you can use the search bar to find a source among those available.

Tap on a source, and you'll be redirected to the top headlines screen. The chosen source is saved, and when you select the 2nd cell in the horizontal list, you'll get the news from the selected source.

![SourceSelectionGIF](SourceSelectionEnglish.gif)

### <a name="newsSearch"></a>News search

By tapping on **Search** in the bottom navigation bar, the news interface appears like this.

To search for content, simply touch the search bar and enter the desired content. The search is reactive: each distinct change in the search bar will automatically trigger an HTTP call to the REST API, updating the list if there is content.

The default news language is French or English. Once you've selected a news item, a `ScrollView` appears, displaying the details of the article. The button at the bottom of the view allows you to go to the news source site to read the article in full.<br>

![SearchGIF](SearchNewsEnglish.gif)

### <a name="map"></a>News map

With the possibilities offered by **NewsAPI**, it is therefore possible to retrieve the top headlines from 54 different countries worldwide. Here, I propose an interactive map option, with custom markers appearing on the map representing the countries in question.

With GPS localization, you can center the map on the country closest to your current position (relative to its location on the map).

By selecting **Yes**, the map will be centered on the suggested country. If you are located in one of the 54 countries available, the map will be centered in the same country.

![MapCenteringSuggestionYes](MapCenteringSuggestionYesEnglish.gif)

If you are located in a country that is not one of the 54 countries, the map will be centered on the nearest suggested country, calculated using the **<u>as the crow flies</u>** distances between the current position and the nearest marker.

![MapCenteringSuggestionCountryUnavailable](MapCenteringSuggestionCountryUnavailableEnglish.gif)

By selecting **No**, the map will be centered on your position.

![MapCenteringSuggestionNo](MapCenteringSuggestionNoEnglish.gif)

**Several options are available for markers:**
- With the **clustering** addition, if you zoom out to a higher altitude, the markers will group together into a marker displaying the number of countries in that cluster. Tap on this marker to zoom in on the cluster and reveal the markers in question.
- The button at bottom left allows you to zoom in on the map at an altitude of 15,000 km.
- If you have enabled the localization service, you will see a button in the bottom right-hand corner of the screen (above the `TabBar` at the bottom of the screen) which allows you to center the map on your current position, at an altitude of 10 km.

![MapAnnotations](MapAnnotationsEnglish.gif)

The search bar at the top allows you to center the map on the countries at their respective positions. By touching it, an autocompletion list appears and changes according to the input. For example, if I want to center the map on Japan, I validate my search either by entering the name of the country, or by selecting its cell from the autocompletion list, and this will then center the map on the country and marker in question.<br>

By tapping on the country marker shown on the map, a screen displaying the country's local news will appear. The functionality is similar to that of the top headlines.<br>

![MapCountrySearchAndNews](MapCountrySearchAndNewsEnglish.gif)

### <a name="articleDetail"></a>Detailed article view

When you have selected a news article, a `ScrollView` will appear to display the article details. The button at the bottom of the view allows you to visit the source website of the article to read the full article. The button at the top left of the view allows you to share the link to the article's website (via message, your social networks, AirDrop, etc.).

![ArticleDetailGIF](ArticleDetailEnglish.gif)

### <a name="settings"></a>User settings

For the settings, you can set your favorite news country by selecting **News country** and then selecting the country of your choice from the 54 available options (for example, the United Arab Emirates). Once selected, go to **Top headlines**, and you will see the local news from the United Arab Emirates.<br>

![NewsCountrySettingsFrench](NewsCountrySettingsEnglish.gif)

For the language, you can do the same from the settings by selecting **News language** and then selecting the language of your choice from the 14 available languages (for example, Arabic). With the selected language, go to **Top headlines**, and you will see in the search bar the chosen language (here: Arabic, for example). When you search for content in the selected language, the news will be displayed if there are any available.

![NewsLanguageSettings](NewsLanguageSettingsEnglish.gif)

The last option allows you to reset the settings to the default country and language for the news.

![NewsResetSettings](NewsResetSettingsEnglish.gif)

## <a name="testing"></a>Unit and UI tests

On any iOS application development, like on other platforms, unit and UI tests are essential for checking that the application is working properly before alpha and beta tests from users and his release on the App Store.

In native iOS, we use **XCTest** framework. With the architecture I propose today, a Clean Architecture with MVVM-C, each component is independant in order for easier testing, provided, of course, that you know the right techniques for testing (abstractions, mocks, stubs, spies, ...). Even with the appropriate architecture, the main difficulty is knowing what to test and how to test it.

However, some parts of the application's code remain more difficult to test like `ViewController` as exaemple.

### Unit tests (White box)

Unit tests are **White box** tests where we have visibility on the code, in order to test app features. Unit tests are short and quick tests to run. 
It's also where we can test the different architecture layers by injecting mocks for example. I propose here **94 independent unit tests**.

I don't know all the techniques yet to do better unit tests pour faire de meilleurs tests unitaires, but once I've got the hang of it, code coverage by tests will increase significantly.

These UI tests currently cover **39,9%** of the application code.

![Unit tests coverage](UnitTestsCodeCoverage.png)

### UI automated tests (Black box)

The UI tests are the **black box** tests where we don't have any visibility on the code, but a visibility on the visual interface. For that, **XCTest** uses `XCUIApplication` to allow to simulate interaction of an application in an automatic way, and to check the expected elements exsitence in the interface. 

The app architecture does not matter in UI tests, the most important thing is to test like a lambda user, by targeting the app **UI** components. Compared to unit tests, code coverage is higher, but in return for tests that can take a long time to run.

This is also the part of a corporate project that a team of testers is responsible for, that we call also **QA (Quality Assurance)**, who are involved in setting up automated application tests with external frameworks or tools.

From iOS developer side with **Xcode**, UI tests are performed in the same way as unit tests.

These UI tests currently cover **74%** of the application code.

![UITestsCodeCoverage](UITestsCodeCoverage.png)
### Overall for tests

By running the 114 unit and UI tests, current code coverage is **79%**.

![UnitAndUITestsCodeCoverage](UnitAndUITestsCodeCoverage.png)