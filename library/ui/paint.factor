! Copyright (C) 2005 Slava Pestov.
! See http://factor.sf.net/license.txt for BSD license.
IN: gadgets
USING: generic hashtables io kernel lists math matrices
namespaces sdl sequences strings styles ;

SYMBOL: clip

: >sdl-rect ( rectangle -- sdlrect )
    [ shape-x ] keep [ shape-y ] keep [ shape-w ] keep shape-h
    make-rect ;

: set-clip ( rect -- ? )
    #! The top/left corner of the clip rectangle is the location
    #! of the gadget on the screen. The bottom/right is the
    #! intersected clip rectangle. Return f if the clip region
    #! is an empty region.
    surface get swap >sdl-rect SDL_SetClipRect ;

: with-clip ( shape quot -- )
    #! All drawing done inside the quotation is clipped to the
    #! shape's bounds.
    [
        >r screen-bounds clip [ intersect dup ] change set-clip
        [ r> call ] [ r> 2drop ] ifte
    ] with-scope ; inline

GENERIC: draw-gadget* ( gadget -- )

: draw-gadget ( gadget -- )
    dup gadget-visible? [
        dup [
            dup [
                dup draw-gadget*
                gadget-children [ draw-gadget ] each
            ] with-trans
        ] with-clip
    ] [ drop ] ifte ;

: paint-prop* ( gadget key -- value )
    swap gadget-paint ?hash ;

: paint-prop ( gadget key -- value )
    over [
        2dup paint-prop* dup
        [ 2nip ] [ drop >r gadget-parent r> paint-prop ] ifte
    ] [
        2drop f
    ] ifte ;

: set-paint-prop ( gadget value key -- )
    pick gadget-paint ?set-hash swap set-gadget-paint ;

: fg ( gadget -- color )
    dup reverse-video paint-prop
    background foreground ? paint-prop ;

: bg ( gadget -- color )
    dup reverse-video paint-prop [
        foreground
    ] [
        dup rollover paint-prop rollover-bg background ?
    ] ifte paint-prop ;

! Paint properties
SYMBOL: interior
SYMBOL: boundary

GENERIC: draw-interior ( gadget interior -- )
GENERIC: draw-boundary ( gadget boundary -- )

M: f draw-interior 2drop ;
M: f draw-boundary 2drop ;

TUPLE: solid ;

: rect>screen ( shape -- x1 y1 x2 y2 )
    >r x get y get r> dup shape-w swap shape-h
    >r pick + r> pick + ;

M: solid draw-interior
    drop >r surface get r> [ rect>screen ] keep bg rgb boxColor ;

M: solid draw-boundary
    drop >r surface get r> [ rect>screen >r 1 - r> 1 - ] keep
    fg rgb rectangleColor ;

TUPLE: gradient vector from to ;

: gradient-color ( gradient prop -- color )
    over gradient-from 1 pick - v*n
    >r swap gradient-to n*v r> v+ ;

: (gradient-x) ( gradient dim y -- x1 x2 y color )
    dup pick second / >r rot r> gradient-color >r
    >r >r x get r> first x get + r> y get + r> ;

: gradient-x ( gradient dim y -- )
    >r >r >r surface get r> r> r> (gradient-x) rgb hlineColor ;

: vert-gradient ( gradient dim -- )
    dup second [ 3dup gradient-x ] repeat 2drop ;

: (gradient-y) ( gradient dim x -- x y1 y2 color )
    dup pick first / >r rot r> gradient-color
    >r x get + y get rot second y get + r> ;

: gradient-y ( gradient dim x -- )
    >r >r >r surface get r> r> r> (gradient-y) rgb vlineColor ;

: horiz-gradient ( gradient dim -- )
    dup first [ 3dup gradient-y ] repeat 2drop ;

M: gradient draw-interior ( gadget gradient -- )
    swap shape-dim { 1 1 1 } vmax
    over gradient-vector { 1 0 0 } =
    [ horiz-gradient ] [ vert-gradient ] ifte ;

M: gadget draw-gadget* ( gadget -- )
    dup
    dup interior paint-prop* draw-interior
    dup boundary paint-prop* draw-boundary ;

: <plain-gadget> ( -- gadget )
    <gadget> dup << solid f >> interior set-paint-prop ;

: <etched-gadget> ( -- gadget )
    <plain-gadget> dup << solid f >> boundary set-paint-prop ;
