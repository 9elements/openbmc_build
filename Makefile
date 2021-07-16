DOWNLOAD_DIR ?= $(CURDIR)/downloads
BUILD_DIR ?= $(CURDIR)/build
TARGET ?= e3c246d4i

docker_name = openbmc_build
docker_tag = v1

project_name = openbmc
project_git_repo = https://github.com/openbmc/openbmc
project_git_branch = master
project_dir = $(CURDIR)/openbmc

all: build_obmc

$(project_dir):
	echo "Cloning $<"
	git clone --branch $(project_git_branch) $(project_git_repo) $(project_dir)

.PHONY: update
update: $(project_dir)
	echo "Fetching new commits from $(project_name)"
	cd $(project_dir); git fetch --multiple origin

.PHONY: build_docker
build_docker: Dockerfile
	docker build $(CURDIR) -t $(docker_name):$(docker_tag)

$(DOWNLOAD_DIR) $(BUILD_DIR):
	mkdir -p $@

# Run the docker with $(1) as a command
docker_run = docker run --rm -v $(CURDIR):/mnt/project \
		-it $(docker_name):$(docker_tag) $(1)

.PHONY: docker_bash
docker_bash: build_docker $(DOWNLOAD_DIR) $(BUILD_DIR) update
	$(call docker_run, bash)

.PHONY: build_obmc
build_obmc: build_docker update $(DOWNLOAD_DIR) $(BUILD_DIR) $(CURDIR)/run.sh
	$(call docker_run, /mnt/project/run.sh $(TARGET))

.PHONY: clean
clean:
	rm -rf $(BUILD_DIR)
	git -C openbmc clean -fx