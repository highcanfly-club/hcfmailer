<a href="https://zerodha.tech"><img src="https://zerodha.tech/static/images/github-badge.svg" align="right" /></a>

[![listmonk-logo](https://user-images.githubusercontent.com/547147/134940003-1de03d83-8c7b-459b-8056-baa8d5f3b448.png)](https://listmonk.app)

listmonk is a standalone, self-hosted, newsletter and mailing list manager. It is fast, feature-rich, and packed into a single binary. It uses a PostgreSQL (⩾ v9.4) database as its data store.

[![listmonk-dashboard](https://user-images.githubusercontent.com/547147/134939475-e0391111-f762-44cb-b056-6cb0857755e3.png)](https://listmonk.app)

Visit [listmonk.app](https://listmonk.app) for more info. Check out the [**live demo**](https://demo.listmonk.app).

## Installation

### Docker

The latest image is available on DockerHub at [`listmonk/listmonk:latest`](https://hub.docker.com/r/listmonk/listmonk/tags?page=1&ordering=last_updated&name=latest). Use the sample [docker-compose.yml](https://github.com/knadh/listmonk/blob/master/docker-compose.yml) to run manually or use the helper script. 

### HCF Docker  

For building the HCFDocker image run:  
```sh
make hcf-docker
```

For running create a config.toml file and issue:  
```sh
make run-hcf-docker

For using a private CA certificate declare an environment variable CA_CERTIFICATE.  
It must be a single line variable, replace all newline with a |  
The image expose a ssh port on 3022, it only supports ssh-key login, for supplying yours add a SSH_PUBKEY environment variable with your public key  
```

For a complete running system see hcf/start.sh  
you need to declare
```sh
DKIM_PRIVATE_KEY="-----BEGIN PRIVATE KEY-----|MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSj……………BuoTsIHpowYjVbps4=|-----END PRIVATE KEY-----"  #(optional a valid DKIM private key with | in place of CR
DKIM_SELECTOR=yourselector                                   #(optional DKIM selector)
ALLOWED_SENDER_DOMAINS="example.org example.net example.com" #mandatory 
POSTGRES_DB=listmonk                                         #mandatory (the name of the DB)
POSTGRES_PASSWORD=apassword                                  #mandatory (the password of the DB)
POSTGRES_USER=auser                                          #mandatory (the user of the DB)
LISTMONK_USER=listmonk                                       #optional default to listmonk
LISTMONK_PASSWORD=averysecurepassword                        #mandatory (the admin password)
OKETO_NS=yournamespace                                       #mandatory (the K8S namespace)
OKTETO_FQDN_HCFMAILER=name-yournamespace.cloud.okteto.net    #mandatory (the fqdn for the admin UI -ingress)
SSH_PUBKEY="ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBLIHfyW0g6kUxa4hn1fWzrIY/98HVWEymk8liFRadW2bCknHdLyNnzYGOQvcHlg+mLhFhSJwiA5DaHAEwwHbRQE= key@hcfmailer" #(optional a valid ssh pubkey - will be filled as authorized key)
```
for deploying on a Kubernetes cluster see hcf/okteto/sart-k8s.sh 

#### Demo

```bash
mkdir listmonk-demo && cd listmonk-demo
sh -c "$(curl -fsSL https://raw.githubusercontent.com/knadh/listmonk/master/install-demo.sh)"
```

DO NOT use this demo setup in production.

#### Production

```bash
mkdir listmonk && cd listmonk
sh -c "$(curl -fsSL https://raw.githubusercontent.com/knadh/listmonk/master/install-prod.sh)"
```
Visit `http://localhost:9000`.

**NOTE**: Always examine the contents of shell scripts before executing them.

See [installation docs](https://listmonk.app/docs/installation).

__________________

### Binary
- Download the [latest release](https://github.com/knadh/listmonk/releases) and extract the listmonk binary.
- `./listmonk --new-config` to generate config.toml. Then, edit the file.
- `./listmonk --install` to setup the Postgres DB (or `--upgrade` to upgrade an existing DB. Upgrades are idempotent and running them multiple times have no side effects).
- Run `./listmonk` and visit `http://localhost:9000`.

See [installation docs](https://listmonk.app/docs/installation).
__________________


## Developers
listmonk is a free and open source software licensed under AGPLv3. If you are interested in contributing, refer to the [developer setup](https://listmonk.app/docs/developer-setup). The backend is written in Go and the frontend is Vue with Buefy for UI. 


## License
listmonk is licensed under the AGPL v3 license.
