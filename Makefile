NAME	=	inception

.PHONY:	all
all:	$(NAME)

$(NAME):
# make directory which is used by wordpress and mariadb in host machine
	sudo mkdir -p /home/jlim/data/wordpress /home/jlim/data/mariadb

# use shell grep command to check /etc/hosts file has jlim.42.fr
# /etc/hosts file has information which url redirects to IP address
# if /etc/hosts file has not jlim.42.fr
# use chmod to change right about /etc/hosts, because /etc/hosts has no write permission
# use echo to add "127.0.0.1 jlim.42.fr" to the /etc/hosts file, so "jlim.42.fr" redirect to 127.0.0.1
# if /etc/hosts file has already jlim.42.fr, this action is skip
ifeq ($(shell grep jlim.42.fr /etc/hosts > /dev/null 2>/dev/null; echo $$?), 1)
	sudo chmod 777 /etc/hosts
	sudo echo "127.0.0.1 jlim.42.fr" >> /etc/hosts
endif

# docker-compose command -f option is specified the location of docker-compose.yml
# docker-compose up command is docker image build and run
# --force-recreate option is stop the compose and rebuild all container
# --build option is unconditionally start to build and no check caching image 
# if code is modified, the image needs to be rebuild. therefore, --build option is recommended
# if you want to execute in background, use -d option
	sudo docker-compose -f srcs/docker-compose.yml up --force-recreate --build

.PHONY:	clean
clean:
# docker-compose down option is docker container stop
# -v option is delete data volume in docker-compose file
# --rmi option is remove images, --rmi all is remove all images
# --remove-orphans option is remove orphan-container(containers for services not defined in the compose file)
	sudo docker-compose -f srcs/docker-compose.yml down -v --rmi all --remove-orphans

.PHONY:	fclean
fclean:	clean
# use rm -rf to remove /home/jlim/data
	sudo rm -rf /home/jlim/data
# docker system prune is remove all unused networks in container
# --volumes option is remove volume
# --all option is remove all unused images, --force option is not asking to remove
	sudo docker system prune --volumes --all --force
# docker network prune is remove all unused network, --force option is not asking to remove
	sudo docker network prune --force
# docker volume prune is remove all unused volume, --force option is not asking to remove
	sudo docker volume prune --force

.PHONY:	re
re:	fclean	all

.PHONY:	restart
restart:
# docker-compose restart option is restart all stopped services
# restart option is not reflected even if docker-compose.yml, configuration is modified
	sudo docker-compose -f srcs/docker-compose.yml restart

.PHONY:	log
log:
# docker-compose logs option is viewing output from containers
# -f option is follow log output
	sudo docker-compose -f srcs/docker-compose.yml logs -f

.PHONY: ps
ps:
# docker-compose ps option is listing containers
	sudo docker-compose -f srcs/docker-compose.yml ps