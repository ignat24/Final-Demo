#!/bin/bash
echo ECS_CLUSTER=Cluster-${env}-${app} > /etc/ecs/ecs.config

# sudo yum -y update
# sudo yum -y install httpd
# cd /var/www
# chgrp ec2-user html
# chown ec2-user html
# cd html

# cat <<EOF > index.html
# <!DOCTYPE html>
# <html>
# <body>
# <center>
# <h1>Telegram bot's page</h1>
# <p>Some description!</p>

# </center>
# </body>
# </html>
# EOF

# sudo service httpd start
# sudo chkconfig httpd on
