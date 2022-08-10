FROM mongo:4.2.2

RUN apt update
RUN apt-get install -y wget curl unzip nano

# RUN mkdir home/fynd-db

WORKDIR /home/fynd-data

RUN wget -O setup_db.sh 'Authorization: token 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' https://raw.githubusercontent.com/subhomoy-roy-choudhury/fynd-local-db-setup/master/setup_db.sh
RUN chmod +x setup_db.sh

RUN echo "Finished"