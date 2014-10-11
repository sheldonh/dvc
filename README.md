# sheldonh/dvc

A very simple image for launching Docker volume containers in which ownership and permissions of volume directories are set correctly.
You could accomplish the same thing with the busybox image.
This image just allows you to express the container's intent (and its consumers' expectations) more clearly.

## Usage

The entry point expects CMD to be a list of one or more directory specifications:

```
usage: prepare-volumes dir[:mode[:uid[:gid]]] ...
```

<dl>
<dt>`dir`</dt>
<dd>The mount point of a volume (which must also be declared with `docker run -v`).</dd>
<dt>`mode`</dt>
<dd>The desired permissions of the mount point (default: `0755`).</dd>
<dt>`uid`</dt>
<dd>The desired numeric id of the mount point owner (default: `0`).</dd>
<dt>`gid`</dt>
<dd>The desired numerid id of the mount point group (default: `0`).</dd>
</dl>

Note that `uid` and `gid` should be numeric, because even if this image happens to include a user or group name that the DVC consumer is expecting,
it is unlikely that both images will map that name to the same numeric value.

## Example

To create a DVC for redis:

```
docker run    --name redis-dvc -v /data -v /etc/redis sheldonh/dvc /data:755:999:999 /etc/redis:755:999:999
docker run -d --name redis --volumes-from redis-dvc redis
```

Note that the DVC does not run in the background; it sets up permissions and ownership and then terminates.
