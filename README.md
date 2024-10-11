# setup_apache2_vhost

This script automates the setup of Apache2 virtual host configurations. It takes a domain name as an argument and generates the corresponding configuration file in `/etc/apache2/sites-available/`. The script also handles existing configurations by disabling and removing them before creating new ones.

## Features

- Automatically creates and enables Apache2 virtual host configurations.
- Handles existing configurations by disabling and removing them.
- Creates the document root directory and sets appropriate permissions.
- Provides detailed output of created directories and files.

## Prerequisites

- Apache2 installed on your system.
- `sudo` privileges to manage Apache2 configurations.

## Usage

1. **Clone the Repository**:

   ```bash
   git clone https://github.com/ToRxmrig/setup_apache2_vhost.git
   cd setup_apache2_vhost
   chmod +x setup_apache_vhost.sh
   ./setup_apache_vhost.sh YOURDOMAIN.com
   ```

1. **Validate the files**:
    ```bash
   script will print the locations for you.
    ```
