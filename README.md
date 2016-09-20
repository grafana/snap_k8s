# snap_k8s
Kubernetes monitoring using Snap

## to build the image first run

```
./get_plugins.sh <version>
```

<version> Is optional and should be the release version of snap to use, eg. "v0.16.1"

then run

```
docker build -t snap_k8s .
```
