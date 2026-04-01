# ==========================================================
# Analyse - Test Web vers BDD + Verrouillage bind-address
# Serveur : ML-SRV-WEB-01
# Projet  : MediLink
# ==========================================================


# ----------------------------------------------------------
# 1. Verification bind-address MySQL
# ----------------------------------------------------------

# Le bind-address definit sur quelle interface MySQL ecoute :
# 0.0.0.0   = ecoute sur tout le reseau = dangereux
# 127.0.0.1 = ecoute uniquement en local = securise

# Verification dans le fichier de configuration
grep "bind-address" /etc/mysql/mariadb.conf.d/50-server.cnf
# Resultat : bind-address = 127.0.0.1 => OK

# Verification que MySQL n'ecoute sur aucun port TCP reseau
sudo ss -tlnp | grep mysql
# Resultat : aucune ligne affichee
# MySQL utilise un socket Unix uniquement => non expose sur le reseau => OK


# ----------------------------------------------------------
# 2. Test connexion utilisateur applicatif vers BDD
# ----------------------------------------------------------

# Connexion avec l'utilisateur de l'application
mysql -u medilink_app -p -h 127.0.0.1 -e "SHOW DATABASES;"
# Resultat :
# | information_schema |
# | medilink           |
# Connexion reussie - medilink_app accede uniquement a sa base => OK


# ----------------------------------------------------------
# 3. Test Nginx et redirection HTTPS
# ----------------------------------------------------------

# Test redirection HTTP vers HTTPS
curl -s http://localhost | head -20
# Resultat : 301 Moved Permanently - nginx/1.22.1 => OK

# Test page HTTPS
curl -sk https://localhost | head -20
# Resultat : <title>MediLink - Cabinet Medical Pluridisciplinaire</title>
# Page accessible en HTTPS => OK


# ----------------------------------------------------------
# 4. Test erreurs PHP vers BDD
# ----------------------------------------------------------

# Verification absence d'erreurs PHP/BDD sur la page login
curl -sk https://localhost/login | grep -i "error\|mysql\|database"
# Resultat : aucune erreur affichee
# PHP se connecte a la BDD sans erreur => OK


# ----------------------------------------------------------
# 5. Modifier bind-address si necessaire
# ----------------------------------------------------------

# Ouvrir le fichier de configuration
sudo nano /etc/mysql/mariadb.conf.d/50-server.cnf
# Verifier ou modifier la ligne : bind-address = 127.0.0.1

# Redemarrer MariaDB apres modification
sudo systemctl restart mariadb


# ----------------------------------------------------------
# Bilan
# ----------------------------------------------------------

# bind-address = 127.0.0.1                       => OK
# MySQL non expose sur le reseau                 => OK
# Connexion medilink_app vers BDD medilink        => OK
# Redirection HTTP vers HTTPS                    => OK
# Page MediLink accessible en HTTPS              => OK
# Aucune erreur PHP/BDD                          => OK
