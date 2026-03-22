-- ============================================
-- SwissSound Studios — Données de test
-- Script 01 : INSERT (peuplement)
-- ============================================

USE swisssound;

-- ============================================
-- GENRES
-- ============================================
INSERT INTO genre (nom, description) VALUES
('Rock', 'Rock classique et alternatif'),
('Jazz', 'Jazz contemporain et classique'),
('Hip-Hop', 'Rap et hip-hop francophone et anglophone'),
('Électronique', 'Musique électronique, techno, house'),
('Pop', 'Pop mainstream et indie'),
('Classique', 'Musique classique et orchestrale'),
('R&B', 'Rhythm and blues contemporain'),
('Reggae', 'Reggae et dub'),
('Folk', 'Folk et musique acoustique'),
('Metal', 'Heavy metal et sous-genres');

-- ============================================
-- ARTISTES (20 artistes suisses fictifs)
-- ============================================
INSERT INTO artiste (nom, prenom, email, telephone, date_inscription, actif) VALUES
('Léman', 'Marc', 'marc.leman@music.ch', '+41791234501', '2023-01-15', TRUE),
('Alpes Sound', NULL, 'contact@alpessound.ch', '+41791234502', '2023-02-20', TRUE),
('Dubois', 'Sophie', 'sophie.dubois@music.ch', '+41791234503', '2023-03-10', TRUE),
('MC Helvetik', NULL, 'booking@mchelvetik.ch', '+41791234504', '2023-04-05', TRUE),
('Müller', 'Thomas', 'thomas.muller@music.ch', '+41791234505', '2023-05-12', TRUE),
('Roche', 'Julie', 'julie.roche@music.ch', '+41791234506', '2023-06-01', TRUE),
('Zermatt Beat', NULL, 'info@zermattbeat.ch', '+41791234507', '2023-07-18', TRUE),
('Favre', 'Nicolas', 'nicolas.favre@music.ch', '+41791234508', '2023-08-22', TRUE),
('Luna Vaud', NULL, 'luna@lunavaud.ch', '+41791234509', '2023-09-03', TRUE),
('Bonvin', 'Émilie', 'emilie.bonvin@music.ch', '+41791234510', '2023-10-11', TRUE),
('DJ Lausanne', NULL, 'djlausanne@music.ch', '+41791234511', '2023-11-15', TRUE),
('Perret', 'Antoine', 'antoine.perret@music.ch', '+41791234512', '2024-01-08', TRUE),
('Genève Strings', NULL, 'contact@genevestrings.ch', '+41791234513', '2024-02-14', TRUE),
('Rossi', 'Valentina', 'valentina.rossi@music.ch', '+41791234514', '2024-03-20', TRUE),
('Neuchâtel Flow', NULL, 'flow@neuchatel.ch', '+41791234515', '2024-04-01', TRUE),
('Martin', 'Lucas', 'lucas.martin@music.ch', '+41791234516', '2024-05-15', TRUE),
('Bienne Bass', NULL, 'bass@bienne.ch', '+41791234517', '2024-06-10', FALSE),
('Chevalier', 'Marie', 'marie.chevalier@music.ch', '+41791234518', '2024-07-22', TRUE),
('Alpine Echo', NULL, 'echo@alpine.ch', '+41791234519', '2024-08-30', TRUE),
('Blanc', 'Pierre', 'pierre.blanc@music.ch', '+41791234520', '2024-09-15', TRUE);

-- ============================================
-- GENRE_ARTISTE (associations N:M)
-- ============================================
INSERT INTO genre_artiste (id_genre, id_artiste) VALUES
(1, 1), (2, 1),      -- Marc Léman : Rock, Jazz
(1, 2), (4, 2),      -- Alpes Sound : Rock, Électronique
(5, 3), (7, 3),      -- Sophie Dubois : Pop, R&B
(3, 4),              -- MC Helvetik : Hip-Hop
(2, 5), (9, 5),      -- Thomas Müller : Jazz, Folk
(5, 6), (2, 6),      -- Julie Roche : Pop, Jazz
(4, 7), (3, 7),      -- Zermatt Beat : Électronique, Hip-Hop
(1, 8), (10, 8),     -- Nicolas Favre : Rock, Metal
(5, 9), (4, 9),      -- Luna Vaud : Pop, Électronique
(6, 10),             -- Émilie Bonvin : Classique
(4, 11),             -- DJ Lausanne : Électronique
(9, 12), (1, 12),    -- Antoine Perret : Folk, Rock
(6, 13),             -- Genève Strings : Classique
(5, 14), (7, 14),    -- Valentina Rossi : Pop, R&B
(3, 15), (7, 15),    -- Neuchâtel Flow : Hip-Hop, R&B
(1, 16), (5, 16),    -- Lucas Martin : Rock, Pop
(4, 17),             -- Bienne Bass : Électronique
(2, 18), (6, 18),    -- Marie Chevalier : Jazz, Classique
(9, 19), (1, 19),    -- Alpine Echo : Folk, Rock
(3, 20), (5, 20);    -- Pierre Blanc : Hip-Hop, Pop

