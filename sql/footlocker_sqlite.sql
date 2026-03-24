-- ============================================
-- CAS FOOTLOCKER — Gestion magasin chaussures sport
-- Version SQLite pour le bac a sable SQL
-- 5 tables, ~120 lignes
-- ============================================

CREATE TABLE marque (
    id_marque INTEGER PRIMARY KEY AUTOINCREMENT,
    nom_marque TEXT NOT NULL,
    pays_origine TEXT NOT NULL,
    site_web TEXT
);

CREATE TABLE modele (
    id_modele INTEGER PRIMARY KEY AUTOINCREMENT,
    id_marque INTEGER NOT NULL REFERENCES marque(id_marque),
    nom_modele TEXT NOT NULL,
    categorie TEXT NOT NULL,
    prix_vente REAL NOT NULL,
    date_sortie TEXT,
    couleur TEXT
);

CREATE TABLE stock_pointure (
    id_modele INTEGER NOT NULL REFERENCES modele(id_modele),
    pointure REAL NOT NULL,
    quantite_stock INTEGER NOT NULL DEFAULT 0,
    seuil_alerte INTEGER NOT NULL DEFAULT 3,
    PRIMARY KEY (id_modele, pointure)
);

CREATE TABLE client (
    id_client INTEGER PRIMARY KEY AUTOINCREMENT,
    nom TEXT NOT NULL,
    prenom TEXT NOT NULL,
    email TEXT UNIQUE,
    telephone TEXT,
    ville TEXT,
    code_postal TEXT,
    date_inscription TEXT NOT NULL,
    carte_fidelite INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE vente (
    id_vente INTEGER PRIMARY KEY AUTOINCREMENT,
    id_client INTEGER REFERENCES client(id_client),
    id_modele INTEGER NOT NULL REFERENCES modele(id_modele),
    pointure REAL NOT NULL,
    quantite INTEGER NOT NULL DEFAULT 1,
    prix_paye REAL NOT NULL,
    date_vente TEXT NOT NULL,
    mode_paiement TEXT
);

INSERT INTO marque VALUES
(1,'Nike','USA','https://www.nike.com'),
(2,'Adidas','Allemagne','https://www.adidas.ch'),
(3,'New Balance','USA','https://www.newbalance.ch'),
(4,'Puma','Allemagne','https://www.puma.com'),
(5,'Asics','Japon','https://www.asics.ch'),
(6,'Vans','USA','https://www.vans.ch');

INSERT INTO modele VALUES
(1,1,'Air Max 90','Lifestyle',169.90,'2024-01-15','Blanc/Rouge'),
(2,1,'Air Force 1','Lifestyle',129.90,'2023-06-01','Blanc'),
(3,1,'Pegasus 41','Running',149.90,'2024-03-10','Noir/Vert'),
(4,2,'Ultraboost 24','Running',199.90,'2024-02-20','Core Black'),
(5,2,'Samba OG','Lifestyle',119.90,'2023-09-15','Blanc/Noir'),
(6,2,'Predator Edge','Football',249.90,'2024-01-05','Rouge/Noir'),
(7,3,'574 Classic','Lifestyle',109.90,'2023-04-01','Gris'),
(8,3,'FuelCell RC Elite','Running',229.90,'2024-05-10','Bleu/Orange'),
(9,4,'Suede Classic','Lifestyle',89.90,'2023-01-20','Bordeaux'),
(10,4,'Deviate Nitro 3','Running',179.90,'2024-06-15','Jaune/Noir'),
(11,5,'Gel-Kayano 31','Running',189.90,'2024-04-01','Bleu Marine'),
(12,5,'Gel-1130','Lifestyle',139.90,'2024-02-01','Blanc/Argent'),
(13,6,'Old Skool','Skateboard',89.90,'2023-03-15','Noir/Blanc'),
(14,6,'Sk8-Hi','Skateboard',99.90,'2023-05-01','Noir'),
(15,1,'Dunk Low','Lifestyle',119.90,'2024-07-01','Panda');

INSERT INTO stock_pointure VALUES
(1,39.0,5,3),(1,40.0,8,3),(1,41.0,12,3),(1,42.0,15,3),(1,43.0,10,3),(1,44.0,6,3),(1,45.0,3,3),
(2,38.0,4,3),(2,39.0,10,3),(2,40.0,15,3),(2,41.0,20,3),(2,42.0,18,3),(2,43.0,12,3),(2,44.0,8,3),
(3,40.0,6,3),(3,41.0,8,3),(3,42.0,10,3),(3,43.0,7,3),(3,44.0,4,3),
(4,40.0,3,3),(4,41.0,5,3),(4,42.0,8,3),(4,43.0,6,3),(4,44.0,2,3),
(5,39.0,7,3),(5,40.0,12,3),(5,41.0,15,3),(5,42.0,10,3),(5,43.0,5,3),
(6,40.0,4,2),(6,41.0,3,2),(6,42.0,5,2),(6,43.0,2,2),
(7,39.0,8,3),(7,40.0,12,3),(7,41.0,10,3),(7,42.0,15,3),(7,43.0,8,3),(7,44.0,5,3),
(8,41.0,3,2),(8,42.0,4,2),(8,43.0,3,2),(8,44.0,2,2),
(9,39.0,6,3),(9,40.0,10,3),(9,41.0,8,3),(9,42.0,12,3),(9,43.0,6,3),
(10,41.0,4,2),(10,42.0,5,2),(10,43.0,3,2),(10,44.0,2,2),
(11,40.0,4,2),(11,41.0,6,2),(11,42.0,8,2),(11,43.0,5,2),(11,44.0,3,2),
(12,39.0,5,2),(12,40.0,7,2),(12,41.0,9,2),(12,42.0,6,2),(12,43.0,4,2),
(13,38.0,8,3),(13,39.0,12,3),(13,40.0,15,3),(13,41.0,18,3),(13,42.0,14,3),(13,43.0,10,3),
(14,39.0,5,3),(14,40.0,8,3),(14,41.0,10,3),(14,42.0,8,3),(14,43.0,4,3),
(15,38.0,6,3),(15,39.0,10,3),(15,40.0,14,3),(15,41.0,18,3),(15,42.0,16,3),(15,43.0,10,3),(15,44.0,5,3);

INSERT INTO client VALUES
(1,'Mueller','Thomas','thomas.mueller@gmail.com','079 123 45 67','Geneve','1201','2023-01-15',1),
(2,'Rochat','Julie','julie.rochat@bluewin.ch','078 234 56 78','Lausanne','1003','2023-03-20',1),
(3,'Da Silva','Marco','marco.dasilva@hotmail.com','076 345 67 89','Geneve','1205','2023-06-10',0),
(4,'Schneider','Anna','anna.schneider@gmail.com','079 456 78 90','Nyon','1260','2023-09-01',1),
(5,'Bonvin','Lucas','lucas.bonvin@proton.me','078 567 89 01','Sion','1950','2024-01-10',0),
(6,'Keller','Sophie','sophie.keller@sunrise.ch','076 678 90 12','Fribourg','1700','2024-02-15',1),
(7,'Ndiaye','Amadou','amadou.ndiaye@gmail.com','079 789 01 23','Geneve','1202','2024-03-05',0),
(8,'Favre','Emilie','emilie.favre@bluewin.ch','078 890 12 34','Montreux','1820','2024-04-20',1),
(9,'Rossi','Luca','luca.rossi@gmail.com','076 901 23 45','Lausanne','1006','2024-05-12',0),
(10,'Dupont','Marie','marie.dupont@hotmail.com','079 012 34 56','Vevey','1800','2024-06-01',1),
(11,'Mbeki','David','david.mbeki@proton.me','078 123 45 00','Geneve','1209','2024-07-15',0),
(12,'Blanc','Nathalie',NULL,'076 234 56 00','Morges','1110','2024-08-01',0);

INSERT INTO vente VALUES
(1,1,1,43.0,1,169.90,'2024-01-20','Carte'),
(2,1,5,43.0,1,119.90,'2024-03-15','Twint'),
(3,2,2,39.0,1,129.90,'2024-02-10','Carte'),
(4,2,7,39.0,1,109.90,'2024-06-20','Cash'),
(5,3,4,42.0,1,199.90,'2024-03-05','Carte'),
(6,3,15,42.0,1,119.90,'2024-07-10','Twint'),
(7,4,11,40.0,1,189.90,'2024-04-12','En ligne'),
(8,4,12,40.0,1,139.90,'2024-04-12','En ligne'),
(9,5,13,42.0,1,89.90,'2024-05-01','Cash'),
(10,6,3,41.0,1,149.90,'2024-05-15','Carte'),
(11,6,9,41.0,1,89.90,'2024-05-15','Carte'),
(12,7,15,43.0,1,119.90,'2024-06-01','Twint'),
(13,7,1,44.0,1,169.90,'2024-06-01','Twint'),
(14,8,2,38.0,1,129.90,'2024-06-20','Carte'),
(15,8,5,39.0,1,119.90,'2024-08-05','Twint'),
(16,9,10,42.0,1,179.90,'2024-07-01','Carte'),
(17,10,7,40.0,1,109.90,'2024-07-15','En ligne'),
(18,10,14,41.0,1,99.90,'2024-07-15','En ligne'),
(19,11,6,43.0,1,249.90,'2024-08-01','Carte'),
(20,NULL,13,40.0,1,89.90,'2024-08-10','Cash'),
(21,NULL,9,42.0,1,89.90,'2024-08-15','Cash'),
(22,1,15,43.0,1,119.90,'2024-08-20','Twint'),
(23,2,11,39.0,1,189.90,'2024-09-01','Carte'),
(24,6,15,41.0,1,119.90,'2024-09-10','Carte'),
(25,3,1,42.0,1,169.90,'2024-09-15','Twint');
