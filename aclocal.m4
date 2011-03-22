AC_DEFUN([ACX_zoltan], [
# Set variables...
AC_ARG_WITH(
	[zoltan],
	[  --with-zoltan=prefix        Prefix where zoltan is installed],
	[zoltan="$withval"],
    [])

tmpLIBS=$LIBS
tmpCPPFLAGS=$CPPFLAGS
if test "x$zoltan" != "xno"; then
if test "x$zoltan" != "xyes"; then
zoltan_LIBS_PATH="$zoltan/lib"
zoltan_INCLUDES_PATH="$zoltan/include"
# Ensure the comiler finds the library...
tmpLIBS="$tmpLIBS -L$zoltan_LIBS_PATH"
tmpCPPFLAGS="$tmpCPPFLAGS  -I/$zoltan_INCLUDES_PATH"
fi
tmpLIBS="$tmpLIBS -L/usr/lib -L/usr/local/lib/ -lzoltan -lparmetis $ZOLTAN_DEPS"
tmpCPPFLAGS="$tmpCPPFLAGS -I/usr/include/ -I/usr/local/include/"
fi
LIBS=$tmpLIBS
CPPFLAGS=$tmpCPPFLAGS
# Check that the compiler uses the library we specified...
if test -e $zoltan_LIBS_PATH/libzoltan.a; then
	echo "note: using $zoltan_LIBS_PATH/libzoltan.a"
fi 

# Check that the compiler uses the include path we specified...
if test -e $zoltan_INCLUDES_PATH/zoltan.mod; then
	echo "note: using $zoltan_INCLUDES_PATH/zoltan.mod"
fi 


AC_LANG_SAVE
AC_LANG_C
AC_CHECK_LIB(
	[zoltan],
	[Zoltan_Initialize],
	[AC_DEFINE(HAVE_ZOLTAN,1,[Define if you have zoltan library.])],
	[AC_MSG_ERROR( [Could not link in the zoltan library... exiting] )] )
# Save variables...
AC_LANG_RESTORE

ZOLTAN="yes"
AC_SUBST(ZOLTAN)

echo $LIBS
])dnl ACX_zoltan

# ===========================================================================
#            http://autoconf-archive.cryp.to/ax_check_define.html
# ===========================================================================
#
# SYNOPSIS
#
#   AC_CHECK_DEFINE([symbol], [ACTION-IF-FOUND], [ACTION-IF-NOT])
#   AX_CHECK_DEFINE([includes],[symbol], [ACTION-IF-FOUND], [ACTION-IF-NOT])
#
# DESCRIPTION
#
#   Complements AC_CHECK_FUNC but it does not check for a function but for a
#   define to exist. Consider a usage like:
#
#    AC_CHECK_DEFINE(__STRICT_ANSI__, CFLAGS="$CFLAGS -D_XOPEN_SOURCE=500")
#
# LICENSE
#
#   Copyright (c) 2008 Guido U. Draheim <guidod@gmx.de>
#
#   This program is free software; you can redistribute it and/or modify it
#   under the terms of the GNU General Public License as published by the
#   Free Software Foundation; either version 2 of the License, or (at your
#   option) any later version.
#
#   This program is distributed in the hope that it will be useful, but
#   WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
#   Public License for more details.
#
#   You should have received a copy of the GNU General Public License along
#   with this program. If not, see <http://www.gnu.org/licenses/>.
#
#   As a special exception, the respective Autoconf Macro's copyright owner
#   gives unlimited permission to copy, distribute and modify the configure
#   scripts that are the output of Autoconf when processing the Macro. You
#   need not follow the terms of the GNU General Public License when using
#   or distributing such scripts, even though portions of the text of the
#   Macro appear in them. The GNU General Public License (GPL) does govern
#   all other use of the material that constitutes the Autoconf Macro.
#
#   This special exception to the GPL applies to versions of the Autoconf
#   Macro released by the Autoconf Archive. When you make and distribute a
#   modified version of the Autoconf Macro, you may extend this special
#   exception to the GPL to apply to your modified version as well.

AC_DEFUN([AC_CHECK_DEFINED],[
AS_VAR_PUSHDEF([ac_var],[ac_cv_defined_$1])dnl
AC_CACHE_CHECK([for $1 defined], ac_var,
AC_TRY_COMPILE(,[
  #ifdef $1
  int ok;
  #else
  choke me
  #endif
],AS_VAR_SET(ac_var, yes),AS_VAR_SET(ac_var, no)))
AS_IF([test AS_VAR_GET(ac_var) != "no"], [$2], [$3])dnl
AS_VAR_POPDEF([ac_var])dnl
])

AC_DEFUN([AX_CHECK_DEFINED],[
AS_VAR_PUSHDEF([ac_var],[ac_cv_defined_$2])dnl
AC_CACHE_CHECK([for $1 defined], ac_var,
AC_TRY_COMPILE($1,[
  #ifndef $2
  int ok;
  #else
  choke me
  #endif
],AS_VAR_SET(ac_var, yes),AS_VAR_SET(ac_var, no)))
AS_IF([test AS_VAR_GET(ac_var) != "no"], [$3], [$4])dnl
AS_VAR_POPDEF([ac_var])dnl
])

AC_DEFUN([AX_CHECK_FUNC],
[AS_VAR_PUSHDEF([ac_var], [ac_cv_func_$2])dnl
AC_CACHE_CHECK([for $2], ac_var,
dnl AC_LANG_FUNC_LINK_TRY
[AC_LINK_IFELSE([AC_LANG_PROGRAM([$1
                #undef $2
                char $2 ();],[
                char (*f) () = $2;
                return f != $2; ])],
                [AS_VAR_SET(ac_var, yes)],
                [AS_VAR_SET(ac_var, no)])])
AS_IF([test AS_VAR_GET(ac_var) = yes], [$3], [$4])dnl
AS_VAR_POPDEF([ac_var])dnl
])# AC_CHECK_FUNC