-- ============================================
-- ALBUMS (30 albums)
-- ============================================
INSERT INTO album (titre, date_sortie, nb_pistes, prix, id_artiste) VALUES
('Reflets du Lac', '2023-06-15', 12, 24.90, 1),
('Sommets', '2024-01-20', 10, 22.90, 2),
('Éclats de Voix', '2023-09-30', 8, 19.90, 3),
('Béton Suisse', '2023-11-10', 14, 21.90, 4),
('Nuits de Montreux', '2024-03-15', 9, 29.90, 5),
('Soleil Couchant', '2024-05-01', 11, 23.90, 6),
('Bass Drop Alpin', '2023-08-20', 7, 18.90, 7),
('Riffs et Glaciers', '2024-02-28', 13, 25.90, 8),
('Aurore Digitale', '2024-07-10', 10, 20.90, 9),
('Concerto Helvétique', '2024-04-22', 6, 34.90, 10),
('Midnight Lausanne', '2024-06-30', 8, 17.90, 11),
('Chemins de Terre', '2024-08-15', 11, 22.90, 12),
('Quatuor Genevois', '2024-09-01', 4, 32.90, 13),
('Dolce Vita Suisse', '2024-10-12', 10, 21.90, 14),
('Flow Romand', '2024-11-05', 12, 19.90, 15),
('Horizon Rock', '2025-01-15', 9, 23.90, 16),
('Deep Frequencies', '2023-12-01', 6, 16.90, 17),
('Nocturnes', '2025-02-14', 8, 27.90, 18),
('Écho des Montagnes', '2025-03-01', 10, 24.90, 19),
('Rimes Urbaines', '2025-01-28', 15, 20.90, 20),
('Reflets du Lac II', '2025-04-10', 11, 26.90, 1),
('Altitude', '2025-03-20', 9, 24.90, 2),
('Voix Intérieure', '2025-02-01', 7, 21.90, 3),
('Rue de la Gare', '2025-05-15', 16, 22.90, 4),
('Jazz au Château', '2025-04-01', 8, 31.90, 5),
('Été Perpétuel', '2025-06-01', 10, 23.90, 6),
('Pulse', '2025-05-20', 9, 19.90, 7),
('Tempête Électrique', '2025-04-15', 12, 25.90, 8),
('Luna Sessions', '2025-07-01', 8, 22.90, 9),
('Requiem Moderne', '2025-06-15', 5, 36.90, 10);

-- ============================================
-- SALLES (5 salles)
-- ============================================
INSERT INTO salle (nom, capacite, tarif_horaire, equipee_isolation) VALUES
('Studio Pro A', 8, 150.00, TRUE),
('Studio Podcast B', 4, 80.00, TRUE),
('Salle Live C', 20, 200.00, TRUE),
('Cabine Voix D', 2, 60.00, TRUE),
('Salle de Mixage E', 3, 120.00, FALSE);

-- ============================================
-- INGÉNIEURS (6 ingénieurs)
-- ============================================
INSERT INTO ingenieur (nom, prenom, specialite, tarif_horaire) VALUES
('Dupont', 'Marc', 'Mixage et mastering', 95.00),
('Weber', 'Anna', 'Prise de son live', 85.00),
('Schneider', 'Paul', 'Production électronique', 90.00),
('Morel', 'Claire', 'Enregistrement voix', 80.00),
('Berset', 'David', 'Sound design', 100.00),
('Fontaine', 'Léa', 'Mastering', 95.00);

-- ============================================
-- ÉQUIPEMENTS (15 équipements)
-- ============================================
INSERT INTO equipement (nom, categorie, marque, valeur, etat, id_salle) VALUES
('SM7B', 'Micro', 'Shure', 450.00, 'Bon', 1),
('U87', 'Micro', 'Neumann', 3200.00, 'Bon', 1),
('Apollo x8', 'Console', 'Universal Audio', 4500.00, 'Bon', 1),
('HS8', 'Enceinte', 'Yamaha', 800.00, 'Bon', 1),
('SM58', 'Micro', 'Shure', 120.00, 'Bon', 2),
('Scarlett 2i2', 'Console', 'Focusrite', 180.00, 'Bon', 2),
('SM7B', 'Micro', 'Shure', 450.00, 'Bon', 3),
('DM32', 'Console', 'Yamaha', 3500.00, 'Bon', 3),
('KRK Rokit 8', 'Enceinte', 'KRK', 600.00, 'Usagé', 3),
('C214', 'Micro', 'AKG', 350.00, 'Bon', 4),
('HD 650', 'Casque', 'Sennheiser', 450.00, 'Bon', 4),
('SSL 2+', 'Console', 'Solid State Logic', 320.00, 'Neuf', 5),
('Genelec 8040', 'Enceinte', 'Genelec', 1800.00, 'Bon', 5),
('XLR 10m', 'Câble', 'Mogami', 85.00, 'Bon', NULL),
('DI Box', 'Autre', 'Radial', 250.00, 'En panne', NULL);

