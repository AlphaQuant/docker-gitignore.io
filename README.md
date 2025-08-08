<div align="center">
<h2 align="center"> docker-gitignore.io </h2>
<p align="center">
Build docker image for gitignore.io
</p>
<p align="center">
  <img src="https://img.shields.io/badge/Maintainer-cyril@liaosirui.com-blue.svg"alt="Maintainer">
  <img src="https://img.shields.io/badge/Language-Dockerfile-green.svg" alt="Language">
  <img src="https://img.shields.io/badge/license-Apache2-blue.svg?style=flat" alt="license">
  <br />
  <img src="https://img.shields.io/github/stars/AlphaQuant/docker-gitignore.io.svg?style=social&label=Star" alt="Star">
  <img src="https://img.shields.io/github/forks/AlphaQuant/docker-gitignore.io.svg?style=social&label=Fork" alt="Fork">
  <img src="https://img.shields.io/github/forks/AlphaQuant/docker-gitignore.io.svg?style=social&label=Watch" alt="Watch">
</p>
</div>

## Usage

Just run

```bash
git clone git@github.com:AlphaQuant/docker-gitignore.io.git

# create docker network
docker network create \
  --driver bridge \
  --subnet 172.28.1.0/24 \
  --gateway 172.28.1.254 public

docker compose up -d
```

visit websites at: `<YourHost>:37789/gitignore`

## Related GitHub Repos

- <https://github.com/toptal/gitignore.io>
- <https://github.com/github/gitignore>
