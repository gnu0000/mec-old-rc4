/*
 *
 * rc4.c
 * Thursday, 4/17/1997.
 *
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <gnutype.h>

UCHAR iCTR, jCTR;
UCHAR s[256];

void InitSBox (PSZ pszKey)
   {
   int i;
   UCHAR j, tmp;
   UCHAR k[256];
   PSZ psz;

   iCTR=0, jCTR=0;

   for (i=0; i<256; i++)
      s[i]=i;

   psz = pszKey;
   for (i=0; i<256; i++)
      {
      psz++;
      if (!*psz)
         psz = pszKey;
      k[i]= *psz;
      }
   for (j=i=0; i<256; i++)
      {
      j = (j + s[i] + k[i]);
      tmp  = s[i];
      s[i] = s[j];
      s[j] = tmp;
      }
   }


UCHAR GenK (void)
   {
   UCHAR tmp, t;

   iCTR = (iCTR + 1);
   jCTR = (jCTR + s[iCTR]);

   tmp  = s[iCTR];
   s[iCTR] = s[jCTR];
   s[jCTR] = tmp;

   t = (s[iCTR] + s[jCTR]);
   return s[t];
   }


PSZ Crypt (PSZ pszIn, PSZ pszOut, int uLen)
   {
   int i;

   for (i=0; i< uLen; i++)
      {
      *pszOut++ = (*pszIn++ ^ GenK());
      }
   return pszOut;
   }



void PrintStr (PSZ psz, int uLen)
   {
   int i;

   for (i=0; i<uLen; i++)
      printf ("%c", psz[i]);
   printf ("\n");
   }


int main (int argc, char *argv[])
   {
   PSZ  pszSrc, pszKey;
   CHAR szDat1 [256];
   CHAR szDat2 [256];
   INT  uLen;

   pszKey = argv[1];
   pszSrc = argv[2];

   uLen = strlen (pszSrc);

   InitSBox (pszKey);
   Crypt (pszSrc, szDat1, uLen);

   InitSBox (pszKey);
   Crypt (szDat1, szDat2, uLen);

   PrintStr (pszSrc, uLen);
   PrintStr (szDat1, uLen);
   PrintStr (szDat2, uLen);
   
   return 0;
   }