-- ============================================
-- SESSIONS (25 sessions)
-- ============================================
INSERT INTO session_enregistrement (date_session, heure_debut, heure_fin, statut, notes, id_artiste, id_salle, id_ingenieur) VALUES
('2025-01-10', '09:00', '12:00', 'terminee', 'Enregistrement voix album Reflets II', 1, 1, 1),
('2025-01-10', '14:00', '17:00', 'terminee', 'Session guitares', 2, 3, 2),
('2025-01-15', '10:00', '13:00', 'terminee', 'Prise de voix', 3, 4, 4),
('2025-01-20', '09:00', '11:00', 'terminee', 'Enregistrement rap', 4, 1, 1),
('2025-01-25', '14:00', '18:00', 'terminee', 'Session jazz quartet', 5, 3, 2),
('2025-02-01', '09:00', '12:00', 'terminee', 'Mixage album', 6, 5, 1),
('2025-02-05', '10:00', '14:00', 'terminee', 'Production beats', 7, 1, 3),
('2025-02-10', '09:00', '13:00', 'terminee', 'Enregistrement guitares', 8, 3, 2),
('2025-02-15', '14:00', '17:00', 'terminee', 'Session synthés', 9, 1, 3),
('2025-02-20', '10:00', '12:00', 'terminee', 'Enregistrement violoncelle', 10, 4, 4),
('2025-03-01', '09:00', '12:00', 'terminee', 'DJ set recording', 11, 1, 3),
('2025-03-05', '14:00', '17:00', 'terminee', 'Guitare acoustique', 12, 4, 4),
('2025-03-10', '10:00', '14:00', 'terminee', 'Quatuor à cordes', 13, 3, 2),
('2025-03-15', '09:00', '11:00', 'terminee', 'Session voix pop', 14, 4, 4),
('2025-03-20', '14:00', '18:00', 'terminee', 'Session rap + beats', 15, 1, 3),
('2025-04-01', '09:00', '12:00', 'confirmee', 'Mastering album', 1, 5, 6),
('2025-04-05', '10:00', '13:00', 'confirmee', 'Enregistrement live', 2, 3, 2),
('2025-04-10', '14:00', '17:00', 'confirmee', 'Session podcast', 16, 2, 4),
('2025-04-15', '09:00', '12:00', 'planifiee', 'Prise de son classique', 18, 3, 2),
('2025-04-20', '14:00', '17:00', 'planifiee', 'Session folk', 19, 4, 4),
('2025-04-25', '10:00', '14:00', 'planifiee', 'Production hip-hop', 20, 1, 3),
('2025-05-01', '09:00', '11:00', 'planifiee', 'Mastering', 8, 5, 6),
('2025-05-05', '14:00', '18:00', 'planifiee', 'Enregistrement live band', 16, 3, 2),
('2025-05-10', '10:00', '13:00', 'planifiee', 'Session R&B', 14, 1, 1),
('2025-05-15', '09:00', '12:00', 'annulee', 'Annulé par artiste', 17, 1, 3);

-- ============================================
-- FACTURES (20 factures)
-- ============================================
INSERT INTO facture (date_facture, montant_total, statut_paiement, id_artiste, id_session) VALUES
('2025-01-10', 450.00, 'payee', 1, 1),
('2025-01-10', 600.00, 'payee', 2, 2),
('2025-01-15', 180.00, 'payee', 3, 3),
('2025-01-20', 300.00, 'payee', 4, 4),
('2025-01-25', 800.00, 'payee', 5, 5),
('2025-02-01', 360.00, 'payee', 6, 6),
('2025-02-05', 600.00, 'payee', 7, 7),
('2025-02-10', 800.00, 'payee', 8, 8),
('2025-02-15', 450.00, 'en_retard', 9, 9),
('2025-02-20', 120.00, 'payee', 10, 10),
('2025-03-01', 450.00, 'impayee', 11, 11),
('2025-03-05', 180.00, 'payee', 12, 12),
('2025-03-10', 800.00, 'impayee', 13, 13),
('2025-03-15', 120.00, 'payee', 14, 14),
('2025-03-20', 600.00, 'en_retard', 15, 15),
('2025-04-01', 360.00, 'impayee', 1, 16),
('2025-04-05', 600.00, 'impayee', 2, 17),
('2025-04-10', 240.00, 'impayee', 16, 18),
('2025-01-30', 500.00, 'payee', 4, NULL),
('2025-02-28', 750.00, 'payee', 5, NULL);

-- ============================================
SELECT '✅ Données insérées avec succès !' AS message;
SELECT 'Artistes:', COUNT(*) FROM artiste
UNION ALL SELECT 'Albums:', COUNT(*) FROM album
UNION ALL SELECT 'Sessions:', COUNT(*) FROM session_enregistrement
UNION ALL SELECT 'Factures:', COUNT(*) FROM facture;
