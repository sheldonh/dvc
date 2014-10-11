FROM busybox

ADD ./prepare-volumes.sh /prepare-volumes

ENTRYPOINT [ "/prepare-volumes" ]
