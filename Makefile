#/*++
#
# Copyright (c) 2006, Intel Corporation                                                         
# All rights reserved. This program and the accompanying materials                          
# are licensed and made available under the terms and conditions of the BSD License         
# which accompanies this distribution.  The full text of the license may be found at        
# http://opensource.org/licenses/bsd-license.php                                            
#                                                                                          
# THE PROGRAM IS DISTRIBUTED UNDER THE BSD LICENSE ON AN "AS IS" BASIS,                     
# WITHOUT WARRANTIES OR REPRESENTATIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED. 
# 
#  Module Name:
#
#    makefile
#
#  Abstract:
#
#    Makefile for the SNPNT32IO library.
#


#
#WINPCAP_DIR is the directory that contains the WinPcap developer's package
#The TARGET can be either DEBUG or RELEASE. Adapt these two directives to your need
#
WINPCAP_DIR = ".\WpdPack"
TARGET      = DEBUG

#
#Change the output directory and compile parameters according to the TARGET.
#
!IF "$(TARGET)" == "DEBUG"
OUTPUT_DIR  = Debug
C_DEFINES   = /D "WIN32" /D "SNPNT32IO_EXPORTS"
C_FLAGS     = /Od /FD /MTd /Fo"Debug/" /Fd"Debug/vc70" /W3 /c /Wp64 /ZI /TC 
LINK_FLAGS  = /DLL /DEBUG /PDB:"Debug/SnpNt32Io.pdb"
!ELSE
OUTPUT_DIR  = Release
C_DEFINES   = /D "WIN32" /D "NDEBUG" /D "SNPNT32IO_EXPORTS" 
C_FLAGS     = /O2 /FD /MT /GS /Fo"Release/" /Fd"Release/vc70" /W3 /c /Wp64 /Zi /TC 
LINK_FLAGS  = /DLL
!ENDIF


#
#Main section to build the SnpNt32Io.DLL. The "-" before command prevents the
#nmake to exit when the command returns an error 
#
SnpNt32Io.DLL : SnpNt32Io.obj
 link $(LINK_FLAGS) /IMPLIB:"$(OUTPUT_DIR)/SnpNt32Io.lib" /LIBPATH:$(WINPCAP_DIR)\Lib\
	  /OUT:"$(OUTPUT_DIR)/SnpNt32Io.dll" wpcap.lib packet.lib $(OUTPUT_DIR)/SnpNt32Io.obj
  
SnpNt32Io.obj : src\SnpNt32Io.c
 - md $(OUTPUT_DIR)
 cl   /I $(WINPCAP_DIR)\Include $(C_DEFINES) $(C_FLAGS) src\SnpNt32Io.c

#
#Rules to clean the build up, it just deletes the output directory and everything under it
#
clean:
 - rd /S /Q $(OUTPUT_DIR)
