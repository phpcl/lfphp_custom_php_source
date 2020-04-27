#
# Builds Custom PHP from Source
#

FROM asclinux/linuxforphp-8.2-ultimate:src

COPY ./init.sh /tmp/init.sh
RUN chmod +x /tmp/init.sh
RUN /tmp/init.sh
