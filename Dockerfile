# So the first step is to define the name of the image that we're going to be using,
# So that's the base image that we're going to pull from Docker Hub that we're going to build on top of
# to add the dependencies that we need for our project.
# So we'll be using Python code on 3.9, hyphen Alpine 3.13.
FROM python:3.9-alpine3.13
# FROM name_of_the_docker_image : and_the_tag_to_define_version
# we are using alpine version of python,because it is lightwieght
LABEL maintainer="DRF"

# pythonbuffer is needed,it tells python when ever python completes execution,it will show results right away on screen
ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

ARG DEV=false
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; \
       then /py/bin/pip install -r /tmp/requirements.dev.txt; \
    fi && \
    rm -rf /tmp && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

ENV PATH="/py/bin:$PATH"

USER django-user
