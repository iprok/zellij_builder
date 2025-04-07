# Zellij Debian/Ubuntu Builder

This repository contains Docker-based tooling to build `.deb` packages of [Zellij](https://github.com/zellij-org/zellij) for multiple Debian and Ubuntu distributions.

---

## ✅ Features

- Builds `.deb` packages using `cargo-deb`
- Targets:
  - Debian 12 `bookworm`
  - Ubuntu 24.04 `noble`
  - Ubuntu 22.04 LTS `jammy`
- Automatically names packages like:
  ```
  zellij_0.40.1_bookworm_amd64.deb
  ```

---

## 🔧 Requirements

- [Docker](https://www.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/)
- `make`

---

## 🚀 Usage

### Build for all supported distributions:

```bash
make all
```

### Build individually:

```bash
make bookworm   # Debian 12
make noble      # Ubuntu 24.04
make jammy      # Ubuntu 22.04 LTS
```

### Clean built `.deb` packages and Docker artifacts:

```bash
make clean
```

---

## 📁 Output

The resulting `.deb` packages will appear in the following directories:

- `output-bookworm/`
- `output-noble/`
- `output-jammy/`

Each file is named as:

```
zellij_<version>_<distro>_<arch>.deb
```

Example:

```
zellij_0.40.1_noble_amd64.deb
```

---

## 📂 Project Structure

```
.
├── Dockerfile           # Main build definition
├── docker-compose.yml   # Defines build targets for each distro
├── entrypoint.sh        # Post-build script that copies the .deb
├── Makefile             # CLI interface
├── output-bookworm/     # .deb files appear here after build
├── output-noble/
└── output-jammy/
```
