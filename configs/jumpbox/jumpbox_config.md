\# ML-SRV-JUMP-01 Configuration

Date : 24/03/2026

Projet : MediLink — Jedha Bootcamp 2025



\## Informations machine

\- Nom : ML-SRV-JUMP-01

\- Rôle : Serveur Jumpbox (rebond SSH sécurisé)

\- VLAN : 10 (Admin)

\- IP : 192.168.10.10/28

\- Gateway : 192.168.10.1

\- Interface : ens4

\- OS : Debian 12.6



\## Etape 1 - Configuration IP temporaire

sudo ip addr add 192.168.10.10/28 dev ens4

sudo ip link set ens4 up

sudo ip route add default via 192.168.10.1

ip a

ping 192.168.10.1



\## Etape 2 - Sauvegarde permanente IP

sudo nano /etc/systemd/network/ens4.network

\[Match]

Name=ens4

\[Network]

Address=192.168.10.10/28

Gateway=192.168.10.1

DNS=8.8.8.8

sudo systemctl restart systemd-networkd



\## Etape 3 - Vérification SSH

sudo systemctl status ssh

sudo ss -tlnp | grep ssh



\## Etape 4 - Utilisateur admin\_jump

sudo adduser admin\_jump

sudo passwd admin\_jump

sudo usermod -aG sudo admin\_jump



\## Résultat final

IP 192.168.10.10/28 configurée et sauvegardée

Gateway 192.168.10.1 configurée

OpenSSH actif sur port 22

Utilisateur admin\_jump créé avec droits sudo

