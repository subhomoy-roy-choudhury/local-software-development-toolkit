FROM mongo:4.2.2

RUN apt update
RUN apt-get install -y wget curl unzip nano

# RUN mkdir home/fynd-db

WORKDIR /home/fynd-data

RUN wget -O setup_db.sh https://raw.githubusercontent.com/subhomoy-roy-choudhury/fynd-local-db-setup/master/setup_db.sh\?token\=GHSAT0AAAAAABXP2LPFFINS4OWZHHPZE36WYXTNW5Q
RUN chmod +x setup_db.sh

RUN echo "Finished"