#ifdef __cplusplus
extern "C" {
#endif
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "ppport.h"
#ifdef __cplusplus
}
#endif

/* tmpfile, rewind, fscanf, fclose */
#include <stdio.h>

#define A_READ_BUF_SIZE 512

#define A_TEST_DUMP_FORMAT "This was your string: %s\n"
#define A_PACKAGE "Scotttest"

void test_dump(FILE *fp, const char *string) {
    fprintf(fp, A_TEST_DUMP_FORMAT, string);
}


MODULE = Scotttest    PACKAGE = Scotttest

## This handles fp_sv specially,
## because the typemap for FILE * doesn't work
## with in particular the $fh from open(my $fh, ">", \$buf)
void
test_dump(SV *fp_sv, char *str)
  PREINIT:
    IO *iop;
  CODE:
    iop = sv_2io(fp_sv);

    if (iop) {
        PerlIO *perliop;
        perliop = IoOFP(iop);

        if (perliop) {
            FILE *fp;
            fp = PerlIO_findFILE(perliop);

            if (fp) {
                test_dump(fp, str);
            } else {
                char buf[A_READ_BUF_SIZE];

                fp = tmpfile();
                test_dump(fp, str);
                rewind(fp);
                for (;;) {
                    size_t n = fread(buf, 1, A_READ_BUF_SIZE, fp);
                    PerlIO_write(perliop, buf, n);
                    if (n < A_READ_BUF_SIZE)
                        break;
                }
                fclose(fp);
            }
        } else {
            warn("Couldn't dump to filehandle (perliop NULL)\n");
        }
    } else {
        warn("Couldn't dump to filehandle (iop NULL)\n");
    }

## Ævar Arnfjörð Bjarmason suggested
## relying on Perl to deal with the filehandle part;
## so here we push whatever SV* is supposed to be a "filehandle"
## onto test_dump_print's arguments,
## test_dump_print being a Perl function in Scotttest.pm
void
test_dump_avar(SV *fh, char *str)
  INIT:
    FILE *fp;
    char buf[A_READ_BUF_SIZE];
  CODE:
    fp = tmpfile();
    test_dump(fp, str);
    rewind(fp);
    for (;;) {
        size_t n = fread(buf, 1, A_READ_BUF_SIZE, fp);
        if (n) {
            PUSHMARK(SP);
            XPUSHs(fh);
            XPUSHs(sv_2mortal(newSVpvn(buf, n)));
            PUTBACK;
            call_pv(A_PACKAGE "::test_dump_print", G_VOID);
        }
        if (n < A_READ_BUF_SIZE)
            break;
    }
    fclose(fp);


BOOT:
    {
  HV *stash = gv_stashpvn("Scotttest", 9, TRUE);
  /* note: don't use #ifdef on enums, etc. */
#ifdef A_TEST_DUMP_FORMAT
  newCONSTSUB(stash, "A_TEST_DUMP_FORMAT", newSVpv(A_TEST_DUMP_FORMAT, strlen(A_TEST_DUMP_FORMAT)));
#endif

    }
