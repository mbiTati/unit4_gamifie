-- ============================================
-- SwissSound Studios — Vues, Procédures, Sécurité
-- Scripts 03-04 : Modules 15-16
-- ============================================

USE swisssound;

-- ============================================
-- MODULE 15 : VUES
-- ============================================

-- Vue 1 : Artistes actifs avec leurs genres
CREATE OR REPLACE VIEW v_artistes_actifs AS
SELECT a.id_artiste, a.nom, a.prenom, a.email, a.telephone, a.date_inscription,
       GROUP_CONCAT(g.nom SEPARATOR ', ') AS genres
FROM artiste a
LEFT JOIN genre_artiste ga ON a.id_artiste = ga.id_artiste
LEFT JOIN genre g ON ga.id_genre = g.id_genre
WHERE a.actif = TRUE
GROUP BY a.id_artiste;

-- Vue 2 : Sessions du mois en cours
CREATE OR REPLACE VIEW v_sessions_mois AS
SELECT se.id_session, se.date_session, se.heure_debut, se.heure_fin, se.statut,
       a.nom AS artiste, s.nom AS salle, 
       CONCAT(i.prenom, ' ', i.nom) AS ingenieur
FROM session_enregistrement se
JOIN artiste a ON se.id_artiste = a.id_artiste
JOIN salle s ON se.id_salle = s.id_salle
JOIN ingenieur i ON se.id_ingenieur = i.id_ingenieur
WHERE MONTH(se.date_session) = MONTH(CURDATE())
  AND YEAR(se.date_session) = YEAR(CURDATE());

-- Vue 3 : Dashboard CA
CREATE OR REPLACE VIEW v_dashboard_ca AS
SELECT a.nom AS artiste, 
       COUNT(f.id_facture) AS nb_factures,
       SUM(CASE WHEN f.statut_paiement = 'payee' THEN f.montant_total ELSE 0 END) AS ca_paye,
       SUM(CASE WHEN f.statut_paiement IN ('impayee','en_retard') THEN f.montant_total ELSE 0 END) AS ca_impaye
FROM artiste a
LEFT JOIN facture f ON a.id_artiste = f.id_artiste
GROUP BY a.id_artiste, a.nom
ORDER BY ca_paye DESC;

-- ============================================
-- MODULE 15 : PROCÉDURES STOCKÉES
-- ============================================

DELIMITER //

-- Procédure 1 : Ajouter une session
CREATE PROCEDURE sp_ajouter_session(
  IN p_date DATE,
  IN p_debut TIME,
  IN p_fin TIME,
  IN p_artiste_id INT,
  IN p_salle_id INT,
  IN p_ingenieur_id INT,
  IN p_notes TEXT
)
BEGIN
  -- Vérifier disponibilité salle
  DECLARE v_conflit INT;
  SELECT COUNT(*) INTO v_conflit
  FROM session_enregistrement
  WHERE id_salle = p_salle_id
    AND date_session = p_date
    AND statut NOT IN ('annulee')
    AND ((heure_debut < p_fin AND heure_fin > p_debut));
  
  IF v_conflit > 0 THEN
    SIGNAL SQLSTATE '45000' 
    SET MESSAGE_TEXT = 'Conflit : la salle est déjà réservée à cette date/heure';
  ELSE
    INSERT INTO session_enregistrement (date_session, heure_debut, heure_fin, statut, notes, id_artiste, id_salle, id_ingenieur)
    VALUES (p_date, p_debut, p_fin, 'planifiee', p_notes, p_artiste_id, p_salle_id, p_ingenieur_id);
    SELECT LAST_INSERT_ID() AS id_session_cree, 'Session créée avec succès' AS message;
  END IF;
END //

-- Procédure 2 : Générer une facture pour une session
CREATE PROCEDURE sp_generer_facture(
  IN p_session_id INT
)
BEGIN
  DECLARE v_artiste INT;
  DECLARE v_tarif_salle DECIMAL(8,2);
  DECLARE v_tarif_ing DECIMAL(8,2);
  DECLARE v_heures DECIMAL(5,2);
  DECLARE v_montant DECIMAL(10,2);
  
  -- Récupérer les infos de la session
  SELECT se.id_artiste, 
         TIMESTAMPDIFF(MINUTE, se.heure_debut, se.heure_fin) / 60.0,
         s.tarif_horaire,
         i.tarif_horaire
  INTO v_artiste, v_heures, v_tarif_salle, v_tarif_ing
  FROM session_enregistrement se
  JOIN salle s ON se.id_salle = s.id_salle
  JOIN ingenieur i ON se.id_ingenieur = i.id_ingenieur
  WHERE se.id_session = p_session_id;
  
  SET v_montant = ROUND((v_tarif_salle + v_tarif_ing) * v_heures, 2);
  
  INSERT INTO facture (montant_total, id_artiste, id_session)
  VALUES (v_montant, v_artiste, p_session_id);
  
  SELECT LAST_INSERT_ID() AS id_facture, v_montant AS montant, 'Facture générée' AS message;
