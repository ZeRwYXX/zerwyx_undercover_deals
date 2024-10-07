
# Drug Selling Script

## Configuration

Le fichier `config.lua` contient plusieurs paramètres qui permettent de personnaliser le script de vente de drogue. Voici une explication de chaque configuration :

### Locales
```lua
Config.Locales = "fr"
```
- **Description :** Définit la langue utilisée pour les messages et notifications dans le script. Par exemple, `"fr"` pour le français.

### Nombre minimum de policiers
```lua
Config.needCops = 1
```
- **Description :** Indique le nombre minimum de policiers qui doivent être en ligne pour qu'une vente puisse commencer. Cela permet d'ajouter un élément de risque et d'interaction avec les forces de l'ordre.

### Liste des drogues
```lua
Config.Drugs = {
    {
        name = "weed_pooch",
        label = "Pochon de weed",
        minPrice = 20,
        maxPrice = 120,
        minSell = 1,
        maxSell = 10,
        minRequire = 1
    }
}
```
- **Description :** Définit les drogues disponibles à la vente avec leurs paramètres respectifs.
  - `name` : Nom de l'item de drogue (doit correspondre à l'inventaire du joueur).
  - `label` : Nom affiché pour la drogue.
  - `minPrice` : Prix minimum par unité de drogue.
  - `maxPrice` : Prix maximum par unité de drogue.
  - `minSell` : Quantité minimale que le PNJ peut acheter lors d'une vente.
  - `maxSell` : Quantité maximale que le PNJ peut acheter lors d'une vente.
  - `minRequire` : Quantité minimale de drogue nécessaire dans l'inventaire pour effectuer une vente.

### Paramètres du blip
```lua
Config.BlipSettings = {
    sprite = 51,
    color = 27,
    scale = 0.5,
    display = 4,
    text = "Attente de votre livraison"
}
```
- **Description :** Définit les paramètres pour le blip qui représente le PNJ lors de la vente.
  - `sprite` : Icône du blip, correspondant à un numéro de sprite valide dans le jeu.
  - `color` : Couleur du blip (par exemple, 3 pour bleu).
  - `scale` : Taille du blip sur la carte.
  - `display` : Mode d'affichage du blip (ex. 4 pour afficher tout le temps).
  - `text` : Texte qui s'affiche lorsqu'on survole le blip.

### Commandes pour démarrer et arrêter une vente
```lua
Config.StartCmd = "startselling"
Config.StopCmd = "stopselling"
```
- **Description :** Commandes utilisées pour démarrer et arrêter une vente de drogue. Les joueurs peuvent utiliser `/startselling` pour commencer et `/stopselling` pour arrêter.

### Liste des PNJ
```lua
Config.Peds = false
```
- **Description :** Indique si des PNJ spécifiques peuvent être utilisés pour la vente. Si défini sur `false`, le script utilisera des modèles de PNJ aléatoires. Sinon, vous pouvez spécifier des PNJ prédéfinis dans une table.

### Métiers autorisés pour les notifications
```lua
Config.JobsAllowed = { 'police', 'sheriff' }
```
- **Description :** Liste des métiers (jobs) qui seront pris en compte pour le comptage des policiers en ligne. Seuls les joueurs ayant ces métiers seront notifiés lors d'une vente.

### Liste des PNJ interdits
```lua
Config.BlackListPeds = {
    { name = "u_m_m_prolsec_01" },
    { name = "s_f_y_sheriff_01" },
    { name = "s_m_y_sheriff_01" }
}
```
- **Description :** Modèles de PNJ qui ne doivent pas être utilisés pour les interactions de vente. Cela peut inclure des modèles de police ou d'autres PNJ non désirés.

### Type de paiement accepté
```lua
Config.PaymentType = "black_money"
```
- **Description :** Indique le type de paiement accepté lors des ventes de drogue. Cela peut être `"black_money"` pour l'argent sale ou `"money"` pour l'argent propre.

### Rayon de spawn des PNJ
```lua
Config.SpawnRadius = 1000
```
- **Description :** Définit le rayon autour du joueur dans lequel les PNJ peuvent apparaître pour effectuer une vente.

### Probabilité d'appeler la police
```lua
Config.Lucky = 1
```
- **Description :** Définit la probabilité qu'un PNJ refuse une vente et appelle la police. Par exemple, avec `Config.Lucky = 5`, il y a 1 chance sur 10 (10%) que la police soit alertée.

### Rayon de la zone signalée
```lua
Config.RadiusLSPD = 50
```
- **Description :** Indique le rayon de la zone qui sera signalée sur la carte pour les policiers lorsque le PNJ appelle la police.

### Mouvement automatique des PNJ
```lua
Config.PedAutoMove = true
```
- **Description :** Si défini sur `false`, le PNJ ne bougera pas après son apparition et exécutera des animations aléatoires. Si défini sur `true`, le PNJ se déplacera automatiquement vers le joueur pour effectuer la vente.

### Liste des modèles de PNJ
```lua
Config.PedList = {
    "a_m_m_farmer_01",
    "a_m_y_beach_01",
    "a_f_y_hipster_01",
    "u_m_y_baygor",
    "s_m_m_autoshop_01"
}
```
- **Description :** Liste des modèles de PNJ qui peuvent être utilisés pour les interactions de vente. Si `Config.Peds` est activé, seuls ces modèles seront utilisés.
