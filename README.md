This is a toolset for *hand-picking* deb files to make a
*partial mirror* of any Debian repository
(currently this only supports archive.ubuntu.com).
It recreates a part of the tree of the source repository,
and serves that tree by a HTTP server running locally,
so it can serve the pre-downloaded packages without Internet connection.

This is not a *proxy*. The HTTP server will not contact
the source repository when a client requests
a package that has not yet been downloaded.
If you need a proxy, use `squid-deb-proxy` or `apt-cacher-ng`.

It is *manual* in the sense that you have to give it
a list of packages to download, but you don't have to specify
*all* packages; it will also download the minimal dependencies
(`--no-install-recommends`).

This does not download to `/var/apt/cache`;
use `apt-get install --download-only` for that.

## How to use

### Build ubuntu-apt-pristine image

We assume you have Docker installed.

```
docker build -f Dockerfile/ubuntu-apt-pristine -t ubuntu-apt-pristine .
```

This pristine Docker image is used for generating
the list of package dependencies to download.

### Set up repository

This downloads Release, Packages.gz, and so on to `content`.

```
./seed
```

### Pre-download your packages

```
./download PACKAGE0 PACKAGE1 ... PACKAGEm
```

Replace each PACKAGEk with a package name you want to install.
It will also download their dependencies.

If a package has already been downloaded,
`download` refreshes the deb files.

## Using the mirror

Replace the content of `/etc/apt/sources.list` with this:

```
deb http://172.18.0.2/ubuntu/ trusty main
deb http://172.18.0.2/ubuntu/ trusty restricted
deb http://172.18.0.2/ubuntu/ trusty universe
deb http://172.18.0.2/ubuntu/ trusty multiverse
deb http://172.18.0.2/ubuntu/ trusty-updates main
deb http://172.18.0.2/ubuntu/ trusty-updates restricted
deb http://172.18.0.2/ubuntu/ trusty-updates universe
deb http://172.18.0.2/ubuntu/ trusty-updates multiverse
deb http://172.18.0.2/ubuntu/ trusty-backports main
deb http://172.18.0.2/ubuntu/ trusty-backports restricted
deb http://172.18.0.2/ubuntu/ trusty-backports universe
deb http://172.18.0.2/ubuntu/ trusty-backports multiverse
deb http://172.18.0.2/ubuntu/ trusty-security main
deb http://172.18.0.2/ubuntu/ trusty-security restricted
deb http://172.18.0.2/ubuntu/ trusty-security universe
deb http://172.18.0.2/ubuntu/ trusty-security multiverse

deb http://172.18.0.2/pub/repos/apt trusty-pgdg main
```

### Start the server

```
./start
```

This starts a Docker container running a HTTP server on `172.18.0.2:80`.

If you cannot connect, you need to drop iptables rules in DOCKER-ISOLATION chain;
this can be done by just restarting the server like this:

```
./stop
./start
```

# References

[Debian repository format](https://wiki.debian.org/RepositoryFormat)

[Debian package management internals](https://www.debian.org/doc/manuals/debian-reference/ch02.en.html#_debian_package_management_internals)
