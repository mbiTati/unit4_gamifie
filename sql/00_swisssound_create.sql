-- ============================================
-- SwissSound Studios — Base de données complète
-- Unit 4: Database Design & Development
-- BTEC Higher Nationals in Computing
-- ============================================
-- Script 00 : Création de la base et des tables
-- À exécuter dans HeidiSQL ou MySQL Workbench
-- ============================================

-- Suppression si existant (ordre inverse des FK)
DROP DATABASE IF EXISTS swisssound;

-- Création de la base
CREATE DATABASE swisssound
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE swisssound;

-- ============================================
-- TABLE 1 : GENRE
-- Catégories musicales
-- ============================================
CREATE TABLE genre (
  id_genre      INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Identifiant unique du genre',
  nom           VARCHAR(50) NOT NULL UNIQUE COMMENT 'Nom du genre musical',
  description   VARCHAR(255) DEFAULT NULL COMMENT 'Description du genre'
) COMMENT = 'Genres musicaux disponibles';

-- ============================================
-- TABLE 2 : ARTISTE
-- Musiciens/groupes enregistrés au studio
-- ============================================
CREATE TABLE artiste (
  id_artiste       INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Identifiant unique de l artiste',
  nom              VARCHAR(100) NOT NULL COMMENT 'Nom de famille ou nom de scène',
  prenom           VARCHAR(100) DEFAULT NULL COMMENT 'Prénom (NULL si groupe)',
  email            VARCHAR(150) NOT NULL UNIQUE COMMENT 'Email de contact',
  telephone        VARCHAR(20) DEFAULT NULL COMMENT 'Numéro de téléphone (+41...)',
  date_inscription DATE NOT NULL DEFAULT (CURDATE()) COMMENT 'Date d inscription au studio',
  actif            BOOLEAN NOT NULL DEFAULT TRUE COMMENT 'Artiste actif ou archivé'
) COMMENT = 'Artistes et groupes inscrits chez SwissSound';

-- ============================================
-- TABLE 3 : GENRE_ARTISTE (association N:M)
-- Un artiste peut avoir plusieurs genres
-- ============================================
CREATE TABLE genre_artiste (
  id_genre   INT NOT NULL,
  id_artiste INT NOT NULL,
  PRIMARY KEY (id_genre, id_artiste),
  CONSTRAINT fk_ga_genre FOREIGN KEY (id_genre) 
    REFERENCES genre(id_genre) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_ga_artiste FOREIGN KEY (id_artiste) 
    REFERENCES artiste(id_artiste) ON DELETE CASCADE ON UPDATE CASCADE
) COMMENT = 'Association N:M entre genres et artistes';

-- ============================================
-- TABLE 4 : ALBUM
-- Albums produits par les artistes
-- ============================================
CREATE TABLE album (
  id_album     INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Identifiant unique de l album',
  titre        VARCHAR(200) NOT NULL COMMENT 'Titre de l album',
  date_sortie  DATE DEFAULT NULL COMMENT 'Date de sortie',
  nb_pistes    INT DEFAULT 0 COMMENT 'Nombre de pistes',
  prix         DECIMAL(8,2) DEFAULT NULL COMMENT 'Prix de vente en CHF',
  id_artiste   INT NOT NULL COMMENT 'Artiste auteur de l album',
  CONSTRAINT fk_album_artiste FOREIGN KEY (id_artiste) 
    REFERENCES artiste(id_artiste) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT chk_album_prix CHECK (prix IS NULL OR prix >= 0),
  CONSTRAINT chk_album_pistes CHECK (nb_pistes >= 0)
) COMMENT = 'Albums produits au studio';

-- ============================================
-- TABLE 5 : SALLE
-- Salles d enregistrement du studio
-- ============================================
CREATE TABLE salle (
  id_salle          INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Identifiant unique de la salle',
  nom               VARCHAR(100) NOT NULL UNIQUE COMMENT 'Nom de la salle',
  capacite          INT NOT NULL DEFAULT 1 COMMENT 'Capacité maximale (personnes)',
  tarif_horaire     DECIMAL(8,2) NOT NULL COMMENT 'Tarif horaire en CHF',
  equipee_isolation BOOLEAN NOT NULL DEFAULT FALSE COMMENT 'Salle avec isolation acoustique',
  CONSTRAINT chk_salle_capacite CHECK (capacite > 0),
  CONSTRAINT chk_salle_tarif CHECK (tarif_horaire > 0)
) COMMENT = 'Salles d enregistrement SwissSound';

