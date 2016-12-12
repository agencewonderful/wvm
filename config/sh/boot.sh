#
# boot.sh
#	This file is loaded each time the NOE-VM is launched
#
echo "Restarting apache";
sudo systemctl restart apache2

echo "Reload phpMyAdmin's config"
sudo cp /vagrant/config/phpmyadmin/config.inc.php /etc/phpmyadmin/config.inc.php