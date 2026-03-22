-- ============================================
-- SwissSound Studios — Requêtes SQL
-- Scripts 02-04 : SELECT, Agrégation, JOIN
-- Modules 12, 13, 14
-- ============================================

USE swisssound;

-- ============================================
-- MODULE 12 : SELECT de base
-- ============================================

-- 1. Tous les artistes actifs
SELECT * FROM artiste WHERE actif = TRUE;

-- 2. Artistes inscrits en 2024
SELECT nom, prenom, date_inscription FROM artiste 
WHERE YEAR(date_inscription) = 2024;

-- 3. Albums triés par prix décroissant
SELECT titre, prix FROM album ORDER BY prix DESC;

-- 4. Albums entre 20 et 30 CHF
SELECT titre, prix FROM album WHERE prix BETWEEN 20 AND 30;

-- 5. Artistes dont le nom commence par 'M'
SELECT nom, prenom FROM artiste WHERE nom LIKE 'M%';

-- 6. Artistes sans prénom (groupes)
SELECT nom, email FROM artiste WHERE prenom IS NULL;

-- 7. Top 5 albums les plus chers
SELECT titre, prix FROM album ORDER BY prix DESC LIMIT 5;

-- 8. Salles avec isolation acoustique
SELECT nom, capacite, tarif_horaire FROM salle WHERE equipee_isolation = TRUE;

-- 9. Sessions planifiées en avril 2025
SELECT * FROM session_enregistrement 
WHERE date_session BETWEEN '2025-04-01' AND '2025-04-30'
AND statut = 'planifiee';

-- 10. Équipements en panne
SELECT nom, categorie, marque FROM equipement WHERE etat = 'En panne';

-- ============================================
-- MODULE 13 : Agrégation + GROUP BY / HAVING
-- ============================================

-- 11. Nombre total d'artistes
SELECT COUNT(*) AS nb_artistes FROM artiste;

-- 12. Prix moyen des albums
SELECT ROUND(AVG(prix), 2) AS prix_moyen FROM album;

-- 13. Nombre d'albums PAR artiste
SELECT id_artiste, COUNT(*) AS nb_albums 
FROM album GROUP BY id_artiste ORDER BY nb_albums DESC;

-- 14. CA total des factures payées
SELECT SUM(montant_total) AS ca_total 
FROM facture WHERE statut_paiement = 'payee';

-- 15. CA par statut de paiement
SELECT statut_paiement, COUNT(*) AS nb, SUM(montant_total) AS total
FROM facture GROUP BY statut_paiement;

-- 16. Artistes avec plus de 1 album
SELECT id_artiste, COUNT(*) AS nb_albums 
FROM album GROUP BY id_artiste HAVING COUNT(*) > 1;

-- 17. Nombre de sessions par mois en 2025
SELECT MONTH(date_session) AS mois, COUNT(*) AS nb_sessions
FROM session_enregistrement 
WHERE YEAR(date_session) = 2025
GROUP BY MONTH(date_session) ORDER BY mois;

-- 18. Tarif horaire moyen par spécialité d'ingénieur
SELECT specialite, ROUND(AVG(tarif_horaire), 2) AS tarif_moyen
FROM ingenieur GROUP BY specialite;

-- 19. Salles avec plus de 3 équipements
SELECT id_salle, COUNT(*) AS nb_equip
FROM equipement WHERE id_salle IS NOT NULL
GROUP BY id_salle HAVING COUNT(*) > 3;

-- 20. Factures impayées total > 500 CHF par artiste
SELECT id_artiste, SUM(montant_total) AS total_impaye
FROM facture WHERE statut_paiement IN ('impayee', 'en_retard')
GROUP BY id_artiste HAVING SUM(montant_total) > 500;

-- ============================================
-- MODULE 14 : JOIN multi-tables
-- ============================================

-- 21. Albums avec nom d'artiste (INNER JOIN)
SELECT a.nom AS artiste, al.titre, al.prix
FROM artiste a 
INNER JOIN album al ON a.id_artiste = al.id_artiste
ORDER BY a.nom;

-- 22. Artistes SANS album (LEFT JOIN + IS NULL)
SELECT a.nom, a.prenom 
FROM artiste a 
LEFT JOIN album al ON a.id_artiste = al.id_artiste
WHERE al.id_album IS NULL;

-- 23. Sessions avec artiste + salle + ingénieur (3 tables)
SELECT se.date_session, se.heure_debut, se.heure_fin, se.statut,
       a.nom AS artiste, s.nom AS salle, 
       CONCAT(i.prenom, ' ', i.nom) AS ingenieur
FROM session_enregistrement se
JOIN artiste a ON se.id_artiste = a.id_artiste
JOIN salle s ON se.id_salle = s.id_salle
JOIN ingenieur i ON se.id_ingenieur = i.id_ingenieur
ORDER BY se.date_session;

-- 24. Factures impayées avec nom d'artiste
SELECT f.id_facture, f.date_facture, f.montant_total, 
       f.statut_paiement, a.nom AS artiste
FROM facture f
JOIN artiste a ON f.id_artiste = a.id_artiste
WHERE f.statut_paiement IN ('impayee', 'en_retard')
ORDER BY f.montant_total DESC;

-- 25. Genres de chaque artiste (via table associative)
SELECT a.nom AS artiste, GROUP_CONCAT(g.nom SEPARATOR ', ') AS genres
FROM artiste a
JOIN genre_artiste ga ON a.id_artiste = ga.id_artiste
JOIN genre g ON ga.id_genre = g.id_genre
GROUP BY a.id_artiste, a.nom
ORDER BY a.nom;

-- 26. Équipements par salle avec détails
SELECT s.nom AS salle, e.nom AS equipement, e.categorie, e.marque, e.etat
FROM salle s
LEFT JOIN equipement e ON s.id_salle = e.id_salle
ORDER BY s.nom, e.categorie;

-- 27. CA par artiste (avec nom)
SELECT a.nom, a.prenom, 
       COUNT(f.id_facture) AS nb_factures,
       SUM(f.montant_total) AS ca_total
FROM artiste a
LEFT JOIN facture f ON a.id_artiste = f.id_artiste
GROUP BY a.id_artiste, a.nom, a.prenom
HAVING ca_total > 0
ORDER BY ca_total DESC;

-- 28. Taux d'occupation des salles (nb sessions par salle)
SELECT s.nom AS salle, COUNT(se.id_session) AS nb_sessions,
       SUM(TIMESTAMPDIFF(HOUR, se.heure_debut, se.heure_fin)) AS heures_totales
FROM salle s
LEFT JOIN session_enregistrement se ON s.id_salle = se.id_salle
GROUP BY s.id_salle, s.nom
ORDER BY nb_sessions DESC;

-- 29. Ingénieur le plus demandé
SELECT CONCAT(i.prenom, ' ', i.nom) AS ingenieur, i.specialite,
       COUNT(se.id_session) AS nb_sessions
FROM ingenieur i
LEFT JOIN session_enregistrement se ON i.id_ingenieur = se.id_ingenieur
GROUP BY i.id_ingenieur
ORDER BY nb_sessions DESC
LIMIT 1;

-- 30. Dashboard complet : KPI SwissSound
SELECT 'Artistes actifs' AS kpi, COUNT(*) AS valeur FROM artiste WHERE actif = TRUE
UNION ALL
SELECT 'Albums', COUNT(*) FROM album
UNION ALL
SELECT 'Sessions terminées', COUNT(*) FROM session_enregistrement WHERE statut = 'terminee'
UNION ALL
SELECT 'CA total (CHF)', SUM(montant_total) FROM facture WHERE statut_paiement = 'payee'
UNION ALL
SELECT 'Factures impayées', COUNT(*) FROM facture WHERE statut_paiement IN ('impayee', 'en_retard');
