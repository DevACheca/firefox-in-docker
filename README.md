# firefox-in-docker (find)

**Important:** I forked this project from eficode-academy (https://github.com/eficode-academy/firefox-in-docker), with the intent of generating an updated docker image that had a newer version of Firefox as the one in eficode's release was a dated image already, thus everything is the same just a newer firefox version in the image using a Github Actions pipeline.

**Purpouse:** Run Firefox in a docker container and forward over http using xpra, in order to have a graphical browser running on a remote machine.

**Motivation:** Using this project to setup a firefox session via xpra for use in my homelab to access certain systems within my lab environment, when I connect to xpra.

This is implemented by using `XPra` to run Firefox in a docker container, and forward the Firefox session over HTTP to a client browser.

This could also be used for running other applications we need to run on remote machines.

# Usage

Using `docker run`

```sh
docker run -d -p 10000:10000 --restart always ghcr.io/devacheca/firefox-in-docker:main
```

Using `docker-compose`

```sh
git clone https://github.com/devacheca/firefox-in-docker/
cd firefox-in-docker
docker-compose up -d
```

# Docker Images

There is a GitHub Actions pipeline set up to build and push a new version of the docker image on pushes to the `main` branch.
