# 🍺 BrewMatch  
### Choisir sa bière artisanale sans tracas  

---

## 🧭 Présentation du projet

**BrewMatch** est une application mobile développée avec **Flutter** et **Firebase**, destinée aux **bars, brasseries artisanales et brewpubs**.  
Elle permet aux tenanciers de **gérer leur catalogue de bières** et de le **mettre à disposition des clients** via une interface tactile intuitive (tablette ou iPad).  

Les clients peuvent **filtrer les bières selon leurs goûts** (amertume, sucre, alcool, effervescence) et découvrir des suggestions adaptées à leur profil.  

> 🎯 Objectif : simplifier la découverte de bières artisanales et améliorer l’expérience client dans les bars et brasseries.  

---

## ⚙️ Fonctionnalités

### ✅ **MVP (Minimum Viable Product)**
- Filtrage des bières selon les **préférences gustatives**
- Consultation d’une **fiche détaillée** pour chaque bière  
- **Gestion du catalogue (CRUD)** : formulaires admin (bières & ingrédients) branchés sur **Firestore**  
- **Interface client et admin** sur un seul appareil (iPad du bar)  
- **Authentification sécurisée** via Firebase Auth + **verrou secondaire** (reauth obligatoire pour entrer dans l’admin)  
- **Localisation FR/EN** (critère obligatoire d’évaluation)  

### 💡 **NiceToHave (phase 2)**
- Statistiques et tendances clients (préférences moyennes et bières les plus choisies)  
- Traduction multilingue du contenu (bières, ingrédients)  
- Module **Alcotest & conduite responsable** (*Easter Egg éducatif*)  

---

## 🧩 Stack technique

- **Framework** : Flutter (Dart)  
- **Base de données** : Firebase Firestore  
- **Auth & sécurité** : Firebase Authentication  
- **Stockage d’images** : Firebase Storage  
- **Localisation** : `flutter_localizations` + `intl`  
- **UI/Animations** : `flutter_animate`, `animations`, `rive`  

---

## 🏗️ Architecture du projet Flutter

```plaintext
/lib
  main.dart
  core/
    navigation/         # RootApp (GoRouter), transitions
    state/              # AppState (mode client/admin, auto-lock)
    models/             # beer.dart, ingredient.dart, taste_profile.dart, ...
    services/           # auth_service.dart, firestore_service.dart,
                        # admin_catalog_repository.dart, localized_text.dart
    widgets/            # composants partagés (detail cards, lists, etc.)
  screens/
    client/             # home_screen.dart, beer_detail_screen.dart, ...
    admin/              # dashboard, forms, lists, unlock/login, settings
    alcotest_screen.dart
  firebase_options.dart
  l10n/
  themes/
```

**Features clefs**
- `/screens/client` : interface publique (filtres, fiches bières, navigation GoRouter).
- `/screens/admin` : accès sécurisé (unlock → dashboard → formulaires Firestore).
- `core/services/admin_catalog_repository.dart` centralise les CRUD bières/ingrédients.
- `core/state/app_state.dart` gère le mode, le verrou secondaire et l’auto-verrouillage.

---

## 🧱 Organisation du développement

Le projet est géré selon une approche **Agile**, avec un suivi des **EPICs** et **User Stories** sur GitHub Projects.

| EPIC | Objectif principal |
|------|---------------------|
| **EPIC 01** | Choisir une bière à son goût |
| **EPIC 02** | Gestion du catalogue (admin) |
| **EPIC 03** | Alcotest & conduite responsable *(NiceToHave)* |
| **EPIC 04** | Expérience ludique & différenciation UX |
| **EPIC 05** | Localisation & multilingue |

---

## 💻 Installation & exécution

### 🔹 Prérequis
- Flutter ≥ 3.19  
- Compte Firebase configuré  
- Accès à l’application Firebase via FlutterFire CLI  
- Le projet fonctionne avec un JDK 17 (testé). 

### 🔹 Étapes d’installation
```bash
git clone https://github.com/heg-web/F25-icola.git
cd brewmatch
flutter pub get
flutterfire configure
flutter run
```

### 🔒 Accès admin & logique de sécurité
1. Connecte un compte administrateur via Firebase Auth (identifiants internes).  
2. Depuis l’app, ouvre le menu client → `Unlock admin`, puis ressaisis le mot de passe : nous effectuons une **reauth Firebase** acting as secondary lock.  
3. L’espace admin se reverrouille automatiquement après un retour en mode client ou une période d’inactivité défini côté `AppState`.  

> Les formulaires `Ingrédients` et `Bières` utilisent `AdminCatalogRepository` pour créer/mettre à jour les documents Firestore et alimentent directement les listes admin (sélection dynamique d’ingrédients, creation dialog, etc.).

### 🔧 Tests & vérifications
```bash
flutter analyze   # quelques warnings connus restent (avoid_print, file naming…)
flutter test
```

## 🚀 Livraison MVP (phase actuelle)
Inclura :
-	Gestion complète des bières et ingrédients
-	Interface client fonctionnelle (sélection par critères gustatifs)
-	Interface admin fluide (CRUD, authentification, basculement de mode)
-	Traduction de l’interface automatisée
-	Déploiement sur portable et tablette

## livraisons futures envisagées
-	Statistiques des utilisations clients (préférences et tendances)
-	Traduction du contenu dynamique (bières et ingrédients)
-	Module Alcotest & conduite responsable (Easter Egg éducatif)
-	Mode multi-administrateur / multi-établissement
	
## 📚 Documentation & Ressources
-	Notes personnelles de projet – Ismaël Lehmann
			👉 [Consulter les notes Notion](https://exciting-clutch-fdb.notion.site/Projet-Flutter-279292135bb080ddbc01d58d89a7c821?source=copy_link)
-	Maquettes Figma : à venir
-	Charte visuelle et palette couleur : section “🎨 Concept visuel” dans Notion
	
## Équipe Projet

| Nom & Prénom | mail |
|------|---------------------|
| **Mandeleu Mélissa** | insert please |
| **Lehmann Ismaël** | ismael.lehmann@he-arc.ch |


## 🧾 Licence
Projet académique dans le cadre du Bachelor en Informatique de Gestion – HEG Arc, Neuchâtel.
Développement à but pédagogique et expérimental, sans diffusion publique.
