FROM python:3.7-alpine

RUN apk update && apk add postgresql-dev gcc python3-dev musl-dev py-pip
ENV DJANGO_SETTINGS_MODULE snap.settings.docker

USER root
ENV PYTHONUNBUFFERED 1


RUN apk add zlib-dev jpeg-dev gcc musl-dev
COPY ./requirements.txt /requirements.txt
RUN pip install -r requirements.txt --ignore-installed

RUN mkdir /app
WORKDIR /app

COPY . /app
RUN pip install -e /app --no-cache-dir


# Collectstatic
RUN SECRET_KEY=TEMP python manage.py collectstatic --noinput

EXPOSE 8080
RUN adduser -D user
USER user

CMD python manage.py runserver 0.0.0.0:$PORT
