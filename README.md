This Dockerfile is based on the official `php:5.6.11-apache` image and includes customizations to add support for Oracle Database (OCI8 extension). It’s tailored for environments requiring PHP 5.6 compatibility with Oracle 12c, perfect for legacy applications and database integration.

## Key Features
- **PHP 5.6 Environment**: Based on the official PHP 5.6 image, ensuring compatibility with legacy applications.
- **Apache Server**: Comes pre-configured with Apache, enabling quick deployment of web applications.
- **Oracle Instant Client**: Includes Oracle Instant Client libraries for seamless interaction with Oracle databases.
- **OCI8 Extension**: The OCI8 PHP extension is pre-installed for easy access to Oracle database functionalities.

## Getting Started
 Use the following command to pull the Docker image from [Docker Hub](https://hub.docker.com/r/irfangani/php56-apache-oci8):

```bash
docker pull irfangani/php56-apache-oci8
```

## Usage Scenarios
- Ideal for running legacy applications that require PHP 5.6 and Oracle database connectivity.
- Suitable for development and testing environments for PHP applications using Oracle.
- Lightweight deployment of PHP applications without the hassle of manual dependency installations.
