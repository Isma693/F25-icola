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
- **Gestion du catalogue (CRUD)** : ajout, modification, suppression  
- **Interface client et admin** sur un seul appareil (iPad du bar)  
- **Authentification sécurisée** via Firebase Auth  
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
  app.dart
  constants/
  core/
    models/
    services/
    widgets/
  features/
    client/
      screens/
      widgets/
    admin/
      screens/
      widgets/
  l10n/
  themes/
firebase_options.dart
```

**Models** : beer.dart, ingredient.dart, taste_profile.dart
**Services** : firestore_service.dart, auth_service.dart, beer_filter_service.dart, localized_text.dart
**Features** :
	-	/client/ → interface de sélection et navigation utilisateur
	-	/admin/ → tableau de bord, édition du catalogue et statistiques

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

## 🚀 Livraison MVP (phase actuelle)
Inclura :
-	Gestion complète des bières et ingrédients
-	Interface client fonctionnelle (sélection par critères gustatifs)
-	Interface admin fluide (CRUD, authentification, basculement de mode)
-	Traduction FR/EN de l’interface
-	Déploiement sur tablette

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
