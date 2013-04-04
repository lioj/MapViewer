name = mapviewer

BUILD = debug
PORT = 13639
ADDRESS = 127.0.0.1

.SECONDEXPANSION:

EXE_FILE = MV.wt
EXE = ./$(BUILD)/$(EXE_FILE)
EXE_PATH = $(EXE)
APPROOT = .
DOCROOT_PARENT = .
FCGI_RUN_DIR = $(BUILD)/run
PID_FILE = $(BUILD)/MV.pid
SOCKET = $(BUILD)/MV.socket
DOCROOT = $(DOCROOT_PARENT)/files

ifeq ($(MAKECMDGOALS), install)
BUILD = release
endif

ifeq ($(BUILD), release)
NOOBJECTS = TRUE
endif

# FIXME NOOBJECTS causes compiation errors
NOOBJECTS =

CXX = ccache g++
LINK = g++
LIBS += -lwthttp
LIBS += -lwt
LIBS += -lboost_signals -lboost_regex -lboost_system -lboost_thread
LIBS += -lpthread
LIBS += -lwtclasses
CXXFLAGS += -pipe -Wall -W
CXXFLAGS += -I$(BUILD) -Isrc
ifeq ($(BUILD), debug)
CXXFLAGS += -g -O0 -DDEBUG
CXXFLAGS += -DRUN_TESTS
LFLAGS += -O0
else
CXXFLAGS += -O3 -DNDEBUG
LFLAGS += -O3
ifeq (,$(NOOBJECTS))
CXXFLAGS += -flto
LFLAGS += -flto
endif
endif

downloaded = wt.xml
sources = $(sort $(wildcard src/*.cpp) $(wildcard src/*/*.cpp))
headers = $(sort $(wildcard src/*.hpp) $(wildcard src/*/*.hpp))
ifeq (,$(NOOBJECTS))
objects = $(subst src/,$(BUILD)/,$(sources:.cpp=.o))
makefiles = $(objects:.o=.d)
tosource = src/$*.cpp
toheader = src/$*.hpp
endif

RUN_COMMAND = $(DEBUGGER) $(EXE_PATH) --http-address=$(ADDRESS) --http-port=$(PORT) \
			 --docroot="$(DOCROOT)/;/resources,/img,/js,/css,/tinymce,/favicon.ico" -p $(PID_FILE)

.PHONY: build
build: $$(EXE)

ifeq (,$(filter-out target- target-build target-run, target-$(MAKECMDGOALS)))
include $(makefiles)
endif

$(BUILD)/%.d: $$(tosource)
	mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS) $< -MM | sed 's,.\+\.o[ :]*,$(@:.d=.o) $@ : ,' > $@;

$(EXE): $$(sources) $$(headers) $$(makefiles) $$(objects) $$(downloaded)
	mkdir -p $(dir $@)
ifeq (,$(NOOBJECTS))
	$(LINK) $(LFLAGS) $(LIBS) $(objects) $(LIBS) -o $@
else
	$(CXX) $(LFLAGS) $(CXXFLAGS) \
		$(addprefix -include ,$(filter-out $(firstword $(sources)),$(sources))) \
		$(firstword $(sources)) $(LIBS) -o $@
endif
ifeq ($(BUILD), release)
	upx -9 $@
endif

$(BUILD)/%.o: $$(downloaded)
	$(CXX) -c $(CXXFLAGS) $(tosource) -o $@


$(BUILD)/%.hpp.gch:
	$(CXX) $(CXXFLAGS) $(toheader) -o $@

.PHONY: run
run: $(EXE)
	$(RUN_COMMAND)

.PHONY: doc
doc: $$(headers) doc-main $$(sources)
	doxygen

wt.xml:
	wget -O $@ https://raw.github.com/kdeforche/wt/master/src/xml/wt.xml

.PHONY: check
check: locales

.PHONY: locales
locales: wt.xml
	locales-test --wt=$< --prefix=MV --sections bcr function ui

.PHONY: download
download: $$(downloaded)
