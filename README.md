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
2. Navigate to the cloned repository: `cd openvpn-docker-compose`
3. Edit the `settings` file to configure your VPN settings.
4. Run `./startvpn` to start the OpenVPN server.
5. Run `./addclient <client-name>` to generate an OpenVPN client configuration file for a new client.
6. The client configuration file will be created in the `clients` directory.

## Contributors

- HAL9000 (https://github.com/pingpongdash)
- ChatGPT (https://github.com/chatgpt)

## License

This project is licensed under the [MIT License](https://opensource.org/licenses/MIT).


## Acknowledgements

I would like to express my sincere gratitude to ChatGPT and its developers for their invaluable assistance in the creation of this project.
