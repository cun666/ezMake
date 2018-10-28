.PHONY:all clean ctags

TOP = $(PWD)
INCLIB := $(TOP)/includes
DEPDIR := $(TOP)/depend
SRC := $(TOP)/src
BLDDIR := $(TOP)/build
MAKE := make -j 2

objs := main.o test1.o test2.o

all: ctags main

ctags:
	@ctags -R

main:$(objs:%.o=$(BLDDIR)/%.o)
	@echo "  [CC] -o $@"
	@gcc -o $@ $^ -I $(INCLIB)
	@echo "GNU make version $(MAKE_VERSION)"

$(BLDDIR)/%.o:$(SRC)/%.c
	@echo "  [CC] -o $@"
	@gcc -o $@ -c $< -I $(INCLIB)

$(DEPDIR)/%.d:$(SRC)/%.c
	@echo "  [CC] -M $@"
	@gcc -M -I $(INCLIB) $< > $@.$$$$;\
	sed 's,\(^.*\)\.o[ ]*:,$@ $(BLDDIR)/&,g' < $@.$$$$ > $@;\
	rm -f $@.$$$$

clean:
	@echo "  [RM] ./build/*.o ./depend/*.d main"
	@rm -f $(BLDDIR)/* main $(DEPDIR)/*.d

sinclude $(objs:%.o=$(DEPDIR)/%.d)
