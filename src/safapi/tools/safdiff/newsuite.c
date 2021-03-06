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
/*
**
** These are a couple of helper functions for use with safdiff.
*/

#include<newsuite.h>

/*---------------------------------------------------------------------------------------------------------------------------------
 * Audience:    Public
 * Chapter:    	Field Templates
 * Purpose:    	A modified saf library function that actually returns the compoment field templates, note lookup is based on 
 *		a SAF_Field instead of a SAF_FieldTmpl.
 *
 * Description: Modified library function that actually returns the compoment field templates.
 *
 * Parallel:    Same.
 *
 * Programmer:	Matthew O'Brien, LLNL December 8, 2001
 *
 *---------------------------------------------------------------------------------------------------------------------------------
 */
int describe_field_tmpl_new(SAF_ParMode pmode,
                             SAF_Field *field, /*look, a SAF_Field, not a SAF_FieldTmpl*/
                             char **name,
                             SAF_Set *base_space, 
                             SAF_Algebraic *alg_type,
                             SAF_Basis *basis,
                             SAF_Quantity *quantity,
                             int *num_comp,
                             SAF_FieldTmpl *ctmpl)
{
	SAF_FieldTmpl field_tmpl;
	SAF_Field *comp_flds=NULL;
	int i;

	saf_describe_field(pmode, field, &field_tmpl, NULL, base_space, NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
		num_comp,&comp_flds,NULL,NULL);


	if(*num_comp > 0 && comp_flds !=NULL){

		if(ctmpl==NULL){
			 ctmpl = calloc((size_t)*num_comp, sizeof *ctmpl);                               
		}
		for(i=0; i<(*num_comp); i++){
			saf_describe_field(pmode, comp_flds+i, ctmpl+i, NULL, NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
				NULL,NULL,NULL,NULL);
		}
	}
	saf_describe_field_tmpl(pmode, &field_tmpl, name, /* base_space, */ alg_type, basis, quantity, num_comp,NULL);


	free(comp_flds);
	return 0;
} 



/*---------------------------------------------------------------------------------------------------------------------------------
 * Audience:    Public
 * Chapter:    	Field Templates
 * Purpose:     Modified library function that lets you filter on the number of component fields when finding field templates.
 *
 * Description: Modified library function that lets you filter on the number of component fields when finding field templates.
 *
 * Issues:	
 *
 * Parallel:    Same.
 *
 * Programmer:	Matthew O'Brien, LLNL December 7, 2001
 *
 *---------------------------------------------------------------------------------------------------------------------------------
 */
int find_field_tmpls_new(SAF_ParMode pmode,
                          SAF_Db *database,
                          const char *name,
                          SAF_Algebraic *atype,
                          SAF_Basis *basis,
                          SAF_Quantity *quantity,
			  int num_comp,   /* NEW ARGUMENT: the returned field templates must have this many component fields, new feature*/
                          int *Pnum_ftmpls,
                          SAF_FieldTmpl *Pftmpls)
{

  int r, i;
  int return_count=0;
  int particularnum_comp;
  SAF_FieldTmpl *tempfield_tmpls=NULL;

  r=saf_find_field_tmpls(pmode, database, name, atype, basis, quantity, Pnum_ftmpls, &Pftmpls);

  /* tempfield_tmpls=(SAF_FieldTmpl *)malloc(*Pnum_ftmpls *sizeof(SAF_FieldTmpl)); */
  tempfield_tmpls = (SAF_FieldTmpl *)calloc((size_t)*Pnum_ftmpls, sizeof(SAF_FieldTmpl));

  for(i=0; i<*Pnum_ftmpls; i++){
    saf_describe_field_tmpl(pmode, Pftmpls+i,NULL,NULL,NULL,NULL,&particularnum_comp,NULL);
    if(particularnum_comp == num_comp){
      tempfield_tmpls[return_count++]=Pftmpls[i];
    }
  }

  memcpy(Pftmpls, tempfield_tmpls, return_count*sizeof(SAF_FieldTmpl));
  (*Pnum_ftmpls)=return_count;

  free(tempfield_tmpls);
  return r;
}


