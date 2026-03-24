-- ============================================
-- CAS BATEAUX GVA — Location nautique Lac Leman
-- Version SQLite — 5 tables, ~60 lignes
-- ============================================
CREATE TABLE port (
    id_port INTEGER PRIMARY KEY AUTOINCREMENT,
    nom_port TEXT NOT NULL, ville TEXT NOT NULL, nb_places INTEGER NOT NULL
);
CREATE TABLE type_bateau (
    id_type INTEGER PRIMARY KEY AUTOINCREMENT,
    libelle TEXT NOT NULL, capacite_max INTEGER NOT NULL, permis_requis INTEGER NOT NULL DEFAULT 0,
    tarif_journee REAL NOT NULL, tarif_demi_journee REAL NOT NULL, caution REAL NOT NULL DEFAULT 500.00
);
CREATE TABLE bateau (
    id_bateau INTEGER PRIMARY KEY AUTOINCREMENT,
    id_type INTEGER NOT NULL REFERENCES type_bateau(id_type),
    id_port INTEGER NOT NULL REFERENCES port(id_port),
    nom_bateau TEXT NOT NULL, annee_construction INTEGER, longueur_m REAL,
    motorise INTEGER NOT NULL DEFAULT 1,
    etat TEXT NOT NULL DEFAULT 'Disponible'
);
CREATE TABLE client (
    id_client INTEGER PRIMARY KEY AUTOINCREMENT,
    nom TEXT NOT NULL, prenom TEXT NOT NULL, email TEXT NOT NULL UNIQUE,
    telephone TEXT, ville TEXT, permis_bateau INTEGER NOT NULL DEFAULT 0,
    date_inscription TEXT NOT NULL
);
CREATE TABLE reservation (
    id_reservation INTEGER PRIMARY KEY AUTOINCREMENT,
    id_client INTEGER NOT NULL REFERENCES client(id_client),
    id_bateau INTEGER NOT NULL REFERENCES bateau(id_bateau),
    date_debut TEXT NOT NULL, date_fin TEXT NOT NULL,
    duree_type TEXT NOT NULL, montant_total REAL NOT NULL,
    statut TEXT NOT NULL DEFAULT 'Confirmee', date_reservation TEXT NOT NULL
);

INSERT INTO port VALUES(1,'Port des Eaux-Vives','Geneve',45),(2,'Port de la Societe Nautique','Geneve',30),(3,'Port de Nyon','Nyon',25),(4,'Port d''Ouchy','Lausanne',50),(5,'Port de Montreux','Montreux',20);

INSERT INTO type_bateau VALUES(1,'Pedalo 4 places',4,0,45.00,25.00,50.00),(2,'Barque a rames',4,0,55.00,30.00,100.00),(3,'Canot moteur 6CV',6,0,120.00,70.00,500.00),(4,'Vedette 15CV',8,1,250.00,150.00,1000.00),(5,'Voilier Surprise',5,1,280.00,160.00,1500.00),(6,'Stand-up Paddle',1,0,30.00,18.00,50.00);

INSERT INTO bateau VALUES(1,1,1,'Soleil',2022,3.2,0,'Disponible'),(2,1,1,'Etoile',2023,3.2,0,'Disponible'),(3,2,1,'Leman I',2020,4.0,0,'Disponible'),(4,2,3,'Nymphe',2019,3.8,0,'Maintenance'),(5,3,1,'Jet Bleu',2021,5.5,1,'Disponible'),(6,3,2,'Mouette',2022,5.2,1,'Disponible'),(7,3,4,'Perle du Lac',2023,5.8,1,'En location'),(8,4,2,'Vent du Large',2020,7.5,1,'Disponible'),(9,4,4,'Capitaine',2021,8.0,1,'Disponible'),(10,5,2,'Alinghi Junior',2019,7.6,0,'Disponible'),(11,5,5,'Mistral',2022,7.8,0,'Hors service'),(12,6,1,'SUP Alpha',2024,3.2,0,'Disponible'),(13,6,1,'SUP Beta',2024,3.2,0,'Disponible'),(14,6,4,'SUP Gamma',2023,3.0,0,'Disponible');

INSERT INTO client VALUES(1,'Favre','Pierre','pierre.favre@gmail.com','079 111 22 33','Geneve',1,'2023-04-10'),(2,'Rochat','Claire','claire.rochat@bluewin.ch','078 222 33 44','Lausanne',0,'2023-06-15'),(3,'Berger','Marc','marc.berger@hotmail.com','076 333 44 55','Nyon',1,'2023-08-20'),(4,'Nguyen','Linh','linh.nguyen@proton.me','079 444 55 66','Geneve',0,'2024-01-05'),(5,'Vuille','Sandrine','sandrine.vuille@sunrise.ch','078 555 66 77','Montreux',1,'2024-02-14'),(6,'Schmid','Hans','hans.schmid@gmail.com','076 666 77 88','Geneve',0,'2024-03-20'),(7,'Costa','Ana','ana.costa@gmail.com','079 777 88 99','Lausanne',1,'2024-05-01'),(8,'Blanc','Jerome','jerome.blanc@bluewin.ch','078 888 99 00','Vevey',0,'2024-06-10');

INSERT INTO reservation VALUES(1,1,5,'2024-06-15','2024-06-15','Journee',120.00,'Terminee','2024-06-10'),(2,1,8,'2024-07-20','2024-07-20','Journee',250.00,'Terminee','2024-07-15'),(3,2,1,'2024-06-20','2024-06-20','Demi-journee',25.00,'Terminee','2024-06-18'),(4,2,12,'2024-07-10','2024-07-10','Journee',30.00,'Terminee','2024-07-08'),(5,3,10,'2024-07-01','2024-07-03','Multi-jours',840.00,'Terminee','2024-06-25'),(6,3,6,'2024-08-05','2024-08-05','Journee',120.00,'Terminee','2024-08-01'),(7,4,1,'2024-07-15','2024-07-15','Journee',45.00,'Terminee','2024-07-12'),(8,4,12,'2024-08-10','2024-08-10','Demi-journee',18.00,'Terminee','2024-08-08'),(9,5,9,'2024-07-25','2024-07-27','Multi-jours',750.00,'Terminee','2024-07-20'),(10,5,10,'2024-08-15','2024-08-15','Journee',280.00,'Confirmee','2024-08-10'),(11,6,2,'2024-08-01','2024-08-01','Journee',45.00,'Terminee','2024-07-28'),(12,6,13,'2024-08-20','2024-08-20','Demi-journee',18.00,'Confirmee','2024-08-18'),(13,7,7,'2024-08-12','2024-08-14','Multi-jours',360.00,'En cours','2024-08-08'),(14,7,5,'2024-09-01','2024-09-01','Journee',120.00,'Confirmee','2024-08-25'),(15,8,3,'2024-08-18','2024-08-18','Demi-journee',30.00,'Confirmee','2024-08-15'),(16,1,9,'2024-09-10','2024-09-12','Multi-jours',750.00,'Confirmee','2024-09-01'),(17,2,14,'2024-09-05','2024-09-05','Journee',30.00,'Annulee','2024-09-02');
