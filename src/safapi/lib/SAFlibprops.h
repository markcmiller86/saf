/*
 * Copyright(C) 1999-2005 The Regents of the University of California.
 *     This work  was produced, in  part, at the  University of California, Lawrence Livermore National
 *     Laboratory    (UC LLNL)  under    contract number   W-7405-ENG-48 (Contract    48)   between the
 *     U.S. Department of Energy (DOE) and The Regents of the University of California (University) for
 *     the  operation of UC LLNL.  Copyright  is reserved to  the University for purposes of controlled
 *     dissemination, commercialization  through formal licensing, or other  disposition under terms of
 *     Contract 48; DOE policies, regulations and orders; and U.S. statutes.  The rights of the Federal
 *     Government  are reserved under  Contract 48 subject  to the restrictions agreed  upon by DOE and
 *     University.
 * 
 * Copyright(C) 1999-2005 Sandia Corporation.  
 *     Under terms of Contract DE-AC04-94AL85000, there is a non-exclusive license for use of this work
 *     on behalf of the U.S. Government.  Export  of this program may require a license from the United
 *     States Government.
 * 
 * Disclaimer:
 *     This document was  prepared as an account of  work sponsored by an agency  of  the United States
 *     Government. Neither the United States  Government nor the United States Department of Energy nor
 *     the  University  of  California  nor  Sandia  Corporation nor any  of their employees  makes any
 *     warranty, expressed  or  implied, or  assumes   any  legal liability  or responsibility  for the
 *     accuracy,  completeness,  or  usefulness  of  any  information, apparatus,  product,  or process
 *     disclosed,  or  represents that its  use would   not infringe  privately owned rights. Reference
 *     herein  to any  specific commercial  product,  process,  or  service by  trade  name, trademark,
 *     manufacturer,  or  otherwise,  does  not   necessarily  constitute  or  imply  its  endorsement,
 *     recommendation, or favoring by the  United States Government   or the University of  California.
 *     The views and opinions of authors expressed herein do not necessarily state  or reflect those of
 *     the  United  States Government or  the   University of California   and shall  not be  used  for
 *     advertising or product endorsement purposes.
 * 
 * 
 * Active Developers:
 *     Peter K. Espen              SNL
 *     Eric A. Illescas            SNL
 *     Jake S. Jones               SNL
 *     Robb P. Matzke              LLNL
 *     Greg Sjaardema              SNL
 * 
 * Inactive Developers:
 *     William J. Arrighi          LLNL
 *     Ray T. Hitt                 SNL
 *     Mark C. Miller              LLNL
 *     Matthew O'Brien             LLNL
 *     James F. Reus               LLNL
 *     Larry A. Schoof             SNL
 * 
 * Acknowledgements:
 *     Marty L. Barnaby            SNL - Red parallel perf. study/tuning
 *     David M. Butler             LPS - Data model design/implementation Spec.
 *     Albert K. Cheng             NCSA - Parallel HDF5 support
 *     Nancy Collins               IBM - Alpha/Beta user
 *     Linnea M. Cook              LLNL - Management advocate
 *     Michael J. Folk             NCSA - Management advocate 
 *     Richard M. Hedges           LLNL - Blue-Pacific parallel perf. study/tuning 
 *     Wilbur R. Johnson           SNL - Early developer
 *     Quincey Koziol              NCSA - Serial HDF5 Support 
 *     Celeste M. Matarazzo        LLNL - Management advocate
 *     Tyce T. McLarty             LLNL - parallel perf. study/tuning
 *     Tom H. Robey                SNL - Early developer
 *     Reinhard W. Stotzer         SNL - Early developer
 *     Judy Sturtevant             SNL - Red parallel perf. study/tuning 
 *     Robert K. Yates             LLNL - Blue-Pacific parallel perf. study/tuning
 * 
 */

#ifndef SAF_LIBPROPS_H
/*DOCUMENTED*/
#define SAF_LIBPROPS_H

typedef struct SAF_LibProps SAF_LibProps;

/*---------------------------------------------------------------------------------------------------------------------------------
 * Audience:    Public
 * Chapter:    	Datatypes 
 * Purpose:     Library properties
 *
 * Description:	Identifiers for default properties for the library.
 *---------------------------------------------------------------------------------------------------------------------------------
 */
#define SAF_DEFAULT_LIBPROPS	NULL        /* argument to pass to saf_init() to specify default behavior */ 

