-- GESCOM simplifie pour le bac a sable SQL (SQLite)
-- 6 tables principales issues du cas Gestion Commerciale

CREATE TABLE famille (nofam INTEGER PRIMARY KEY, libfam TEXT NOT NULL);
CREATE TABLE fournisseur (nofour INTEGER PRIMARY KEY, nomfour TEXT, ruefour TEXT, villefour TEXT, cpfour TEXT);
CREATE TABLE article (noart INTEGER PRIMARY KEY, desart TEXT, prix REAL, qtesto INTEGER, qtemin INTEGER, nofam INTEGER, nofour INTEGER, FOREIGN KEY(nofam) REFERENCES famille(nofam), FOREIGN KEY(nofour) REFERENCES fournisseur(nofour));
CREATE TABLE client (nocli INTEGER PRIMARY KEY, nomcli TEXT, prenomcli TEXT, ruecli TEXT, villecli TEXT, cpcli TEXT, cacli REAL DEFAULT 0);
CREATE TABLE commande (nocde INTEGER PRIMARY KEY, datecde TEXT, nocli INTEGER, FOREIGN KEY(nocli) REFERENCES client(nocli));
CREATE TABLE lignecde (nocde INTEGER, noart INTEGER, qtecde INTEGER, PRIMARY KEY(nocde, noart), FOREIGN KEY(nocde) REFERENCES commande(nocde), FOREIGN KEY(noart) REFERENCES article(noart));

INSERT INTO famille VALUES(1,'VTT'),(2,'Route'),(3,'Urbain'),(4,'Accessoire'),(5,'Electrique');
INSERT INTO fournisseur VALUES(1,'Cycleurope','Rue du Lac','Lausanne','1000'),(2,'Shimano SA','Av. Leopold','Geneve','1200'),(3,'Trek Suisse','Bvd des Alpes','Berne','3000');
INSERT INTO article VALUES(1,'VTT Explorer 26',899.00,15,3,1,1),(2,'Route Carbon Pro',2499.00,5,1,2,1),(3,'City Cruiser',599.00,20,5,3,1),(4,'Casque Pro X',89.00,50,10,4,2),(5,'Gants Hiver',45.00,80,20,4,2),(6,'Antivol U-Lock',35.00,60,15,4,3),(7,'VTT Junior 20',449.00,12,3,1,1),(8,'E-Bike Urban',1899.00,8,2,5,3),(9,'Pompe Pro',29.00,100,25,4,2),(10,'Sacoche Arriere',55.00,30,8,4,3);
INSERT INTO client VALUES(1,'Muller','Thomas','Rue de Bourg','Lausanne','1003',1250.00),(2,'Dubois','Sophie','Ch. des Vignes','Geneve','1206',890.00),(3,'Favre','Nicolas','Av. de la Gare','Fribourg','1700',0),(4,'Roche','Julie','Rue du Marche','Neuchatel','2000',2100.00),(5,'Bonvin','Emilie','Pl. Centrale','Sion','1950',450.00);
INSERT INTO commande VALUES(1,'2025-01-15',1),(2,'2025-01-20',2),(3,'2025-02-01',1),(4,'2025-02-10',3),(5,'2025-02-15',4),(6,'2025-03-01',2),(7,'2025-03-10',5),(8,'2025-03-15',1);
INSERT INTO lignecde VALUES(1,1,1),(1,4,2),(2,3,1),(2,5,3),(3,6,2),(3,9,1),(4,7,1),(5,2,1),(5,4,1),(6,8,1),(6,6,1),(7,5,2),(7,9,3),(8,1,1),(8,4,1),(8,5,2);
