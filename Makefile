DOWNLOAD_DIR ?= $(CURDIR)/downloads
BUILD_DIR ?= $(CURDIR)/build
TARGET ?= genesis3

docker_name = openbmc_build
docker_file = Dockerfile
docker_tag = v3

project_name = openbmc
project_git_repo = https://github.com/9elements/openbmc.git
project_git_branch = gen3
project_dir = $(CURDIR)/openbmc

UID ?= $(shell id -u)
GID ?= $(shell id -g)

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
	docker build \
	--network=host \
	--build-arg USER_ID=$(UID) \
	--build-arg GROUP_ID=$(GID) \
	-t $(docker_name):$(docker_tag)_$(UID) - < $(docker_file)

$(DOWNLOAD_DIR) $(BUILD_DIR):
	mkdir -p -m a+rw $@

# Run the docker with $(1) as a command
docker_run = docker run --rm -v $(CURDIR):/mnt/project:Z \
		--ulimit nofile=4096:8192  \
		--privileged \
		-it \
		$(docker_name):$(docker_tag)_$(UID) \
		$(1)

.PHONY: docker_bash
docker_bash: $(DOWNLOAD_DIR) $(BUILD_DIR)
	$(call docker_run, bash)

.PHONY: build_obmc
build_obmc: $(DOWNLOAD_DIR) $(BUILD_DIR) $(CURDIR)/run.sh | $(project_dir)
	rm -rf $(BUILD_DIR)/tmp/work/$(project_git_branch)-openbmc-linux-gnueabi/obmc-phosphor-image/
	$(call docker_run, /mnt/project/run.sh $(TARGET))

.PHONY: clean
clean:
	rm -rf $(BUILD_DIR)
	git -C openbmc clean -fx
