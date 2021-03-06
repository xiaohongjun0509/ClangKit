/*******************************************************************************
 * Copyright (c) 2012, Jean-David Gadina - www.xs-labs.com
 * All rights reserved.
 * 
 * Boost Software License - Version 1.0 - August 17th, 2003
 * 
 * Permission is hereby granted, free of charge, to any person or organization
 * obtaining a copy of the software and accompanying documentation covered by
 * this license (the "Software") to use, reproduce, display, distribute,
 * execute, and transmit the Software, and to prepare derivative works of the
 * Software, and to permit third-parties to whom the Software is furnished to
 * do so, all subject to the following:
 * 
 * The copyright notices in the Software and this entire statement, including
 * the above license grant, this restriction and the following disclaimer,
 * must be included in all copies of the Software, in whole or in part, and
 * all derivative works of the Software, unless such copies or derivative
 * works are solely in the form of machine-executable object code generated by
 * a source language processor.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE, TITLE AND NON-INFRINGEMENT. IN NO EVENT
 * SHALL THE COPYRIGHT HOLDERS OR ANYONE DISTRIBUTING THE SOFTWARE BE LIABLE
 * FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT OR OTHERWISE,
 * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 ******************************************************************************/
 
/* $Id$ */

#import "CKSourceLocation.h"

@implementation CKSourceLocation

@synthesize ptrData1 = _ptrData1;
@synthesize ptrData2 = _ptrData2;
@synthesize intData  = _intData;
@synthesize fileName = _fileName;

+ ( id )sourceLocationWithPointerData1: ( const void * )ptrData1 pointerData2: ( const void * )ptrData2 intData: ( unsigned int )intData
{
    return [ [ [ self alloc ] initWithPointerData1: ptrData1 pointerData2: ptrData2 intData: intData ] autorelease ];
}

- ( id )initWithPointerData1: ( const void * )ptrData1 pointerData2: ( const void * )ptrData2 intData: ( unsigned int )intData
{
    CXSourceLocation location;
    CXFile           file;
    CXString         fileName;
    unsigned int     line;
    unsigned int     column;
    unsigned int     offset;
    
    if( ( self = [ self init ] ) )
    {
        _ptrData1 = ptrData1;
        _ptrData2 = ptrData2;
        _intData  = intData;
        
        location.ptr_data[ 0 ] = ptrData1;
        location.ptr_data[ 1 ] = ptrData2;
        location.int_data      = intData;
        
        clang_getExpansionLocation( location, &file, &line, &column, &offset );
        
        fileName = clang_getFileName( file );
        
        if( clang_getCString( fileName ) != NULL )
        {
            _fileName = [ [ NSString alloc ] initWithCString: clang_getCString( fileName ) encoding: NSUTF8StringEncoding ];
        }
    }
    
    return self;
}

- ( void )dealloc
{
    [ _fileName release ];
    
    [ super dealloc ];
}

@end
