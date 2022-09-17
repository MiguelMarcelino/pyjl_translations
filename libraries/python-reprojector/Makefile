ifeq ($(CI),true)
  PYTHON=do_pip
  VENV_BIN=
else
  PYTHON=.venv/.requirements-timestamp
  VENV_BIN=.venv/bin/
endif


install: $(PYTHON)

.venv/.venv-timestamp:
	virtualenv .venv
	touch $@

.venv/.requirements-timestamp: .venv/.venv-timestamp setup.py requirements.txt
	$(VENV_BIN)pip install -r requirements.txt
	touch $@


.PHONY: do_pip
do_pip:
	pip install -r requirements.txt


.PHONY: lint
lint: $(PYTHON)
	$(VENV_BIN)flake8


.PHONY: test
test: $(PYTHON)
	$(VENV_BIN)py.test -vv --cov=pyreproj tests


.PHONY: check
check: lint test


.PHONY: build
build: $(PYTHON)
	$(VENV_BIN)python setup.py clean sdist bdist_wheel


.PHONY: deploy
deploy: $(PYTHON)
	$(VENV_BIN)python setup.py clean sdist bdist_wheel upload


clean-doc:
	rm -rf doc/build/*


.PHONY: doc
doc: $(PYTHON) clean-doc
	$(VENV_BIN)sphinx-build doc/source doc/build/html


.PHONY: vdoc
vdoc: $(PYTHON) clean-doc
	$(VENV_BIN)sphinx-versioning build doc/source doc/build/html


.PHONY: clean
clean: clean-doc
	rm -rf .cache
	rm -rf .venv
	rm -rf .coverage
	rm -rf build
	rm -rf dist
