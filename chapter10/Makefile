# leave these lines alone
.SUFFIXES: .erl .beam .yrl

.erl.beam:
	erlc -W $<
.yrl.erl:
	erlc -W $<

ERL = erl -noshell
ERL_SUFFIX = -s init stop

# Here's a list of the erlang modules you want compiling
# If the modules don't fit onto one line add a \ character
# to the end of the line and continue on the next line

# Edit the lines below
MODS = geometry geometry_test

# The first target in any makefile is the default target.
# If you just type "make" then "make all" is assumed (because
#   "all" is the first target in this makefile)

all: compile

compile: ${MODS:%=%.beam}

## special compilation requirements are added here

special1.beam: special1.erl
	${ERL} -Dflag1 -W0 special1.erl

## run an application from the makefile

application1: compile
	${ERL} -pa Dir1  -s application1 start Arg1 Arg2

test: compile
	${ERL} -s geometry_test all ${ERL_SUFFIX}

# the subdirs target compiles any code in
# sub-directories

#subdirs:
#cd dir1; $(MAKE)
#	cd dir2; $(MAKE)
#	...

# remove all the code

clean:
	rm -rf *.beam erl_crash.dump
# cd dir1; $(MAKE) clean
# cd dir2; $(MAKE) clean
