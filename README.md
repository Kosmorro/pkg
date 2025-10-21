# Kosmorro repositories

This repository contains recipes to build and publish packages and repositories for various Linux distributions.

It provides the following packages:

- [`kosmorro`](https://kosmorro.space)
- [`kosmorrolib`](https://kosmorro.space/lib)
- [`skyfield-data`](https://pypi.org/project/skyfield-data)

## Using the repositories

See the instructions specific at your distribution on [Kosmorro's website](https://kosmorro.space/cli/download/linux).

## Build packages

If you prefer, you can also build the packages by yourselves:

### DEB (Debian, Ubuntu, Linux Mint)

First, install the `dpkg-dev` and `fakeroot` packages.
Then, run the following command:

```bash
make deb
```
