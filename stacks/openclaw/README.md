# OpenClaw stack

## Notes
- `OPENCLAW_IMAGE` is built/pulled separately (Ansible) and defaults to `openclaw:local`.
- `openclaw.json` should be copied to `${OPENCLAW_CONFIG_DIR}/openclaw.json`.
- Ansible must `chown` `${OPENCLAW_CONFIG_DIR}` and `${OPENCLAW_WORKSPACE_DIR}` to the container UID/GID (defaults to `1000:1000`) so the non-root user can write.
- Ollama requests one NVIDIA GPU via `device_requests`; remove that stanza if running on a CPU-only host.
- Ollama runs on an internal-only network (no internet egress). This means `ollama pull` (model download/update) will **not** work from inside the container by default.
- To use models in this stack, you must either:
  - Pre-seed `${OLLAMA_DATA_DIR}` on the host with the required models (for example, by running `ollama pull` on a machine with internet access and then copying the resulting data directory), and mount that directory into the Ollama container; or
  - Temporarily attach the Ollama container to a network with internet egress, run `ollama pull` inside the container to fetch the required models, and then return it to the internal-only network.

## Local access (SSH tunnel)
The gateway is published only on host loopback (`127.0.0.1:${OPENCLAW_GATEWAY_PORT}`).

```sh
ssh -L 18789:127.0.0.1:18789 user@host
```

Then visit `http://127.0.0.1:18789` locally.

## CLI utilities
The CLI container is kept idle for on-demand checks:

```sh
docker compose exec openclaw-cli openclaw doctor
docker compose exec openclaw-cli openclaw health
docker compose exec openclaw-cli openclaw security audit
```
