# snap_k8s
Kubernetes monitoring using Snap

## Usage

This docker image is designed to deployed into Kubernets as a DaemonSet, causing it to run on every node in the cluster.
For the best results, we recommend you use the Grafana kubernetes-app see - https://grafana.net/

For manual deployment the following kubernetes manifest can be used.

```
apiVersion: v1
kind: ConfigMap
metadata:
  name: snap-tasks
  namespace: kube-system
data:
  core.json: |-
    {
          "version": 1,
          "schedule": {
            "type": "simple",
            "interval": "10s"
          },
          "start": true,
          "workflow": {
            "collect": {
              "metrics": {
                "/intel/docker/*":{},
                "/intel/procfs/cpu/*": {},
                "/intel/procfs/meminfo/*": {},
                "/intel/procfs/iface/*": {},
                "/intel/linux/iostat/*": {},
                "/intel/procfs/load/*": {}
              },
              "config": {
                "/intel/procfs": {
                  "proc_path": "/proc_host"
                }
              },
              "process": null,
              "publish": [
                {
                  "plugin_name": "graphite",
                  "config": {
                    "prefix": "snap.CLUSTER_NAME.<%NODE%>",
                    "server": "graphite.host.name",
                    "port": 2003
                  }
                }
              ]
            }
          }
        }
---
apiVersion: extensions/v1beta1
kind: DaemonSet
metadata:
  labels:
    daemon: snapd
  name: snap
  namespace: kube-system
spec:
  template:
    metadata:
      labels:
        daemon: snapd
      name: snap
    spec:
      containers:
      - env:
        - name: PROCFS_MOUNT
          value: /proc_host
        - name: LISTEN_PORT
          value: "8181"
        - name: SNAP_URL
          value: "http://localhost:8181"
        image: raintank/snap_k8s:latest
        imagePullPolicy: Always
        name: snap
        securityContext:
          privileged: true
        ports:
        - containerPort: 8181
          hostPort: 8181
          name: snap-api
          protocol: TCP
        volumeMounts:
        - mountPath: /sys/fs/cgroup
          name: cgroup
        - mountPath: /var/run/docker.sock
          name: docker-sock
        - mountPath: /var/lib/docker
          name: fs-stats
        - mountPath: /usr/local/bin/docker
          name: docker
        - mountPath: /proc_host
          name: proc
        - mountPath: /opt/snap/tasks
          name: snap-tasks
      hostNetwork: true
      hostPID: true
      restartPolicy: Always
      terminationGracePeriodSeconds: 30
      volumes:
      - hostPath:
          path: /dev
        name: dev
      - hostPath:
          path: /sys/fs/cgroup
        name: cgroup
      - hostPath:
          path: /var/run/docker.sock
        name: docker-sock
      - hostPath:
          path: /var/lib/docker
        name: fs-stats
      - hostPath:
          path: /usr/bin/docker
        name: docker
      - hostPath:
          path: /proc
        name: proc
      - configMap:
          defaultMode: 420
          name: snap-tasks
        name: snap-tasks
```

## Building

### To build the image simply run

```
make
```

### To Publish the image to docker hub
Ensure that you are logged into DockerHub
```
docker login
```

Then run push the image to your account.

```
make push REPO=<Your DockerHub Org>
```
