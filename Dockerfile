FROM busybox

MAINTAINER Sheldon Hearn <sheldonh@starjuice.net>

ADD ./prepare-volumes.sh /prepare-volumes

ENTRYPOINT [ "/prepare-volumes" ]
