#include "erptool.h"

VALUE rb_mErptool;

void
Init_erptool(void)
{
  rb_mErptool = rb_define_module("Erptool");
}
