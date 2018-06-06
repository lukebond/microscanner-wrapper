# Aquasec Microscanner Wrapper

Use this script to scan images with Aquasec Microscanner.

Why? Because Microscanner requires you to extend your image by adding Microscanner rather than being able to scan images you've already built.

## First Register for a Token

As per instructions here: <https://github.com/aquasecurity/microscanner>

## Usage

Simply pass your token as an environment variable and the Docker image as the only argument:

```
$ MICROSCANNER_TOKEN=xxxxxxxxxxxxxxxx ./scan.sh DOCKER_IMAGE
```

For example, one that passes:

```
$ MICROSCANNER_TOKEN=xxxxxxxxxxxxxxxx ./scan.sh aquasec/microscanner
```

...and one that fails:

```
$ MICROSCANNER_TOKEN=xxxxxxxxxxxxxxxx ./scan.sh ubuntu:16.04
```
