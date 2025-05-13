.PHONY: all bookworm noble jammy clean distclean prepare

all: prepare
	docker compose up --build

bookworm: prepare
	docker compose up --build zellij-bookworm

noble: prepare
	docker compose up --build zellij-noble

jammy: prepare
	docker compose up --build zellij-jammy

plucky: prepare
	docker compose up --build zellij-plucky

prepare:
	@mkdir -p output-bookworm output-noble output-jammy

clean:
	rm -f output-bookworm/*.deb output-noble/*.deb output-jammy/*.deb
	docker compose down --remove-orphans

distclean:
	rm -rf output-bookworm output-noble output-jammy
	docker compose down --rmi local --volumes --remove-orphans
