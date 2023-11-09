
## Elasticsearch

Elasticsearch is pretty greedy. For some of my projects, I needed two instances of elasticsearch. So I decided to create
them, but you can remove elasticsearch2 if not needed. If you make this change, don't forget to change the following lines:

```yaml
- discovery.seed_hosts=elasticsearch2
- cluster.initial_master_nodes=elasticsearch,elasticsearch2
```

to

```yaml
- cluster.initial_master_nodes=elasticsearch
```

### Kibana

Kibana is also available. You can access it with the following url : http://localhost:5601. It will permit you to check
the health of your elasticsearch instance.

### Troubleshooting

As said, elasticsearch is greedy. So you can have some issues with it. Check for vm.max_map_count on your host. If it's
not set to 262144, you need to set it with the following command:

```bash
sudo sysctl -w vm.max_map_count=262144
```