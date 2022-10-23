FROM solr:8.11.2

# RUN precreate-core products

# USER root
# COPY solr_config/products /var/solr/data/products/conf
# COPY --chown=solr solr_config/products /var/solr/data/products/conf
# # RUN chown 8983:8983 /var/solr/data/products

# USER root
# WORKDIR /var/solr/data/products/data
# RUN mkdir -p snapshot_metadata index

# WORKDIR /var/solr/data/products/data/index
# RUN touch write.lock

# USER solr