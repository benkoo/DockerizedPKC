CURRENT_TIME = $(shell date +'%y.%m.%d %H:%M:%S')
BACKUPANDRESTORE_DIR=/var/www/html/extensions/BackupAndRestore

build: 
	docker build -t xlp0/pkcv --build-arg BUILD_SMW=false .
buildAndPush:
	docker build -t xlp0/pkcv --build-arg BUILD_SMW=false .
	docker push xlp0/pkcv

push:
	docker push xlp0/pkcv

build_no_cache: 
	docker build --no-cache -t xlp0/pkcv .

push_no_cache: 
	docker push xlp0/pkcv

commitToGitHub:
	git add .
	git commit -m 'Created Makefile for the first time, and committed at ${CURRENT_TIME}'
	git push origin main


init:
	./up.sh

shutdown:
	docker-compose down --volumes 

removeAllImages:
	docker-compose down --volumes 
	docker rmi -f $(shell docker images -q)

