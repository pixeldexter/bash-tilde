/* tildeexp - funny tilde expansions for bash */

/* See Makefile for compilation details. */

#include <config.h>

#if defined (HAVE_UNISTD_H)
#  include <unistd.h>
#endif
#include "bashansi.h"
#include <stdio.h>
#include <errno.h>

#include "builtins.h"
#include "shell.h"
#include "variables.h"
#include "assoc.h"
#include "builtins/common.h"
#include "bashgetopt.h"

#include <tilde/tilde.h>

#if !defined (errno)
extern int errno;
#endif

extern char *strerror ();

#ifndef __attribute__
#  if __GNUC__ < 2 || (__GNUC__ == 2 && __GNUC_MINOR__ < 8)
#    define __attribute__(x)
#  endif
#endif

static char *(*s_preexp_hook_save)(char*);

static char
*find_hash_expansion(name, what)
     char *name;
     char *what;
{
  SHELL_VAR *var = find_variable(name);
  if ( !var )
    return NULL;

  return assoc_reference(assoc_cell(var), what);
}

static char *
tildeexp_tilde_expansions(text)
     char *text;
{
  char *result = NULL;

  if ( text[0] == '~' && text[1] != '\0' )
    result = find_hash_expansion("BASH_DIR_ALIASES", text + 1);
  /* else if - for future expansion */

  if ( result )
    result = savestring(result);

  if ( !result && s_preexp_hook_save )
    result = s_preexp_hook_save(text);

  return result;
}

static __attribute__((constructor)) void
tildeexp_init()
{
  s_preexp_hook_save = tilde_expansion_preexpansion_hook;
  tilde_expansion_preexpansion_hook = tildeexp_tilde_expansions;
}

static __attribute__((destructor)) void
tildeexp_fini()
{
  tilde_expansion_preexpansion_hook = s_preexp_hook_save;
}

int
tildeexp_builtin (list)
     WORD_LIST *list;
{
  int opt, rval;

  rval = EXECUTION_SUCCESS;
  reset_internal_getopt ();
  while ((opt = internal_getopt (list, "")) != -1)
    {
      switch (opt)
	{
	default:
	  builtin_usage ();
	  return (EX_USAGE);
	}
    }
  list = loptend;

  return (rval);
}

char *tildeexp_doc[] = {
	"Short description.",
	""
	"Longer description of builtin and usage.",
	(char *)NULL
};

struct builtin tildeexp_struct = {
	"tildeexp",			/* builtin name */
	tildeexp_builtin,		/* function implementing the builtin */
	BUILTIN_ENABLED,		/* initial flags for builtin */
	tildeexp_doc,			/* array of long documentation strings. */
	"template",			/* usage synopsis; becomes short_doc */
	0				/* reserved for internal use */
};
