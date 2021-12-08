FROM python:buster
RUN pip3 install pyTelegramBotAPI==2.2.3
RUN pip3 install --upgrade pyTelegramBotAPI
WORKDIR /usr/src/app
COPY ./main.py .
COPY ./text.txt .
CMD [ "python3", "main.py" ]


# FROM alpine:3.14

# RUN apk --no-cache update
# RUN apk add --no-cache apache2

# WORKDIR /var/www/localhost/htdocs
# COPY  ./index.html  /var/www/localhost/htdocs 

# CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]

# EXPOSE 80