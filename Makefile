
# CLIPS 6.4
# REPL and Library
# macOS 10.15.7
# Ubuntu 20.04 LTS 
# Debian 9.5 
# Fedora 30 
# CentOS 7.5 
# Mint 19.2 

# The GNU Make Manual
# http://www.gnu.org/software/make/manual/make.html

# https://felixcrux.com/blog/creating-basic-makefile

# platform detection
PLATFORM = $(shell uname -s)

ifeq ($(PLATFORM),Darwin) # macOS
	CLIPS_OS = DARWIN
	WARNINGS = -Wall -Wundef -Wpointer-arith -Wshadow -Wstrict-aliasing \
	           -Winline -Wmissing-declarations -Wredundant-decls \
	           -Wmissing-prototypes -Wnested-externs -Wstrict-prototypes \
	           -Waggregate-return -Wno-implicit -Wcast-qual
endif

ifeq ($(PLATFORM),Linux) # linux
	CLIPS_OS = LINUX
	WARNINGS = -Wall -Wundef -Wpointer-arith -Wshadow -Wstrict-aliasing \
               -Winline -Wredundant-decls -Waggregate-return
endif
	    
VERSION_MAJOR = 1
VERSION_MINOR = 0
VERSION_RELEASE = 0

SOURCE_DIR = src
HEADER_DIR = $(SOURCE_DIR)/include
BUILD_DIR = build
LIB_DIR = lib
BIN_DIR = bin
SHLIB = clips640
SHLIB_SONAME = lib$(SHLIB).so
DEMO_EXE = clips-demo

CXX = g++
CXXFLAGS = -D$(CLIPS_OS) -fPIC -x c++ -std=c++17
LDLIBS = -lstdc++


_OBJS = agenda.o analysis.o argacces.o bload.o bmathfun.o bsave.o \
 	classcom.o classexm.o classfun.o classinf.o classini.o \
 	classpsr.o clsltpsr.o commline.o conscomp.o constrct.o \
 	constrnt.o crstrtgy.o cstrcbin.o cstrccom.o cstrcpsr.o \
 	cstrnbin.o cstrnchk.o cstrncmp.o cstrnops.o cstrnpsr.o \
 	cstrnutl.o default.o defins.o developr.o dffctbin.o dffctbsc.o \
 	dffctcmp.o dffctdef.o dffctpsr.o dffnxbin.o dffnxcmp.o dffnxexe.o \
 	dffnxfun.o dffnxpsr.o dfinsbin.o dfinscmp.o drive.o emathfun.o \
 	engine.o envrnmnt.o envrnbld.o evaluatn.o expressn.o exprnbin.o \
 	exprnops.o exprnpsr.o extnfunc.o factbin.o factbld.o factcmp.o \
 	factcom.o factfun.o factgen.o facthsh.o factfile.o factlhs.o factmch.o \
 	factmngr.o factprt.o factqpsr.o factqury.o factrete.o factrhs.o \
 	filecom.o filertr.o fileutil.o generate.o genrcbin.o genrccmp.o \
 	genrccom.o genrcexe.o genrcfun.o genrcpsr.o globlbin.o globlbsc.o \
 	globlcmp.o globlcom.o globldef.o globlpsr.o immthpsr.o incrrset.o \
 	inherpsr.o inscom.o insfile.o insfun.o insmngr.o insmoddp.o \
 	insmult.o inspsr.o insquery.o insqypsr.o iofun.o lgcldpnd.o \
 	memalloc.o miscfun.o modulbin.o modulbsc.o modulcmp.o moduldef.o \
 	modulpsr.o modulutl.o msgcom.o msgfun.o msgpass.o msgpsr.o \
 	multifld.o multifun.o objbin.o objcmp.o objrtbin.o objrtbld.o \
 	objrtcmp.o objrtfnx.o objrtgen.o objrtmch.o parsefun.o pattern.o \
 	pprint.o prccode.o prcdrfun.o prcdrpsr.o prdctfun.o prntutil.o \
 	proflfun.o reorder.o reteutil.o retract.o router.o rulebin.o \
 	rulebld.o rulebsc.o rulecmp.o rulecom.o rulecstr.o ruledef.o \
 	ruledlt.o rulelhs.o rulepsr.o scanner.o sortfun.o strngfun.o \
 	strngrtr.o symblbin.o symblcmp.o symbol.o sysdep.o textpro.o \
 	tmpltbin.o tmpltbsc.o tmpltcmp.o tmpltdef.o tmpltfun.o tmpltlhs.o \
 	tmpltpsr.o tmpltrhs.o tmpltutl.o userdata.o userfunctions.o \
 	utility.o watch.o

OBJS = $(patsubst %,$(BUILD_DIR)/%,$(_OBJS))   

all: release


dir: bin_dir lib_dir

lib_dir: build_dir
	test -d $(LIB_DIR) || mkdir $(LIB_DIR)

bin_dir: build_dir
	test -d $(BIN_DIR) || mkdir $(BIN_DIR)

build_dir:
	test -d $(BUILD_DIR) || mkdir $(BUILD_DIR)




debug : CXXFLAGS +=  -O0 -g
debug : DEMO_EXE :=$(DEMO_EXE).debug
debug : SHLIB_SONAME :=$(SHLIB).debug.so
debug : clips

release : CXXFLAGS += -O3 -fno-strict-aliasing
release : clips


$(BUILD_DIR)/%.o : $(SOURCE_DIR)/%.c
	$(CXX) -c $(CXXFLAGS) -I$(HEADER_DIR) $(WARNINGS) $< -o $@

clips : $(DEMO_EXE).o $(SHLIB) dir
	$(CXX) $(BUILD_DIR)/$< -L$(LIB_DIR) -l$(SHLIB) $(LDLIBS) -o $(BIN_DIR)/$(DEMO_EXE)

$(DEMO_EXE).o : examples/c++/demo.cc
	$(CXX) -c $(CXXFLAGS) -I$(HEADER_DIR) $(CXXFLAGS) $(WARNINGS) $< -o $(BUILD_DIR)/$@

$(SHLIB) : $(OBJS)
	rm -f $(LIB_DIR)/$@   
	$(CXX) -shared $(LDLIBS) -Wl,-soname,$(SHLIB_SONAME) $(OBJS) -o $(LIB_DIR)/$(SHLIB_SONAME).$(VERSION_MAJOR).$(VERSION_MINOR).$(VERSION_RELEASE)
  
clean : 
	-rm -f $(BUILD_DIR)/$(DEMO_EXE).o $(OBJS)
	-rm -f $(BIN_DIR)/$(DEMO_EXE)
	-rm -f $(LIB_DIR)/$(SHLIB_SONAME).$(VERSION_MINOR).$(VERSION_RELEASE)
	
.PHONY : all clips clean debug release dir lib_dir bin_dir build_dir