END //

DELIMITER ;

-- ============================================
-- MODULE 15 : FONCTION
-- ============================================

DELIMITER //

CREATE FUNCTION fn_ca_artiste(p_artiste_id INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
READS SQL DATA
BEGIN
  DECLARE v_ca DECIMAL(10,2);
  SELECT IFNULL(SUM(montant_total), 0) INTO v_ca
  FROM facture
  WHERE id_artiste = p_artiste_id AND statut_paiement = 'payee';
  RETURN v_ca;
END //

DELIMITER ;

-- Test de la fonction
SELECT nom, fn_ca_artiste(id_artiste) AS ca_paye FROM artiste ORDER BY ca_paye DESC LIMIT 5;

-- ============================================
-- MODULE 15 : TRIGGER
-- ============================================

DELIMITER //

-- Trigger : mettre à jour le statut de session quand une facture est payée
CREATE TRIGGER trg_after_facture_payee
AFTER UPDATE ON facture
FOR EACH ROW
BEGIN
  IF NEW.statut_paiement = 'payee' AND OLD.statut_paiement != 'payee' THEN
    UPDATE session_enregistrement 
    SET statut = 'terminee'
    WHERE id_session = NEW.id_session AND statut = 'confirmee';
  END IF;
END //

DELIMITER ;

-- ============================================
-- MODULE 16 : SÉCURITÉ
-- ============================================

-- Création des utilisateurs (à exécuter en tant que root)
-- CREATE USER 'admin_studio'@'localhost' IDENTIFIED BY 'Admin$tud10!';
-- CREATE USER 'ingenieur_son'@'localhost' IDENTIFIED BY 'Ing3n1eur!';
-- CREATE USER 'comptable'@'localhost' IDENTIFIED BY 'C0mpt@ble!';
-- CREATE USER 'reception'@'localhost' IDENTIFIED BY 'R3cept10n!';

-- Droits admin (tout sur swisssound)
-- GRANT ALL PRIVILEGES ON swisssound.* TO 'admin_studio'@'localhost';

-- Droits ingénieur (sessions + salles + équipements)
-- GRANT SELECT, INSERT, UPDATE ON swisssound.session_enregistrement TO 'ingenieur_son'@'localhost';
-- GRANT SELECT ON swisssound.salle TO 'ingenieur_son'@'localhost';
-- GRANT SELECT ON swisssound.equipement TO 'ingenieur_son'@'localhost';
-- GRANT SELECT ON swisssound.artiste TO 'ingenieur_son'@'localhost';
-- GRANT SELECT ON swisssound.v_sessions_mois TO 'ingenieur_son'@'localhost';

-- Droits comptable (factures + consultation)
-- GRANT SELECT, INSERT, UPDATE ON swisssound.facture TO 'comptable'@'localhost';
-- GRANT SELECT ON swisssound.artiste TO 'comptable'@'localhost';
-- GRANT SELECT ON swisssound.session_enregistrement TO 'comptable'@'localhost';
-- GRANT SELECT ON swisssound.v_dashboard_ca TO 'comptable'@'localhost';
-- GRANT EXECUTE ON PROCEDURE swisssound.sp_generer_facture TO 'comptable'@'localhost';

-- Droits réception (artistes + consultation)
-- GRANT SELECT, INSERT, UPDATE ON swisssound.artiste TO 'reception'@'localhost';
-- GRANT SELECT, INSERT ON swisssound.genre_artiste TO 'reception'@'localhost';
-- GRANT SELECT ON swisssound.genre TO 'reception'@'localhost';
-- GRANT SELECT ON swisssound.v_artistes_actifs TO 'reception'@'localhost';

-- FLUSH PRIVILEGES;

SELECT '✅ Vues, procédures, fonctions et triggers créés !' AS message;
