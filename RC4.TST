/*
 *
 * rc4.c
 * Thursday, 4/17/1997.
 *
 * The encryption algorithm used in this module was derived from 
 * 'Applied Cryptography 2nd Ed' (c) 1996 by Bruce Schneider
 * and was developed by Ron Rivest for RSA Data Security Inc.
 *
 *
 * To encrypt a small buffer, simply call Crypt
 * To encrypt a stream call InitSBox and then call CryptStream as many
 * times as needed.
 *
 * Note that the algorithm is symmetric - ie decryption ð decryption
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <gnutype.h>

static UCHAR cI, cJ, s[256];

void InitSBox (PSZ pszKey)
   {
   PSZ   psz = pszKey;
   UCHAR j, tmp, k[256];
   int   i;

   for (cI=cJ=i=0; i<256; i++)
      {
      s[i] =i;
      if (!*psz) psz = pszKey;
      k[i] = *psz++;
      }
   for (j=i=0; i<256; i++)
      {
      j   = (j + s[i] + k[i]);
      tmp = s[i], s[i] = s[j], s[j] = tmp;
      }
   }

PSZ CryptStream (PSZ pszOut, PSZ pszIn, int iSrcLen)
   {
   int   i;
   UCHAR tmp, t;

   for (i=0; i< iSrcLen; i++)
      {
      cI += 1;
      cJ += s[cI];
      tmp = s[cI], s[cI] = s[cJ], s[cJ] = tmp;
      t   = s[cI] + s[cJ];
      *pszOut++ = *pszIn++ ^ s[t];
      }
   return pszOut;
   }

PSZ Crypt (PSZ pszOut, PSZ pszIn, int iSrcLen, PSZ pszKey)
   {
   InitSBox (pszKey);
   return CryptStream (pszOut, pszIn, iSrcLen);
   }

#define BUFFLEN 16

int main (int argc, char *argv[])
   {
   CHAR szBuff1 [BUFFLEN], szBuff2 [BUFFLEN];
   PSZ  pszKey;
   FILE *fpIn, *fpOut;
   INT  iRead;

   if (argc < 2)
      return printf ("Usage: RC4 keystring");
   pszKey = argv[1];

   /*--- create encrypted file ---*/
   fpIn  = fopen ("rc4.c", "rb");
   fpOut = fopen ("rc4.e", "wb");
   InitSBox (pszKey);
   while (iRead = fread (szBuff1, 1, BUFFLEN, fpIn))
      {
      CryptStream (szBuff2, szBuff1, iRead);
      fwrite (szBuff2, 1, iRead, fpOut);
      }
   fclose (fpIn);
   fclose (fpOut);

   /*--- create decrypted file ---*/
   fpIn  = fopen ("rc4.e",   "rb");
   fpOut = fopen ("rc4.tst", "wb");
   InitSBox (pszKey);
   while (iRead = fread (szBuff1, 1, BUFFLEN, fpIn))
      {
      CryptStream (szBuff2, szBuff1, iRead);
      fwrite (szBuff2, 1, iRead, fpOut);
      }
   fclose (fpIn);
   fclose (fpOut);
   printf ("Done.");
   return 0;
   }

