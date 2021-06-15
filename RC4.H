/*
 *
 * rc4.h
 * Friday, 4/18/1997.
 *
 */


PSZ  Crypt (PSZ pszOut, PSZ pszIn, int iSrcLen, PSZ pszKey);

void InitSBox (PSZ pszKey);

PSZ  CryptStream (PSZ pszOut, PSZ pszIn, int iSrcLen);
