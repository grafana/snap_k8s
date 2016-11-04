# snap_k8s
Kubernetes monitoring using Snap

## Usage

This docker image is designed to deployed into Kubernets as a DaemonSet, causing it to run on every node in the cluster.
For the best results, we recommend you use the Grafana kubernetes-app see - https://grafana.net/

For manual deployment the following kubernetes manifest can be used.

```
{
  "version": 1,
  "schedule": {
    "type": "simple",
    "interval": "10s"
  },
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
            "prefix": "snap.k8s",
            "server": "my.graphite.host",
            "port": 2003
          }
        }
      ]
    }
  }
}
{
  "kind": "DaemonSet",
  "apiVersion": "extensions/v1beta1",
  "metadata": {
    "name": "snap",
    "namespace": "kube-system",
    "labels": {
      "daemon": "snapd"
    }
  },
  "spec": {
    "selector": {
      "matchLabels": {
        "daemon": "snapd"
      }
    },
    "template": {
      "metadata": {
        "name": "snap",
        "labels": {
          "daemon": "snapd"
        }
      },
      "spec": {
        "volumes": [
          {
            "name": "dev",
            "hostPath": {
              "path": "/dev"
            }
          },
          {
            "name": "cgroup",
            "hostPath": {
              "path": "/sys/fs/cgroup"
            }
          },
          {
            "name": "docker-sock",
            "hostPath": {
              "path": "/var/run/docker.sock"
            }
          },
          {
            "name": "fs-stats",
            "hostPath": {
              "path": "/var/lib/docker"
            }
          },
          {
            "name": "docker",
            "hostPath": {
              "path": "/usr/bin/docker"
            }
          },
          {
            "name": "proc",
            "hostPath": {
              "path": "/proc"
            }
          },
          {
            "name": "snap-tasks",
            "configMap": {
              "name": "snap-tasks"
            }
          }
        ],
        "containers": [
          {
            "name": "snap",
            "image": "raintank/snap_k8s:latest",
            "ports": [
              {
                "name": "snap-api",
                "hostPort": 8181,
                "containerPort": 8181,
                "protocol": "TCP"
              }
            ],
            "env": [
              {
                "name": "PROCFS_MOUNT",
                "value": "/proc_host"
              },
              {
                "name": "LISTEN_PORT",
                "value": "8181"
          	  }
            ],
            "resources": {},
            "volumeMounts": [
              {
                "name": "cgroup",
                "mountPath": "/sys/fs/cgroup"
              },
              {
                "name": "docker-sock",
                "mountPath": "/var/run/docker.sock"
              },
              {
                "name": "fs-stats",
                "mountPath": "/var/lib/docker"
              },
              {
                "name": "docker",
                "mountPath": "/usr/local/bin/docker"
              },
              {
                "name": "proc",
                "mountPath": "/proc_host"
              },
              {
                "name": "snap-tasks",
                "mountPath": "/opt/snap/tasks"
              }
            ],
            "imagePullPolicy": "IfNotPresent",
            "securityContext": {
              "privileged": true
            }
          }
        ],
        "restartPolicy": "Always",
        "hostNetwork": true,
        "hostPID": true
      }
    }
  }
}
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
