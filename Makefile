OPENSCAD := /Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD
SCAD_FILES := $(shell find . -type f -name '*.scad' -not -path "./lib/*" -not -path "./mcad/*" -not -path "*parts.scad")
DEP_FILES := $(patsubst %.scad, %.stl.deps, $(SCAD_FILES))
STL_FILES := $(patsubst %.scad, %.stl, $(SCAD_FILES))

all: $(STL_FILES)
    
# sinclude to not error out when the dependencies file hasn't been built yet.
sinclude $(DEP_FILES)

%.stl: %.scad
	@echo "Rendering $<"
	cd $(dir $@); $(OPENSCAD) -o $(notdir $@) -m make -d $(notdir $@).deps $(notdir $<)
	
