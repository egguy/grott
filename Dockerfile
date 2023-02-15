FROM python:3.7-slim as base

# ENV LANG en_US.UTF-8
# ENV LC_ALL en_US.UTF-8

# Run updates
# RUN apt-get clean && apt-get update && apt-get upgrade -y

# Set the locale
# RUN apt-get install -y locales && locale-gen en_US.UTF-8

#Install required python packages and cleanup
RUN pip install paho-mqtt requests influxdb influxdb-client

COPY ["grott.py", "grottconf.py", "grottdata.py", "grottproxy.py", "grottsniffer.py", "grottserver.py", "examples/Home Assistent/grott_ha.py", "/app/"]
RUN touch /app/grott.ini

WORKDIR /app
EXPOSE 5279/tcp

FROM base as grott
CMD ["python", "-u", "grott.py", "-v"]

FROM base as grottserver
CMD ["python", "-u", "grottserver.py", "-v"]

# To create an image for grott:
# docker build . --target grott -t image_name
# For grott server
# docker build . --target grottserver -t image_name
# Run (create a grott.ini in the folder first):
# docker run -d -p 5279:5279  --restart on-failure -v $(pwd)/grott.ini:/app/grott.ini image_name