# Minetest Server Manager

A basic server manager for Minetest

## Usage

Install this tool:

	git clone https://github.com/mt-server-tools/server-manager
	cd server-manager
	sudo ./install


## Planning

### Stage 1

* Installs PPA and minetest, and supporting libraries
* Creates accounts for servers
* Pre-configures use of LevelDB
* Creates systemd services

### Stage 2

* Add mod pull/install tool to add mods to the global mod folder

### Stage 3

* Support using Docker images
