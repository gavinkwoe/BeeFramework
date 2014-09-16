//
//   ______    ______    ______
//  /\  __ \  /\  ___\  /\  ___\
//  \ \  __<  \ \  __\_ \ \  __\_
//   \ \_____\ \ \_____\ \ \_____\
//    \/_____/  \/_____/  \/_____/
//
//
//  Copyright (c) 2014-2015, Geek Zoo Studio
//  http://www.bee-framework.com
//
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation
//  the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.
//
//  Created by QFish used flex & bison.

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "CSSParser.h"

/* A Bison parser, made by GNU Bison 2.3.  */

/* Skeleton interface for Bison's Yacc-like parsers in C

   Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor,
   Boston, MA 02110-1301, USA.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     TOKEN_EOF = 0,
     LOWEST_PREC = 258,
     UNIMPORTANT_TOK = 259,
     WHITESPACE = 260,
     SGML_CD = 261,
     INCLUDES = 262,
     DASHMATCH = 263,
     BEGINSWITH = 264,
     ENDSWITH = 265,
     CONTAINS = 266,
     STRING = 267,
     IDENT = 268,
     NTH = 269,
     HEX = 270,
     IDSEL = 271,
     IMPORT_SYM = 272,
     MEDIA_SYM = 273,
     FONT_FACE_SYM = 274,
     CHARSET_SYM = 275,
     ATKEYWORD = 276,
     IMPORTANT_SYM = 277,
     MEDIA_ONLY = 278,
     MEDIA_NOT = 279,
     MEDIA_AND = 280,
     CSSLENGTH = 281,
     DIMEN = 282,
     INVALIDDIMEN = 283,
     PERCENTAGE = 284,
     FLOATTOKEN = 285,
     INTEGER = 286,
     URII = 287,
     CSSFUNCTION = 288,
     ANYFUNCTION = 289,
     NOTFUNCTION = 290,
     CALCFUNCTION = 291,
     MINFUNCTION = 292,
     MAXFUNCTION = 293,
     UNICODERANGE = 294
   };
#endif
/* Tokens.  */
#define TOKEN_EOF 0
#define LOWEST_PREC 258
#define UNIMPORTANT_TOK 259
#define WHITESPACE 260
#define SGML_CD 261
#define INCLUDES 262
#define DASHMATCH 263
#define BEGINSWITH 264
#define ENDSWITH 265
#define CONTAINS 266
#define STRING 267
#define IDENT 268
#define NTH 269
#define HEX 270
#define IDSEL 271
#define IMPORT_SYM 272
#define MEDIA_SYM 273
#define FONT_FACE_SYM 274
#define CHARSET_SYM 275
#define ATKEYWORD 276
#define IMPORTANT_SYM 277
#define MEDIA_ONLY 278
#define MEDIA_NOT 279
#define MEDIA_AND 280
#define CSSLENGTH 281
#define DIMEN 282
#define INVALIDDIMEN 283
#define PERCENTAGE 284
#define FLOATTOKEN 285
#define INTEGER 286
#define URII 287
#define CSSFUNCTION 288
#define ANYFUNCTION 289
#define NOTFUNCTION 290
#define CALCFUNCTION 291
#define MINFUNCTION 292
#define MAXFUNCTION 293
#define UNICODERANGE 294




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE

{
    bool                 boolean;
    char                 character;
    int                  integer;
    double               number;
    float                val;

    NSNumber           * nsnumber;
    NSString           * nsstring;
    NSString           * string;
    CSSRule            * rule;
    CSSRuleList        * ruleList;
    CSSSelector        * selector;
    NSMutableArray     * selectorList;
    int                  marginBox;
    int                  relation;
    CSSMediaList       * mediaList;
    CSSMediaQuery      * mediaQuery;
    NSObject           * mediaQueryRestrictor;
    CSSMediaQueryExp   * mediaQueryExp;
    NSString           * value;
    NSString           * valueList;
    NSMutableArray     * mediaQueryExpList;
}
/* Line 1529 of yacc.c.  */

	YYSTYPE;
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif



/* * * * * * * * * * * 
      CSSPrefix
 * * * * * * * * * * */

@class CSSParser;

#define YYDEBUG         0
#define YYERROR_VERBOSE YYDEBUG

#if     YYDEBUG
#define ECHO printf("%d(%s)\n", cssToken, yytext);
#else
#define ECHO
#endif

#define CSS_YYLEX_ACITON [parser csslex:yylval]
#define YY_DECL int yylex(YYSTYPE * yylval, CSSParser * parser)

extern FILE *       yyin;
extern size_t       yyleng;
extern char *       yytext;
extern void         yy_create_input(const char* buffer);
extern void         yy_delete_input();
extern int          yyparse(CSSParser *parser);
int                 cssToken;

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
