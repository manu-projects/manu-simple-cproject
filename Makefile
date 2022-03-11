-include Makefile.cfg

all: static_lib compile

static_lib: $(DIR_STATIC_LIB)/$(STATIC_LIB).a
compile: $(DIR_BIN)/$(PROGRAM).out

$(DIR_STATIC_LIB)/$(STATIC_LIB).o:
	@$(CC) $(CFLAGS) -c $(basename $@).c -o $@

# opciones del comando `ar`
#
# r: agrega/actualiza ficheros en el archivo .a (si alguno no existe, lanzará un error)
# c: crea la biblioteca pero tiene que existir el .a
# s: agrega/actualiza un índice del archivo que usará el compilador

$(DIR_STATIC_LIB)/$(STATIC_LIB).a: $(DIR_STATIC_LIB)/$(STATIC_LIB).o 
	@ar $(AR_OPTIONS) $@ $^

# también podríamos hacer más genérico $(OBJ):$(DIR_OBJ)/%.o:$(DIR_SRC)/%.c
# y creando una macro $(SRC) que le agrege los archivos con la función wildcard de gnu make
# y otra macro $(OBJ) que reemplace los .c en .o de $(SRC)
$(DIR_OBJ)/$(PROGRAM).o: $(DIR_SRC)/$(PROGRAM).c
	@$(CC) $(CFLAGS) $(CPPFLAGS) -c $^ -o $@

# también podríamos hacer más genérico $(DIR_BIN)/%.out:$(DIR_OBJ)/%.o
#
$(DIR_BIN)/$(PROGRAM).out: $(DIR_OBJ)/$(PROGRAM).o
	@$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS) $(LDLIBS)

c clean:
	@-$(RM) $(DIR_STATIC_LIB)/*.{a,o}
	@-$(RM) $(DIR_BIN)/$(PROGRAM).{o,out}

e exec:
	@$(DIR_BIN)/$(PROGRAM).out

.PHONY: all static_lib compile c clean e exec

