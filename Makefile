VENV_PATH ?= ./venv
VENV_REQ ?= docs/requirements.txt

.PHONY: venv
venv:
	test -d $(VENV_PATH) || python3 -m venv $(VENV_PATH)

.PHONY: requirements
requirements: venv
	$(VENV_PATH)/bin/pip install --upgrade pip
	$(VENV_PATH)/bin/pip install -r $(VENV_REQ)

mkdocs-serve:
	$(VENV_PATH)/bin/mkdocs serve

mkdocs-build:
	git pull
	$(VENV_PATH)/bin/mkdocs build