FROM mongo:latest

RUN apt-get -y update && apt-get install -y wget curl unzip nano

COPY . .

WORKDIR /home/fynd-data

RUN echo "Finished"