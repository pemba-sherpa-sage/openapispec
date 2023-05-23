# Makefile

ifndef SANDBOX
	# SANDBOX is the parent of /app
	SANDBOX = ../../..
endif

ifndef TOOLSLOC
	TOOLSLOC = $(SANDBOX)/app/tools
endif

OAS_REGISTRY_BUILDER = $(TOOLSLOC)/eng/build_temp_registry.bin

OAS_BUILD_COMPONENTS = ../../build/components

all: sentinel

generator: spectral convert update_v0_registry

OAS_TARGET ?= $(PWD)/$(OAS_BUILD_COMPONENTS)

OAS_PWD = $(PWD)

javaconvert:
	@if ! command -v java-ds >/dev/null ; then \
		echo "ERROR: The 'java-ds' command does not exist."; \
		exit 1; \
	else \
		echo "The version used for java is:"; \
		java-ds --version; \
	fi
	@if ! java-ds -jar $(IA_BUILD_TOOLS)/ia-yaml-converter-6.jar "./" "$(OAS_TARGET)" --version; then \
		echo "One or more files failed conversion of the API Objects from Yaml to Json"; \
		exit 1; \
	fi

convert: javaconvert
	tar cf - . | md5sum > $(OAS_TARGET)/yaml.sentinel

sentinel:
ifneq ("$(wildcard $(OAS_TARGET)/yaml.sentinel)","")
	@echo "YAML Converter checking for update"; \
	tar cf - . | md5sum > $(OAS_TARGET)/tmp.sentinel; \
	cmp --silent $(OAS_TARGET)/tmp.sentinel $(OAS_TARGET)/yaml.sentinel; \
	if [ $$? -eq 0 ]; then \
		echo "No schema change detected, re-using existing objects"; else \
		echo "Running YAML Converter"; \
		$(MAKE) generator;\
	fi
else
	@echo "Running YAML Converter"; \
	$(MAKE) generator
endif

update_v0_registry:
	@cd $(OAS_TARGET); $(OAS_REGISTRY_BUILDER)

spectral:
	@echo "Spectral Linting"; \
	$(eval SPECTRAL_OUTPUT=$(shell spectral lint ./*/paths/*.api.yaml --ignore-unknown-format --ruleset=.core-rules.yml -D)) \
	echo '$(SPECTRAL_OUTPUT)' | grep -i "No results with a severity of error found!" > /dev/null 2>&1; \
	if [ $$? -ne 0 ]; then \
	   echo '$(SPECTRAL_OUTPUT)'; \
	   exit 1; \
	fi
