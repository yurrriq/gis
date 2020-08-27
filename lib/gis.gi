#! @Chapter GIS

#! @Section Constructing a GIS

InstallMethod( MusicalSpace,
    [IsList, IsObject],
    function( S, ref )
        local zero, space;
        zero := Position( S, ref) - 1;
        space := rec( Label := { s } -> Position( S, s ) - 1 - zero );
        Objectify( TYPE_MUSICAL_SPACE, space );
        return space;
    end );

InstallMethod( MusicalSpace,
    [IsAdditiveGroup, IsObject],
    function( S, ref )
        local space;
        space := rec( Label := { s } -> s - ref );
        Objectify( TYPE_MUSICAL_SPACE, space );
        return space;
    end );

InstallMethod( GIS,
    [IsMusicalSpace, IsGroup, IsFunction],
    function( S, IVLS, int )
        local gis, label;
        label := S!.Label;
        gis := rec( S := S, IVLS := IVLS,
                    int := { s, t } -> int( label( s ), label( t ) ) );
        Objectify( TYPE_GIS, gis );
        return gis;
    end );

InstallMethod( PrintObj,
    "for a GIS",
    [IsGIS],
    function( gis )
        Print( "(", gis!.S, ", ", gis!.IVLS, ", ", gis!.int, ")" );
    end );


#! @Section Computing intervals

InstallMethod( GISInt,
    "GIS interval",
    [IsGIS, IsObject, IsObject],
    { gis, s, t } -> gis!.int( s, t ) );


#! @Section Predefined GIS

InstallValue( PitchClasses,
    ["C","C#","D","D#","E","F","F#","G","G#","A","A#","B"] );

InstallValue( PSpace,
    GIS( MusicalSpace( Integers, 0 ), FreeGroup( 1 ),
         { s, t } -> t - s ) );

InstallValue( PCSpace,
    GIS( MusicalSpace( PitchClasses, "C" ), CyclicGroup( IsPermGroup, 12),
         { s, t } -> \mod(t - s, 12) ) );
