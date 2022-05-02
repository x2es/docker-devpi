FROM python:latest
RUN pip install devpi-server devpi-web devpi-client
COPY ./docker /docker
ENTRYPOINT /docker/entrypoint
