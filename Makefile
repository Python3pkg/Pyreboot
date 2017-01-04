BUILD_OPTS=build_ext -i

PY_INTERPRETER=python
PYV=

ifneq ($(PYV),)
	PYTHON = $(PY_INTERPRETER)$(PYV)
else
	PYTHON = $(PY_INTERPRETER)
endif

build:
	$(PYTHON) setup.py $(BUILD_OPTS)

clean:
	rm -rf *.so Pyreboot/*.c Pyreboot/*.so dist/ build/ Pyreboot.egg-info/