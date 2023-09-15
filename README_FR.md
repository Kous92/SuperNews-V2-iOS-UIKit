# SuperNews iOS V2 UIKit (Français)

## Plan de navigation
- [Un peu d'histoire](#story)
- [Stack technique et architecture](#stack)
- [Important: avant d'essayer l'appli iOS](#important)
- [Fonctionnalités et captures d'écrans](#features)
    + [News et recherches](#news)
    + [Carte des news](#newsmap)
    + [Paramètres langue et pays des news](#settings)
- [Tests unitaires et UI](#testing)

## <a name="story"></a>Un peu d'histoire

Pour ce projet personnel qu'est **SuperNews**, tout commence en **2020**. 

J'étais en stage de fin d'études au sein de Capgemini, à Paris, plus précisément à Issy-les-Moulineaux. Mon objectif là-bas était de pouvoir pratiquer dans le dévéloppement iOS natif, un métier et une technologie que j'ai énormément apprécié, étant aussi un passionné de l'écosystème Apple depuis longtemps.

En interne, au sein de la Mobile Factory de la Business Unit DCX (Digital Customer eXperience) Paris, lors de mon upskilling iOS, l'un des leads iOS internes m'a proposé un exercice technique (sous forme de test technique). Et le test technique était le suivant:
- Développer une application qui exploite l'API REST NewsAPI en affichant les articles dans une `TableView`. Au clic sur un article, l’article est affiché (transition `push`) dans un nouvel écran. Ce nouvel écran affiche les détails de l'article.

Le but est donc de montrer ce qu'on a appris pour exploiter une API mais surtout de pouvoir le faire avec différentes architectures, du **MVC** classique, au **MVVM** jusqu'à la **Clean Architecture** (la variante **Clean Swift**). À l'époque, je n'avais réalisé ce test qu'en **MVC**.

Pour voir le test technique en détail, avec mes réalisations que j'ai refait en février 2023, [cliquez ici](https://github.com/Kous92/Test-technique-iOS-2020-Capgemini-Mobile-Factory-DCX-Paris).

**Juillet 2020** arrive, en plein confinement lié à la crise sanitaire mondiale du **COVID** que nous connaissons tous, mon stage s'arrête, et le CDI m'a été refusé (faute de projets clients mais aussi de mon niveau technique insuffisant). J'investis dans un Mac mini pour pouvoir continuer ma progression en iOS natif malgré le moral au plus bas.

Au fil des mois, je passe des entretiens, quasiment tout le temps avec des ESN, et là, au vu de mon parcours, il y a une question qu'on me pose assez fréquemment: **Avez-vous réalisé des projets personnels ?**

Et c'est là que ça m'a fait réfléchir à une idée, car là, il fallait vraiment tout mettre en œuvre pour montrer du concret, un projet complet, avec des fonctionnalités sortant du lot, car oui, une simple interface de type **TODO list** où juste un `TableView` récupérant des données d'une **API REST**, ça ne fera pas son effet. Il faut aller plus loin. Mais avant d'aller plus loin, le challenge ici, c'est d'avoir les ressources serveur pour faire un projet concret, donc une API REST. En général, ce n'est pas donné quand on n'a pas de moyens financiers conséquents, on se retrouve donc limité pour proposer des fonctionnalités.

On est en **mars 2021**, c'est alors que je me remémore ce que j'avais réalisé lors de mon stage de fin d'études chez Capgemini, mon test technique. Ayant gardé le sujet et mon code, j'en ai donc profité pour aller consulter en profondeur la [documentation de NewsAPI](https://newsapi.org). En consultant les différentes features possibles, j'ai donc matérialisé ma première appli avec les features suivantes:
- Actualités du pays favori
- Recherche de news (dans différentes langues possibles)
- Carte des news, ma fonctionnalité signature qui sort du lot, en sélectionnant un pays via son marqueur, de consulter les actualités locales du pays en question.
- Paramètres utilisateur: définir la langue de recherche d'actualités et le pays pour les actualités en favori.

Au niveau technique, j'ai d'abord commencé avec la stack suivante:
- **Xcode 12**, **Swift 5.4**, **UIKit** avec **Storyboard**, l'architecture **MVC** (par défaut sur **UIKit**), **MapKit**, **CoreLocation**, **Alamofire** et **Kingfisher** comme frameworks tiers installés avec **CocoaPods**. Niveau **tests unitaires** et **UI**, c'est un début.

Cette première version m'a pris 2-3 mois pour la réaliser, que j'ai ensuite publié sur **GitHub**. [Cette ancienne version est consultable ici](https://github.com/Kous92/SuperNews-iOS-Swift5/tree/mvc).

Bien que j'ai tout fait pour mettre en avant cette réalisation, techniquement, ça ne suffit pas. Il m'aura fallu le comprendre lors des rares tests techniques et reviews que j'ai pu avoir.

**Octobre 2021**, je lance donc la phase de migration vers l'architecture **MVVM**, ça m'avait pris beaucoup de temps pour enfin comprendre comment implémenter cette architecture avec **UIKit**, je m'étais beaucoup perdu avec tout ce qu'il y avait sur Internet. J'ai retravaillé l'interface utilisateur, j'ai commencé à séparer la logique métier de la vue, et mis en place l'utilisation de **Combine** pour le **data binding** entre la vue et la vue modèle (même si **RxSwift** est au top pour **UIKit** en architecture **MVVM**).

Avec ces améliorations, j'ai senti un net progrès que ce soit pour la logique, la maintenabilité et les tests unitaires (meilleure couverture du code). Mais au fil du temps, j'ai senti que je pouvais faire encore mieux.
Je publie donc cette nouvelle version sur GitHub en décembre 2021, [que vous pouvez consulter ici](https://github.com/Kous92/SuperNews-iOS-Swift5/tree/main).

La stack technique était alors la suivante:
- **Xcode 13**, **Swift 5.5**, **UIKit** avec **Storyboard**, l'architecture **MVVM**, **Combine**, **MapKit**, **CoreLocation**, **Alamofire** et **Kingfisher** comme frameworks tiers installés avec **CocoaPods**, **XCTest** pour les **tests unitaires** et **UI**.

Cette version du projet était pour moi **"mon fidèle allié"** que je présentais à chaque entretien pour montrer mes compétences car c'est un challenge en tant que junior de décrocher un poste de développeur iOS, chose très difficile en raison du contexte économique, des exigences des clients finaux (ESN, cabinets de recrutement).

**2022**, je parviens à travailler chez **Netgem** et **Withings**, pour une période de 3 mois chacune. Ensuite, fin **2022** et début **2023**, je m'engageais dans une **"néo-société de conseil"** pour un recrutement sur profil, donc avec une date de démarrage dès qu'une mission client est gagnée. C'est là que je me suis sensibilisé plus que jamais aux architectures avancées, aux principes du Software Craftsmanship (**KISS**, **DRY**, **YAGNI**, **SOLID**,...), de commencer sur **SwiftUI**, ...

La situation au niveau du marché devenait très compliquée (mon engagement avec l'entreprise prend fin), et avec tout ce que j'ai appris, je me suis lancé comme défi, en **avril 2023** de refaire de zéro cette appli mais en nettement plus améliorée: architecture plus avancée, application des principes du Software Craftsmanship (**KISS**, **DRY**, **YAGNI**, **SOLID**, **design patterns**, ...), mais aussi avec de nouvelles fonctionnalités. Malgré un moral en berne (une nouvelle fois) et une pause, les objectifs de cette nouvelle version sont les suivants:
- De pouvoir pleinement bénéficier de conseils de développeurs expérimentés/experts lors de code reviews pour améliorer mon code, rendre mon app plus performante, faire de meilleurs tests unitaires, ...
- D'être en condition réelle lors d'une mise en production, d'abord sur **TestFlight** et peut être sur l'**App Store** s'il n'y a pas de contraintes au niveau API.
- D'être confronté à davantage de situations techniques que je pourrais rencontrer en milieu professionnel (migration de frameworks, optimisations UI/UX, multithreading, mise en production,...).
- De faire la même version de cette appli iOS en **SwiftUI**.
- De me sentir de plus en plus en confiance.

Là, nous sommes en **Septembre 2023**, et je vous présente donc ma nouvelle version de **SuperNews**, que je publie donc pour la première fois sur **TestFlight** via **App Store Connect**.

Moralité, lorsque le marché est tendu et qu'il faut montrer du concret aux recruteurs, clients, leads **iOS** et chefs de projets, les projets personnels sont un bon moyen de montrer ses compétences dans un projet même si ce projet ne sera pas aussi complet qu'un projet réel en entreprise du fait que nos ressources techniques soit limitées. Un projet personnel riche et complet raconte donc aussi une histoire derrière cette réalisation.

L'idéal est que cette réalisation puisse arriver sur l'**App Store**, mais déjà le mettre sur **TestFlight** est un grand pas, car ce n'est pas tout le monde qui peut d'entrée investir 99€/an pour l'**Apple Developer Program** pour avoir accès à ces ressources.

Dans les parties suivantes, vous aurez un descriptif complet du projet, au niveau technique, fonctionnalités, tests, mise en production, ...

## <a name="stack"></a>Stack technique et architecture