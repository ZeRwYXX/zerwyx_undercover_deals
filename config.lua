Config = {}

-- Localisation/langue pour les messages et notifications (par exemple "fr" pour français)
Config.Locales = "fr"

-- Nombre minimum de policiers nécessaires en ligne pour démarrer une vente
Config.needCops = 1

-- Liste des drogues disponibles à la vente avec leurs paramètres respectifs
Config.Drugs = {
    {
        name = "weed_pooch",   -- Nom de l'item de drogue (doit correspondre à l'inventaire)
        label = "Pochon de weed", -- Nom affiché pour la drogue
        minPrice = 20,         -- Prix minimum par unité
        maxPrice = 120,        -- Prix maximum par unité
        minSell = 1,           -- Quantité minimale que le PNJ peut acheter
        maxSell = 10,          -- Quantité maximale que le PNJ peut acheter
        minRequire = 1         -- Quantité minimale de drogue nécessaire dans l'inventaire pour vendre
    }
}

-- Paramètres du blip (icône) utilisé pour représenter le PNJ lors de la vente
Config.BlipSettings = {
    sprite = 51,           -- Icône du blip (utiliser un numéro de sprite valide)
    color = 27,              -- Couleur du blip (par exemple 3 pour bleu)
    scale = 0.5,            -- Taille du blip
    display = 4,            -- Mode d'affichage du blip (ex. 4 pour afficher tout le temps)
    text = "Attente de votre livraison" -- Texte qui s'affiche en survolant le blip
}

-- Commandes utilisées pour démarrer et arrêter une vente
Config.StartCmd = "startselling" -- Commande pour démarrer la vente
Config.StopCmd = "stopselling"   -- Commande pour arrêter la vente

-- Liste des PNJ qui peuvent être utilisés pour la vente
Config.Peds = false
-- Ou vous pouvez utiliser ca pour mettre des peds prédéfini
--   {
--     { name = "a_m_m_bevhills_02" }, 
--     { name = "a_f_m_skidrow_01" } 
--   }

-- Liste des métiers (jobs) autorisés à être pris en compte pour le nombre de policiers en ligne
Config.JobsAllowed = { 'police', 'sheriff' } 

-- Liste des PNJ interdits pour les interactions (blacklist)
Config.BlackListPeds = {
    { name = "u_m_m_prolsec_01" },   -- Modèles de PNJ interdits (blacklist)
    { name = "s_f_y_sheriff_01" },
    { name = "s_m_y_sheriff_01" }
}



-- Type de paiement accepté pour la vente (soit "black_money" pour argent sale, soit "money" pour argent propre)
Config.PaymentType = "black_money"

-- Rayon de spawn pour faire apparaître les PNJ autour du joueur
Config.SpawnRadius = 1000

-- Probabilité que le PNJ refuse la vente et appelle la police
-- Par exemple, avec Config.Lucky = 5, il y a 1 chance sur 10 (10%) que la police soit appelée
Config.Lucky = 1

-- Rayon de la zone signalée sur la carte pour les policiers lorsque le PNJ appelle la police
Config.RadiusLSPD = 50

-- Si 'PedAutoMove' est false, le PNJ ne bougera pas après le spawn (il exécutera des animations aléatoires comme fumer, parler au téléphone, etc.)
-- Si true, le PNJ se déplace automatiquement vers le joueur pour effectuer la vente
Config.PedAutoMove = true


Config.PedList = {
    "a_m_m_farmer_01",
    "a_m_y_beach_01",
    "a_f_y_hipster_01",
    "u_m_y_baygor",
    "s_m_m_autoshop_01"
}