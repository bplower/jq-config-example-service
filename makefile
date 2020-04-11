
.DEFAULT_GOAL:=help
.PHONY: help build-base build-service run run-failing

SERVICE_TAG=jq-example-service

# Help menu target from: https://blog.thapaliya.com/posts/well-documented-makefiles/
help:  ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

##@ Image build targets

build-base: ## Build base image with jq-render script
	docker build -t jq-example-base ./example-base

build-service: ## Build an example service image
	docker build -t ${SERVICE_TAG} ./example-service

##@ Run examples

run: ## Run with a valid set of env vars
	docker run --env-file example.env ${SERVICE_TAG}

run-failing: ## Run with an invalid set of env vars
	docker run --env-file failing.env ${SERVICE_TAG}
