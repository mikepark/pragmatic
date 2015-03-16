/*  Copyright (C) 2010 Imperial College London and others.
 *
 *  Please see the AUTHORS file in the main source directory for a
 *  full list of copyright holders.
 *
 *  Gerard Gorman
 *  Applied Modelling and Computation Group
 *  Department of Earth Science and Engineering
 *  Imperial College London
 *
 *  g.gorman@imperial.ac.uk
 *
 *  Redistribution and use in source and binary forms, with or without
 *  modification, are permitted provided that the following conditions
 *  are met:
 *  1. Redistributions of source code must retain the above copyright
 *  notice, this list of conditions and the following disclaimer.
 *  2. Redistributions in binary form must reproduce the above
 *  copyright notice, this list of conditions and the following
 *  disclaimer in the documentation and/or other materials provided
 *  with the distribution.
 *
 *  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
 *  CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
 *  INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 *  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 *  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS
 *  BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 *  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
 *  TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 *  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
 *  ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
 *  TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
 *  THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 *  SUCH DAMAGE.
 */

#ifndef UGRID_H
#define UGRID_H

#include <cstdio>
#include <vector>
#include <string>
#include <cfloat>
#include <typeinfo>

#include "Mesh.h"

#ifdef HAVE_MPI
#include "mpi_tools.h"
#endif

/*! \brief Toolkit for exporting UGgrid files. This is
 * mostly used as part of the internal unit testing framework and
 * should not intended to be part of the public API unless you are
 * talking to FUN3D.
 */
template<typename real_t> class UGrid{
	public:

		static void export_ugrid(const char *basename, const Mesh<real_t> *mesh){
			size_t NElements = mesh->get_number_elements();
			size_t NNodes = mesh->get_number_nodes();
			size_t ndims = mesh->get_number_dimensions();

			assert(ndims==3);

			char filename[1024];
			sprintf(filename, "%s.ugrid", basename);

			FILE *file = fopen(filename,"w");
			if (NULL == (void *)file) printf("unable to open %s\n",filename);
			assert(NULL != (void *)file);

			size_t NBoundaryFaces = 0;

			for(size_t i=0;i<NElements;i++){
				const int *n=mesh->get_element(i);
				if(n[0]==-1)
					continue;

				for(int j=0;j<4;j++){
					if(mesh->boundary[i*4+j]>0){
						++NBoundaryFaces;
					}
				}
			}

			fprintf(file,"%d %d %d %d %d %d %d\n",NNodes,NBoundaryFaces,0,NElements,0,0,0);

			for(size_t i=0;i<NNodes;i++){
				const real_t *xyz = mesh->get_coords(i);
				fprintf(file, " %.16e %.16e %.16e\n", xyz[0], xyz[1], xyz[2] );
			}

			for(size_t i=0;i<NElements;i++){
				const int *n=mesh->get_element(i);
				if(n[0]==-1)
					continue;

				if(mesh->boundary[i*4+0]>0){
					fprintf(file," %d %d %d\n",n[1]+1,n[3]+1,n[2]+1);
				}
				if(mesh->boundary[i*4+1]>0){
					fprintf(file," %d %d %d\n",n[0]+1,n[2]+1,n[3]+1);
				}
				if(mesh->boundary[i*4+2]>0){
					fprintf(file," %d %d %d\n",n[0]+1,n[3]+1,n[1]+1);
				}
				if(mesh->boundary[i*4+3]>0){
					fprintf(file," %d %d %d\n",n[0]+1,n[1]+1,n[2]+1);
				}

			}
			for(size_t i=0;i<NElements;i++){
				const int *n=mesh->get_element(i);
				if(n[0]==-1)
					continue;
				for(size_t j=0;j<4;j++){
					if(mesh->boundary[i*4+j]>0){
						fprintf(file," %d\n",mesh->boundary[i*4+j]);
					}
				}
			}

			for(size_t i=0;i<NElements;i++){
				const int *n=mesh->get_element(i);
				if(n[0]==-1)
					continue;
				fprintf(file," %d %d %d %d\n",n[0]+1,n[1]+1,n[2]+1,n[3]+1);
			}

			fclose(file);
		}
};
#endif
