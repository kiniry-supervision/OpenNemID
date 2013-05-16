MY_FSTAR_HOME=`cygpath "$(FSTAR_HOME)"`
FSTAR=fstar --genIL --writePrims --odir bin --dotnet4 --parallel --logQueries
FSTAR_SRC= typefunc.fst crypto.fst certstore.fst messaging.fst samlprotocol.fst serviceprovider.fst identityprovider.fst database.fst authenticationprovider.fst browser.fst main.fst

all: clean dirs protocol

dirs:
	mkdir -p queries bin

protocol:
	$(FSTAR) $(FSTAR_SRC)

clean:
	rm -rf bin queries