/*---------------------------------------------------------------------------------------------------------------------------------
 * Audience:    Public
 * Chapter:     Datatypes
 * Purpose:     Error return modes
 *
 * Description: see saf_setProps_ErrMode() 
 *---------------------------------------------------------------------------------------------------------------------------------
 */
typedef enum {
    SAF_ERRMODE_RETURN=0,	/* (The default) Library will issue return codes rather than throw exceptions */
   SAF_ERRMODE_THROW		/* Library will throw exceptions rather than issue return codes */
} SAF_ErrMode;

/*---------------------------------------------------------------------------------------------------------------------------------
 * Audience:    Public
 * Chapter:     Datatypes
 * Purpose:     String allocation modes
 *
 * Description: see saf_setProps_StrMode() 
 *---------------------------------------------------------------------------------------------------------------------------------
 */
typedef enum {
   SAF_STRMODE_LIB=0,	/* library allocates *but* client frees (zero is the default) */ 
   SAF_STRMODE_CLIENT,	/* client allocates *and* client frees */
   SAF_STRMODE_POOL	/* library allocates *and* library frees using a least recently used strategy involving a pool
			 * of many strings */
} SAF_StrMode;

/*---------------------------------------------------------------------------------------------------------------------------------
 * Audience:   	Private
 * Chapter:     Datatypes
 * Purpose:     Error logging modes
 *
 * Description: see description of SAF_ERROR_LOG environment variable in the chapter on environment variables for a description
 *		of these modes. 
 *---------------------------------------------------------------------------------------------------------------------------------
 */
typedef enum {
   SAF_ERRLOG_STDERR=0,	/* (The default) Log errors to stderr. Parallel plaforms do NOT support atomicity of printf'd
                         * messages. However, most parallel platforms *do* guarantee that no processor will overwrite another
                         * processor's characters */
   SAF_ERRLOG_FILE,	/* log errors to a single file. In parallel, all processor's messages go to a single file. Again, there
			 * is no guarantee of atomicity of printf'd messages; only that every processor's characters will
			 * appear in the output stream. */
   SAF_ERRLOG_PROCFILE, /* log errors to a file for each processor. In serial, only one file is generated */
   SAF_ERRLOG_SEGFILE, 	/* log errors to a single file, but guarantee that each processor's messages will appear contigously
			 * and uninterrupted from other processor's outputs by logging each processor's outputs to specific
			 * offsets in the file */
   SAF_ERRLOG_NONE	/* don't do any error logging */
} SAF_ErrLogMode;

/*---------------------------------------------------------------------------------------------------------------------------------
 * Audience:   	Private
 * Chapter:     Datatypes
 * Purpose:     Trace logging modes
 *
 * Description: see description of SAF_TRACING environment variable in the chapter on environment variables for a description
 *		of these modes. 
 *---------------------------------------------------------------------------------------------------------------------------------
 */
typedef enum {
   SAF_TRACELOG_NONE=1,		/* no trace logging output is generated */
   SAF_TRACELOG_PUBLIC,		/* logging of only the public API calls is generated */
   SAF_TRACELOG_PRIVATE		/* logging of both public and private API calls is generated */
} SAF_TraceLogMode;

/* error function type for saf_setProps_ErrFunc() */
typedef void (*SAF_ErrFunc)(void);

/* Function prototypes */
#ifdef __cplusplus
extern "C" {
#endif
SAF_LibProps *saf_createProps_lib(void);
SAF_LibProps *saf_freeProps_lib(SAF_LibProps *properties);
int saf_setProps_StrMode(SAF_LibProps *properties, SAF_StrMode mode);
int saf_setProps_StrPoolSize(SAF_LibProps *properties, int size);
int saf_setProps_ErrorMode(SAF_LibProps *properties, SAF_ErrMode mode);
int saf_setProps_ErrFunc(SAF_LibProps *properties, SAF_ErrFunc func);
int saf_setProps_ErrorLogging(SAF_LibProps *properties, const char *mode);
int saf_setProps_Registry(SAF_LibProps *properties, const char *name);
int saf_setProps_DontAbort(SAF_LibProps *properties);
int saf_setProps_LibComm(SAF_LibProps *properties, MPI_Comm communicator);

#ifdef __cplusplus
}
#endif

#endif /* !SAF_LIBPROPS_H */