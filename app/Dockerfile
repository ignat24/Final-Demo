FROM python:buster
RUN pip3 install pyTelegramBotAPI==2.2.3
RUN pip3 install --upgrade pyTelegramBotAPI
WORKDIR /usr/src/app
COPY ./main.py .
# ENTRYPOINT [ "python3" ]
CMD [ "python3", "main.py" ]