-- ============================================
-- TABLE 6 : INGENIEUR
-- Ingénieurs du son
-- ============================================
CREATE TABLE ingenieur (
  id_ingenieur  INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Identifiant unique',
  nom           VARCHAR(100) NOT NULL COMMENT 'Nom de famille',
  prenom        VARCHAR(100) NOT NULL COMMENT 'Prénom',
  specialite    VARCHAR(100) DEFAULT NULL COMMENT 'Spécialité (mixage, mastering, prise de son...)',
  tarif_horaire DECIMAL(8,2) NOT NULL COMMENT 'Tarif horaire en CHF',
  CONSTRAINT chk_ing_tarif CHECK (tarif_horaire > 0)
) COMMENT = 'Ingénieurs du son du studio';

-- ============================================
-- TABLE 7 : EQUIPEMENT
-- Matériel technique dans les salles
-- ============================================
CREATE TABLE equipement (
  id_equipement INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Identifiant unique',
  nom           VARCHAR(150) NOT NULL COMMENT 'Nom de l équipement',
  categorie     ENUM('Micro','Console','Enceinte','Instrument','Casque','Câble','Autre') 
                NOT NULL COMMENT 'Catégorie de matériel',
  marque        VARCHAR(100) DEFAULT NULL COMMENT 'Marque du fabricant',
  valeur        DECIMAL(10,2) DEFAULT NULL COMMENT 'Valeur d achat en CHF',
  etat          ENUM('Neuf','Bon','Usagé','En panne','Retiré') NOT NULL DEFAULT 'Bon'
                COMMENT 'État actuel du matériel',
  id_salle      INT DEFAULT NULL COMMENT 'Salle où se trouve l équipement',
  CONSTRAINT fk_equip_salle FOREIGN KEY (id_salle) 
    REFERENCES salle(id_salle) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT chk_equip_valeur CHECK (valeur IS NULL OR valeur >= 0)
) COMMENT = 'Inventaire du matériel technique';

-- ============================================
-- TABLE 8 : SESSION
-- Sessions d enregistrement
-- ============================================
CREATE TABLE session_enregistrement (
  id_session    INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Identifiant unique de la session',
  date_session  DATE NOT NULL COMMENT 'Date de la session',
  heure_debut   TIME NOT NULL COMMENT 'Heure de début',
  heure_fin     TIME NOT NULL COMMENT 'Heure de fin',
  statut        ENUM('planifiee','confirmee','en_cours','terminee','annulee') 
                NOT NULL DEFAULT 'planifiee' COMMENT 'Statut de la session',
  notes         TEXT DEFAULT NULL COMMENT 'Notes ou commentaires',
  id_artiste    INT NOT NULL COMMENT 'Artiste qui enregistre',
  id_salle      INT NOT NULL COMMENT 'Salle utilisée',
  id_ingenieur  INT NOT NULL COMMENT 'Ingénieur du son assigné',
  CONSTRAINT fk_sess_artiste FOREIGN KEY (id_artiste)
    REFERENCES artiste(id_artiste) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_sess_salle FOREIGN KEY (id_salle)
    REFERENCES salle(id_salle) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_sess_ingenieur FOREIGN KEY (id_ingenieur)
    REFERENCES ingenieur(id_ingenieur) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT chk_sess_heures CHECK (heure_fin > heure_debut)
) COMMENT = 'Sessions d enregistrement planifiées et réalisées';

-- ============================================
-- TABLE 9 : FACTURE
-- Factures liées aux sessions
-- ============================================
CREATE TABLE facture (
  id_facture       INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Identifiant unique',
  date_facture     DATE NOT NULL DEFAULT (CURDATE()) COMMENT 'Date d émission',
  montant_total    DECIMAL(10,2) NOT NULL COMMENT 'Montant total TTC en CHF',
  statut_paiement  ENUM('impayee','payee','en_retard','annulee') 
                   NOT NULL DEFAULT 'impayee' COMMENT 'Statut du paiement',
  id_artiste       INT NOT NULL COMMENT 'Artiste facturé',
  id_session       INT DEFAULT NULL COMMENT 'Session liée (optionnel)',
  CONSTRAINT fk_fact_artiste FOREIGN KEY (id_artiste)
    REFERENCES artiste(id_artiste) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_fact_session FOREIGN KEY (id_session)
    REFERENCES session_enregistrement(id_session) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT chk_fact_montant CHECK (montant_total >= 0)
) COMMENT = 'Factures émises aux artistes';

-- ============================================
-- INDEX pour performances
-- ============================================
CREATE INDEX idx_artiste_nom ON artiste(nom);
CREATE INDEX idx_album_artiste ON album(id_artiste);
CREATE INDEX idx_session_date ON session_enregistrement(date_session);
CREATE INDEX idx_session_artiste ON session_enregistrement(id_artiste);
CREATE INDEX idx_facture_statut ON facture(statut_paiement);
CREATE INDEX idx_facture_artiste ON facture(id_artiste);

-- ============================================
-- Vérification
-- ============================================
SELECT '✅ Base swisssound créée avec succès !' AS message;
SHOW TABLES;
