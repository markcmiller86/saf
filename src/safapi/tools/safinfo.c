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
#include <safP.h> 

int
main(int argc,
     char **argv)
{
   char dbname[1024];
   int hadErrors=0,rank=0;
   SAF_PathInfo info;
   int isParallel=0;  /* had to add this because it was not initialized anywhere */

   if (argc<=1)
      exit(-1);
   strcpy(dbname, argv[1]);

#ifdef HAVE_PARALLEL
   MPI_Init(&argc,&argv);
   MPI_Comm_rank(MPI_COMM_WORLD, &rank);
#endif

  saf_init(SAF_DEFAULT_LIBPROPS);

  if (rank == 0)
  {
  SAF_TRY_BEGIN
  {
     info = saf_readInfo_path(dbname,1);

     if (saf_getInfo_staterror(info))
     {
        printf("stat failed on \"%s\" with error \"%s\"\n", dbname, saf_getInfo_errmsg(info));
	printf("permissions on \"%s\" are %o\n", dbname, (unsigned int) saf_getInfo_permissions(info));
	hadErrors = 1;
     }
     else if (!saf_getInfo_isSAFdatabase(info))
     {
        if (saf_getInfo_isHDFfile(info))
	{
	   printf("although \"%s\" appears to be an HDF5 file, it is not a SAF database file\n", dbname);
        }
	hadErrors = 1;
     }
     else
     {
        int major, minor, patch;
	char annot[16];

        printf("\"%s\" is a SAF database master file\n",dbname);
	printf("It was generated by a client with...\n");
        saf_getInfo_libversion(info, &major, &minor, &patch, annot);
	printf("   + version %d.%d.%d%c%s of the SAF library\n",
	   major, minor, patch, !strcmp(annot,"none")?' ':'-', !strcmp(annot,"none")?"":annot);
        saf_getInfo_hdfversion(info, &major, &minor, &patch, annot);
	printf("   + version %d.%d.%d%c%s of the HDF5 library\n",
	   major, minor, patch, annot[0]=='\0'?' ':'-', annot[0]=='\0'?"":annot);
        if (isParallel)
	{
           saf_getInfo_mpiversion(info, &major, &minor, &patch, annot);
	   printf("   + version %d.%d.%d%c%s of the MPIO library\n",
	      major, minor, patch, !strcmp(annot,"none")?'-':' ', !strcmp(annot,"none")?"":annot);
	}
     }

     saf_freeInfo_path(info);

  }
  SAF_CATCH
  {
    SAF_CATCH_ALL
    {
       hadErrors = 1;
    }
  }
  }

#ifdef HAVE_PARALLEL
  MPI_Barrier(MPI_COMM_WORLD);
#endif

  saf_final();

#ifdef HAVE_PARALLEL
  /* make sure everyone returns the same error status */
  MPI_Bcast(&hadErrors, 1, MPI_INT, 0, MPI_COMM_WORLD);
  MPI_Finalize();
#endif

  return hadErrors;
}
