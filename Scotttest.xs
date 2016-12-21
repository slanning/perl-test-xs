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

#define A_DEFINED_CONSTANT 42

#define A_READ_BUF_SIZE 512

void test_dump(FILE *fp, const char *string) {
    fprintf(fp, "This was your string: %s\n", string);
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


BOOT:
    {
  HV *stash = gv_stashpvn("Scotttest", 9, TRUE);
  /* note: don't use #ifdef on enums, etc. */
#ifdef A_DEFINED_CONSTANT
  newCONSTSUB(stash, "A_DEFINED_CONSTANT", newSViv(A_DEFINED_CONSTANT));
#endif

    }
