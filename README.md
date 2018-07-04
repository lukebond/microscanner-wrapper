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

The script will return `0` if Microscanner passes the image, or `1` if it fails it.

## Local microscanner

To avoid pulling the microscanner, if it's available in the local path:

```
$ USE_LOCAL=1 MICROSCANNER_TOKEN=xxxxxxxxxxxxxxxx ./scan.sh ubuntu:16.04
```
### Optional Parameters

To run miscroscanner with optional parameters simply add MICROSCANNER_OPTIONS as an environmental or as one argument:

```
$ MICROSCANNER_TOKEN=xxxxxxxxxxxxxxxx MICROSCANNER_OPTIONS="--html" ./scan.sh DOCKER_IMAGE
```

### Output HTML 

To output the results in HTML simply call this script with the same familar parameters:

```
$ MICROSCANNER_TOKEN=xxxxxxxxxxxxxxxx ./grabhtml.sh DOCKER_IMAGE
```
