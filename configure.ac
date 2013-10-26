dnl Process this file with autoconf to produce a configure script.
dnl Created by Anjuta application wizard.

AC_INIT(nomeolvides, 0.7.514, https://github.com/softwareperonista/nomeolvides/issue, nomeolvides, https://github.com/softwareperonista/nomeolvides)

AC_CONFIG_MACRO_DIR([m4])

AC_CONFIG_HEADERS([config.h])

AM_INIT_AUTOMAKE([1.11])

AM_SILENT_RULES([yes])

AC_PROG_CC


LT_INIT


dnl Check for vala
AM_PROG_VALAC([0.20.0])

# i18n stuff
IT_PROG_INTLTOOL([0.40])

AM_GNU_GETTEXT([external])
AM_GNU_GETTEXT_VERSION([0.17])

GETTEXT_PACKAGE=nomeolvides
AC_DEFINE_UNQUOTED([GETTEXT_PACKAGE], ["$GETTEXT_PACKAGE"], [Gettext Package])
AC_SUBST(GETTEXT_PACKAGE)

nomeolvideslocaledir='${prefix}/${DATADIRNAME}/locale'
AC_SUBST(nomeolvideslocaledir)


PKG_CHECK_MODULES(NOMEOLVIDES, sqlite3
[gtk+-3.0 ])

GLIB_COMPILE_RESOURCES=`$PKG_CONFIG --variable glib_compile_resources gio-2.0`
AC_SUBST(GLIB_COMPILE_RESOURCES)

AC_OUTPUT([
Makefile
src/Makefile
po/Makefile.in
data/Makefile
data/nomeolvides.desktop.in
])
