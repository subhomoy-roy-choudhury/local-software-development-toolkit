FROM mongo:4.2.2

RUN apt update
RUN apt-get install -y wget curl unzip nano

COPY . .

WORKDIR /home/fynd-data

# RUN wget -O setup_db.sh --header 'Authorization: token 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' https://raw.githubusercontent.com/subhomoy-roy-choudhury/fynd-local-db-setup/master/setup_db.sh
RUN chmod +x setup_db.sh

RUN echo "Finished"