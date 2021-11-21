   /*******************************************************/
   /*      "C" Language Integrated Production System      */
   /*                                                     */
   /*               CLIPS Version 6.40  08/06/16          */
   /*                                                     */
   /*                     MAIN MODULE                     */
   /*******************************************************/

/*************************************************************/
/* Purpose:                                                  */
/*                                                           */
/* Principal Programmer(s):                                  */
/*      Gary D. Riley                                        */
/*                                                           */
/* Contributing Programmer(s):                               */
/*                                                           */
/* Revision History:                                         */
/*                                                           */
/*      6.24: Moved UserFunctions and EnvUserFunctions to    */
/*            the new userfunctions.c file.                  */
/*                                                           */
/*      6.40: Removed use of void pointers for specific      */
/*            data structures.                               */
/*                                                           */
/*            Moved CatchCtrlC to main.c.                    */
/*                                                           */
/*************************************************************/

/***************************************************************************/
/*                                                                         */
/* Permission is hereby granted, free of charge, to any person obtaining   */
/* a copy of this software and associated documentation files (the         */
/* "Software"), to deal in the Software without restriction, including     */
/* without limitation the rights to use, copy, modify, merge, publish,     */
/* distribute, and/or sell copies of the Software, and to permit persons   */
/* to whom the Software is furnished to do so.                             */
/*                                                                         */
/* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS */
/* OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF              */
/* MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT   */
/* OF THIRD PARTY RIGHTS. IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY  */
/* CLAIM, OR ANY SPECIAL INDIRECT OR CONSEQUENTIAL DAMAGES, OR ANY DAMAGES */
/* WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN   */
/* ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF */
/* OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.          */
/*                                                                         */
/***************************************************************************/

#include "clips.h"

#if   UNIX_V || LINUX || DARWIN || UNIX_7 || WIN_GCC || WIN_MVC
#include <signal.h>
#endif

/***************************************/
/* LOCAL INTERNAL FUNCTION DEFINITIONS */
/***************************************/

#if UNIX_V || LINUX || DARWIN || UNIX_7 || WIN_GCC || WIN_MVC
   static void                    CatchCtrlC(int);
#endif

/***************************************/
/* LOCAL INTERNAL VARIABLE DEFINITIONS */
/***************************************/

   static Environment            *mainEnv;

/****************************************/
/* main: Starts execution of the expert */
/*   system development environment.    */
/****************************************/
int main(
  int argc,
  char *argv[])
  {
   mainEnv = CreateEnvironment();


/*
You can use the Load function (section 3.2.2) to load a file. 
There is an example of its use in section 3.6.1.

You can use the GetNextActivation function (section 12.7.1) to determine 
if the agenda has any activations.

The simplest way to create facts is using the AssertString function (section 3.3.1). 
Sections 3.6.2, 4.5.4, and 5.3 have an example use of this function. 
You can also use the FactBuilder functions described in section 7.1 
(with an example in section 7.6.1).

If the results of your program running are represented by facts, 
you can use the fact query functions via the Eval function to retrieve 
those values from your program. Section 4.5.4 has an example.
*/










#if UNIX_V || LINUX || DARWIN || UNIX_7 || WIN_GCC || WIN_MVC
   signal(SIGINT,CatchCtrlC);
#endif

   RerouteStdin(mainEnv,argc,argv);
   CommandLoop(mainEnv);

   /*==================================================================*/
   /* Control does not normally return from the CommandLoop function.  */
   /* However if you are embedding CLIPS, have replaced CommandLoop    */
   /* with your own embedded calls that will return to this point, and */
   /* are running software that helps detect memory leaks, you need to */
   /* add function calls here to deallocate memory still being used by */
   /* CLIPS. If you have a multi-threaded application, no environments */
   /* can be currently executing.                                      */
   /*==================================================================*/

   DestroyEnvironment(mainEnv);

   return -1;
  }

#if UNIX_V || LINUX || DARWIN || UNIX_7 || WIN_GCC || WIN_MVC || DARWIN
/***************/
/* CatchCtrlC: */
/***************/
static void CatchCtrlC(
  int sgnl)
  {
   SetHaltExecution(mainEnv,true);
   CloseAllBatchSources(mainEnv);
   signal(SIGINT,CatchCtrlC);
  }
#endif
