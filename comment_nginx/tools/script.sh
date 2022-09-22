# !/bin/sh

if [ ! -f "/etc/nginx/conf.d/default.conf" ]; then
	cp /tmp/nginx.conf /etc/nginx/conf.d/default.conf
	# WordPress가 실행될 때까지 기다린다.
	sleep 5;
fi

# dumb init으로 실행한다.
# nginx의 -g옵션은 뒤의 global directive의 설정으로 nginx를 실행한다.
# 즉, daemon off라는 golbal directive의 설정으로 nginx가 실행된다.
# daemon off는 nginx 서버를 foreground에서 실행할 수 있게 해준다.
nginx -g 'daemon off;'