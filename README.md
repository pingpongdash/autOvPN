# OpenVPN Docker Compose

This project provides a simple way to deploy an OpenVPN server using Docker Compose on an Amazon Linux 2 instance in AWS.

## Prerequisites

 - AWS account with appropriate permissions to create EC2 instances and security groups.
 - Amazon Linux 2 instance with kernel version 5.x.
 - Docker and docker-compose installed on the instance.
 - Python 3 and pip3 installed on the instance.
 ```
sudo yum install docker
sudo yum install python-pip
pip3 install docker-compose
 ```
 - Security group rules allowing inbound traffic on port 22 for SSH access and port 1194 for OpenVPN traffic.
 - **Note:** The security group rules can be added during the instance launch or can be added later in the AWS console. Please make sure to restrict the traffic sources to the IP addresses that require access to the VPN server.
 - **Note:** If you have configured the OpenVPN server to use a different port (e.g. 443), you will need to adjust the security group rules accordingly. Additionally, make sure to set the corresponding public port in the settings file.


## Usage

1. Clone this repository: `git clone https://github.com/pingpongdash/autOvPN.git`
2. Navigate to the cloned repository: `cd autOvPN`
3. Edit the `settings` file to configure your VPN settings.
```
####
# Set your desired VPN name (e.g. MyVPN)
VPN_NAME="Your-vpn-name"

####
# Enter your server's public URL or IP address
SERVER_URL="your-url-or-ip-addr"

####
# Set to 'yes' if you want clients to have internet access through the VPN, 'no' otherwise
ALLOW_INTERNET_ACCESS="yes"

####
# The port to be used for the VPN (default is 1194)
PUBLIC_PORT="1194"
```

4. Run `./startvpn` to start the OpenVPN server.
5. Run `./addclient <client-name>` to generate an OpenVPN client configuration file for a new client.
6. The client configuration file will be created in the `clients` directory.

7. If you want to customize the default values used in the script, you can edit the `.defaults` file. Here are the default values:

- PROTOCOL="udp": The protocol used by OpenVPN.
- VPN_SERVER_ADDR="192.168.11.0": The IP address of the OpenVPN server.
- VPN_SERVER_NETMASK="255.255.255.0": The netmask used by the OpenVPN server.
- SERVER_PORT="1194": The port used by the OpenVPN server.
- OVPN_SERVER_CONFIG_DIR="/etc/openvpn/server": The directory where the OpenVPN server configuration files are stored.
- OVPN_CLIENTS_CONFIG_DIR="/etc/openvpn/clients": The directory where the OpenVPN client configuration files are stored.
- SERVER_CONFIG_DIR="server": The name of the directory where the server-specific files are stored.
- CLIENT_CONFIG_DIR="clients": The name of the directory where the client-specific files are stored.
- ERSA_PATH="/usr/share/easy-rsa": The path to the directory containing the EasyRSA files.

## Contributors

- HAL9000 (https://github.com/pingpongdash)
- ChatGPT (https://github.com/chatgpt)

## License

This project is licensed under the [MIT License](https://opensource.org/licenses/MIT).


## Acknowledgements

I would like to express my sincere gratitude to ChatGPT and its developers for their invaluable assistance in the creation of this project.

