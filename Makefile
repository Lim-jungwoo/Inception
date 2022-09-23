NAME = inception

all: $(NAME)
.PHONY: all

$(NAME):
	sudo mkdir -p /home/jlim/data/wordpress home/jlim/data/mariadb

grep "jlim.42.fr" /etc/hosts > /dev/null
ifeq ($?, 1)
	sudo echo "127.0.0.1 jlim.42.fr" >> /etc/hosts
endif

	sudo docker-compose -f srcs/docker-compose.yml --force-recreate --build

clean:
	sudo docker-compose -f srcs/docker-compose.yml down -v --rmi all --remove-orphans
.PHONY: clean

fclean: clean
	sudo rm -rf /home/jlim/data
	sudo docker system prune --volumes --all --force
	sudo docker network prune --force
	sudo docker volume prune --force
.PHONY: fclean

re: fclean all
.PHONY: re

restart:
	sudo docker-compose -f srcs/docker-compose.yml restart
.PHONY: restart

log:
	sudo docker-compose -f srcs/docker-compose.yml logs -f
.PHONY: log

ps:
	sudo docker-compose -f srcs/docker-compose.yml ps
.PHONY: ps