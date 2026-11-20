#!/bin/bash

# S'assurer que le script est exécuté avec les privilèges root (sudo)
if [ "$EUID" -ne 0 ]; then
	echo "[-] Ce script doit être exécuté avec sudo :"
	echo "	sudo ./fix_nvidia_quadro.sh"
	exit 1
fi

echo "============================================================"
echo " [i] Recherche des erreurs NVIDIA dans les logs :"
if [ -f /var/log/Xorg.0.log ]; then
    grep -i "nvidia" /var/log/Xorg.0.log 2>/dev/null | tail -n 10
else
    echo " [-] Fichier /var/log/Xorg.0.log introuvable (Session Wayland ?)."
fi
echo "============================================================"
echo ""

echo " [i] Paquets NVIDIA actuellement détectés sur le système :"
dpkg -l | grep -i nvidia
echo "============================================================"
echo ""

read -p "Voulez-vous procéder à la purge des pilotes et basculer sur 'nouveau' ? [o/n] " -n 1 -r
echo 
if [[ ! $REPLY =~ ^[OoYy]$ ]]; then
	exit 0
fi

echo " [+] Etape 1 : Purge des pilotes NVIDIA..."
# Correction de la faute de frappe (dpkg) et utilisation d'une liste propre
NVIDIA_PACKAGES=$(dpkg -l | grep -i nvidia | awk '{print $2}')
if [ -n "$NVIDIA_PACKAGES" ]; then
    apt purge -y $NVIDIA_PACKAGES
else
    echo " [i] Aucun paquet NVIDIA trouvé à purger."
fi

echo " [+] Etape 2 : Nettoyage des paquets orphelins..."
apt autoremove --purge -y

echo "[+] Etape 3 : Réinstallation du pilote libre 'nouveau'..."
apt install --reinstall -y xserver-xorg-video-nouveau libgl1-mesa-dri

echo "[+] Etape 4 : Mise à jour de la configuration et de l'initramfs..."
update-grub
update-initramfs -u

echo "[ terminé ] La configuration a été nettoyée."
echo "Un redémarrage est indispensable pour activer le pilote libre."
echo ""
read -p 'Voulez-vous redémarrer maintenant ? [o/n] ' -n 1 -r
echo "" 
if [[ $REPLY =~ ^[OoYy]$ ]]; then
	reboot
fi

