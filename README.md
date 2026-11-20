# Fix NVIDIA Quadro & Switch to Nouveau

Un script d'automatisation en **Bash** conçu pour purger proprement les pilotes propriétaires NVIDIA défectueux sous Linux (Debian/Ubuntu) et restaurer le pilote libre `nouveau`.

## Fonctionnalités
- Vérification des privilèges administrateur (`root`).
- Analyse préventive des logs Xorg et détection de la session (Wayland / X11).
- Énumération dynamique et purge ciblée des paquets NVIDIA installés.
- Nettoyage des dépendances orphelines (`autoremove`).
- Réinstallation propre du pilote libre et de la pile Mesa.
- Mise à jour de l'initramfs et du GRUB, avec option de redémarrage automatique.

## Utilisation

```bash
git clone https://github.com/em-i/linux-legacy-maintenance.git
cd linux-legacy-maintenance
sudo ./fix_nvidia_quadro.sh
