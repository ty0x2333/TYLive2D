.PHONY: help
SCREENSHOT_DST="screenshots"
SCREENSHOT_SOURCE="screenshots-temp"

help: ## show this help message and exit
	@echo "usage: make [target]"
	@echo
	@echo "targets:"
	@egrep '^(.+)\:\ ##\ (.+)' ${MAKEFILE_LIST} | column -t -c 2 -s ':#'

screenshot: ## generate/update screenshot
	@fastlane snapshot
	@if [ ! -d $(SCREENSHOT_DST) ]; then \
		mkdir $(SCREENSHOT_DST); \
	fi
	@for var in $$(find $(SCREENSHOT_SOURCE) -name *.png); do \
		BASE_NAME=$$(basename $$var); \
		DST_NAME=$${BASE_NAME%-*.png}.png; \
		cp $$var "$(SCREENSHOT_DST)/$$DST_NAME"; \
	done