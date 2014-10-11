# sheldonh/dvc

A very simple image for launching Docker volume containers in which ownership and permissions of volume directories are set correctly.
You could accomplish the same thing with the busybox image.
This image just allows you to express the container's intent (and its consumers' expectations) more clearly.

## Usage

The entry point expects CMD to be a list of one or more directory specifications:

```
usage: prepare-volumes [-fr] dir[:mode[:uid[:gid]]] ...
```

<dl>
<dt><code>-f</code></dt>
<dd>Force application to directories that are not mount points (default: false). <em>Only useful in testing.</em></dd>
<dt><code>-r</code></dt>
<dd>Run forever instead of terminating when done (default: false).</dd>
<dt><code>dir</code></dt>
<dd>The mount point of a volume (which must also be declared with <code>docker run -v</code>).</dd>
<dt><code>mode</code></dt>
<dd>The desired permissions of the mount point (default: <code>0755</code>).</dd>
<dt><code>uid</code></dt>
<dd>The desired numeric id of the mount point owner (default: <code>0</code>).</dd>
<dt><code>gid</code></dt>
<dd>The desired numerid id of the mount point group (default: <code>0</code>).</dd>
</dl>

Note that `uid` and `gid` should be numeric, because even if this image happens to include a user or group name that the DVC consumer is expecting,
it is unlikely that both images will map that name to the same numeric value.

The `-r` option has two uses:

* in environments that automatically restart terminated containers, and
* in environments where `docker rm -v` is used immediately following container termination.

## Example

To create a DVC for redis:

```
docker run --name redis-dvc \
           -v /data -v /etc/redis \
           sheldonh/dvc /data:755:999:999 /etc/redis:755:999:999
docker run -d --name redis --volumes-from redis-dvc redis
```

Note that the DVC does not run in the background with docker's `-d` option;
it sets up permissions and ownership and then terminates because the dvc's `-r` option was not specified.
