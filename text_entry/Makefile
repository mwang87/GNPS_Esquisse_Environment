run_gnps:
	Rscript app.R

#Docker Compose
server-compose-interactive:
	docker-compose build
	docker-compose up

server-compose:
	docker-compose build
	docker-compose up -d

server-compose-production-interactive:
	docker-compose build
	docker-compose -f docker-compose.yml -f docker-compose-production.yml up

server-compose-production:
	docker-compose build
	docker-compose -f docker-compose.yml -f docker-compose-production.yml up -d