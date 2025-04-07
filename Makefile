.PHONY: all bookworm noble jammy clean prepare

# === Main targets ===

all: prepare
	docker compose up --build

bookworm: prepare
	docker compose run --rm zellij-bookworm

noble: prepare
	docker compose run --rm zellij-noble

jammy: prepare
	docker compose run --rm zellij-jammy

# === Create output directories ===

prepare:
	@mkdir -p output-bookworm output-noble output-jammy

# === Clean only .deb files ===

clean:
	rm -f output-bookworm/*.deb output-noble/*.deb output-jammy/*.deb
	docker compose down --rmi all --volumes --remove-orphans

