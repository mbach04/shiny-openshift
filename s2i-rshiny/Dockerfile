# rshiny-rocker
FROM rocker/shiny:latest
LABEL maintainer="CSC Cloud Solutions Team <juhani.kataj>"

ENV BUILDER_VERSION 1.0

# TODO: Set labels used in OpenShift to describe the builder image
LABEL io.k8s.description="Builder image for R Shiny applications" \
      io.k8s.display-name="R Shiny builder 1.0.0" \
      io.openshift.expose-services="3838:http" \
      io.openshift.tags="builder,app-rshiny"

RUN apt-get update
RUN apt-get install -y --no-install-recommends \
  libpq-dev \
  libxml2-dev \
  libssl-dev \
  libcurl4-openssl-dev \
  nano

RUN install2.r -e shinydashboard \
 DBI \
 RPostgreSQL \
 jsonlite \
 dplyr \
 magrittr \
 dbplyr \
 stringr \
 tidyr \
 DT \
 ggplot2 \
 shinyjs \
 scales \
 plotly \
 shinyBS \
 lubridate \
 shinyWidgets


RUN install2.r -e shinydashboard

COPY shiny-server.conf /etc/shiny-server/shiny-server.conf
RUN chown -R shiny /srv/shiny-server/
RUN chown -R shiny /var/lib/shiny-server/

# OpenShift gives a random uid for the user and some programs try to find a username from the /etc/passwd.
# Let user to fix it, but obviously this shouldn't be run outside OpenShift
RUN chmod ug+rw /etc/passwd 
COPY fix-username.sh /fix-username.sh
COPY shiny-server.sh /usr/bin/shiny-server.sh
RUN chmod a+rx /usr/bin/shiny-server.sh


# Make sure the directory for individual app logs exists and is usable
RUN chmod -R a+rwX /var/log/shiny-server
RUN chmod -R a+rwX /var/lib/shiny-server



# TODO (optional): Copy the builder files into /opt/app-root
# COPY ./<builder_folder>/ /opt/app-root/

# TODO: Copy the S2I scripts to /usr/libexec/s2i, since openshift/base-centos7 image
# sets io.openshift.s2i.scripts-url label that way, or update that label
RUN mkdir -p /.s2i
COPY ./s2i/bin/ /.s2i

# TODO: Drop the root user and make the content of /opt/app-root owned by user 1001
# RUN chown -R 1001:1001 /opt/app-root
RUN chown -R 1:0 /usr/local/ /srv/shiny-server /tmp
USER 1

# This default user is created in the openshift/base-centos7 image

# TODO: Set the default port for applications built using this image
EXPOSE 3838

CMD ["/.s2i/usage"]

LABEL io.openshift.s2i.scripts-url="image:///.s2i/" 
