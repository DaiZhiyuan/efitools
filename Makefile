BINARIES = cert-to-efi-sig-list sig-list-to-certs sign-efi-sig-list \
	hash-to-efi-sig-list efi-readvar efi-updatevar cert-to-efi-hash-list \
	flash-var

export TOPDIR	:= $(shell pwd)/

include Make.rules

all: $(BINARIES) $(MANPAGES) 

install: all
	$(INSTALL) -m 755 -d $(MANDIR)
	$(INSTALL) -m 644 $(MANPAGES) $(MANDIR)
	$(INSTALL) -m 755 -d $(BINDIR)
	$(INSTALL) -m 755 $(BINARIES) $(BINDIR)
	$(INSTALL) -m 755 mkusb.sh $(BINDIR)/efitool-mkusb
	$(INSTALL) -m 755 -d $(DOCDIR)
	$(INSTALL) -m 644 README COPYING $(DOCDIR)

lib/lib.a lib/lib-efi.a: FORCE
	$(MAKE) -C lib $(notdir $@)

lib/asn1/libasn1.a lib/asn1/libasn1-efi.a: FORCE
	$(MAKE) -C lib/asn1 $(notdir $@)

cert-to-efi-sig-list: cert-to-efi-sig-list.o lib/lib.a
	$(CC) $(ARCH3264) -o $@ $< -lcrypto lib/lib.a

sig-list-to-certs: sig-list-to-certs.o lib/lib.a
	$(CC) $(ARCH3264) -o $@ $< -lcrypto lib/lib.a

sign-efi-sig-list: sign-efi-sig-list.o lib/lib.a
	$(CC) $(ARCH3264) -o $@ $< -lcrypto lib/lib.a

hash-to-efi-sig-list: hash-to-efi-sig-list.o lib/lib.a
	$(CC) $(ARCH3264) -o $@ $< lib/lib.a

cert-to-efi-hash-list: cert-to-efi-hash-list.o lib/lib.a
	$(CC) $(ARCH3264) -o $@ $< -lcrypto lib/lib.a

efi-keytool: efi-keytool.o lib/lib.a
	$(CC) $(ARCH3264) -o $@ $< lib/lib.a

efi-readvar: efi-readvar.o lib/lib.a
	$(CC) $(ARCH3264) -o $@ $< -lcrypto lib/lib.a

efi-updatevar: efi-updatevar.o lib/lib.a
	$(CC) $(ARCH3264) -o $@ $< -lcrypto lib/lib.a

flash-var: flash-var.o lib/lib.a
	$(CC) $(ARCH3264) -o $@ $< lib/lib.a

clean:
	rm -f PK.* KEK.* DB.* $(EFISIGNED) $(BINARIES) *.o *.so
	rm -f noPK.*
	rm -f doc/*.1
	$(MAKE) -C lib clean
	$(MAKE) -C lib/asn1 clean

FORCE:



