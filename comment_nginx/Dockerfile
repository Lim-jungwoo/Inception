FROM alpine:3.13

# openssl req는 certificate request를 만들어준다.
# -new 옵션은 새로운 certificate request를 만든다.
# -newkey arg옵션은 새로운 certificate request를 만들고 새로운 private key를 만든다.
# arg는 여러 form중 하나를 가지는데, rsa:nbits form은 nbits는 RSA key를 nbits크기만큼 생성한다.
# nbits가 생략되었을 경우에는 configuration file에서 정의되어 있는 크기가 key의 default 크기가 된다.
# -x509옵션은 certificate request대신에 self signed certificate를 출력한다.
# -x509옵션은 주로 test certificate를 만들거나 self signed root CA를 만들 때 사용한다.
# -days n 옵션은 -x509옵션이 사용되었을 경우에 n일만큼 certificate가 유효하게 만든다. default는 30일이다.
# -nodes옵션이 사용되면 private key가 생성되었다면 private key를 암호화하지 않는다.
# -out filename 옵션이 사용되면 filename에 내용을 작성한다. default는 standard output이다.
# -keyout filename 옵션은 filename에 새로 생성된 private key를 작성한다. 이 옵션이 없다면 filename은 configuration file에 존재하는 것이 사용된다.
# -subj arg 옵션은 요청을 처리할 때 새로운 request의 subject name을 설정하거나 subject name을 대체한다.
# arg의 형식은 /type0=value0/type1=value1 ... 이며, 문자들은 \로 escape할 수 있으며, 공백을 건너뛰지 않는다.

# ln명령어의 -s 옵션은 심볼릭 링크를 생성할 때 사용하고, -f옵션은 링크 파일이 이미 존재했다면 삭제하고 생성한다.

RUN	apk update && \
	apk add nginx openssl && \
	wget -O /usr/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.5/dumb-init_1.2.5_x86_64 && \
	chmod +x /usr/bin/dumb-init && \
	mkdir -p /etc/nginx/tls /var/run/nginx && \
	openssl req -new -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -out /etc/nginx/tls/jseo.42.fr.crt -keyout /etc/nginx/tls/jseo.42.fr.key -subj "/C=KR/ST=Seoul/L=Songpa-gu/O=42/OU=42Seoul/CN=jseo.42.fr" && \
	ln -sf /dev/stdout /var/log/nginx/access.log && \
	ln -sf /dev/stderr /var/log/nginx/error.log && \
	rm -rf /etc/nginx/conf.d/default.conf

COPY conf/nginx.conf /tmp/nginx.conf
COPY tools/script.sh /tmp/script.sh

RUN chmod +x /tmp/script.sh

# 443 port를 오픈한다.
EXPOSE	443

ENTRYPOINT [ "/usr/bin/dumb-init", "--" ]

CMD [ "sh", "-c", "/tmp/script.sh" ]