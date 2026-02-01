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
- Workspace bootstrap files (for example `SOUL.md`) live in `stacks/openclaw/workspace/`. Copy them into `${OPENCLAW_WORKSPACE_DIR}` to apply defaults for new sessions.
- Sandbox is enabled and requires the host Docker socket to be mounted into the gateway container. This increases the blast radius (Docker socket access is effectively root on the host), so keep the gateway loopback-only and enforce pairing/allowlists before enabling any messaging channels.
- Signal is preconfigured as disabled with pairing + allowlists; enable it only after you finish Signal-specific setup (signal-cli account + allowlists).

## Access (loopback or Traefik)
The gateway is published only on host loopback (`127.0.0.1:${OPENCLAW_GATEWAY_PORT}`). For WireGuard HTTPS, expose it through Traefik.

```sh
ssh -L 18789:127.0.0.1:18789 user@host
```

Then visit `http://127.0.0.1:18789` locally.

### WireGuard HTTPS (Traefik)
The UI requires HTTPS (or localhost). Enable Traefik routing by setting `OPENCLAW_TRAEFIK_ENABLE=true` in `.env` and choosing the hostname you want (`OPENCLAW_TRAEFIK_HOST`).
Ensure the hostname resolves to your WireGuard IP (for example `10.10.0.1`) via DNS or `/etc/hosts`.
Then visit `https://<hostname>` using your Traefik TLS termination.

## CLI utilities
The CLI container is kept idle for on-demand checks:

```sh
docker compose exec openclaw-cli openclaw doctor
docker compose exec openclaw-cli openclaw health
docker compose exec openclaw-cli openclaw security audit
docker compose exec openclaw-cli openclaw security audit --deep
docker compose exec openclaw-cli openclaw security audit --fix
```
