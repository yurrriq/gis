#! @Chapter GIS

#! @Section Constructing a GIS

 # FIXME: IsDuplicateFreeList or IsCollection
DeclareCategory("IsMusicalSpace", IsObject);
BindGlobal( "MusicalSpaceFamily",
    NewFamily( "MusicalSpaceFamily", IsMusicalSpace ) );
BindGlobal( "TYPE_MUSICAL_SPACE",
    NewType( MusicalSpaceFamily, IsMusicalSpace ) );

DeclareOperation( "MusicalSpace", [IsList, IsObject]);
DeclareOperation( "MusicalSpace", [IsCollection, IsObject]);


DeclareCategory("IsGIS", IsObject );
BindGlobal( "GISFamily", NewFamily( "GISFamily", IsGIS ) );
BindGlobal( "TYPE_GIS", NewType( GISFamily, IsGIS ) );

# DeclareAttribute( "S", IsObject );
# DeclareAttribute( "IVLS", IsGroup );
# DeclareAttribute( "Int", IsFunction );

# TODO: Flesh out description.
#! @Description
#!  A Generalized Interval System (<M>GIS</M>) is an ordered triple
#!  (<A>S</A>, <A>IVLS</A>, <A>int</A>), where the space <A>S</A> of the
#!  <M>GIS</M> is a set of elements (satisfying <M>IsObject</M>), the set
#!  <A>IVLS</A> of intervals for the <M>GIS</M> is a group in the mathematical
#!  sense (satisfying <M>IsGroup</M>), and <A>int</A> is a function from
#!  <A>S</A> x <A>S</A> into <A>IVLS</A> such that...
#! @Arguments S, IVLS, int
DeclareOperation( "GIS", [IsMusicalSpace, IsGroup, IsFunction] );


#! @Section Computing intervals

#! @Description
#!  <M>\forall s, t \in S,\;int(s, t)</M> where <A>gis</A>
#!  <M> = (S, IVLS, int)</M>
#! @Arguments GIS, s, t
DeclareOperation( "GISInt", [IsGIS, IsObject, IsObject] );


#! @Section Predefined GIS

DeclareGlobalVariable( "PitchClasses", "the twelve pitch classes" );

#! @Description
#!  <M>(\mathbb{Z}, (\mathbb{Z},{+}), int)</M> where
#!  <M>int{:}\mathbb{Z}{\times}\mathbb{Z}{\to}\mathbb{Z}</M> and
#!  <M>int(s,t) = t-s</M>.
DeclareGlobalVariable( "PSpace", "p-space" );

#! @Description
#!  <M>(\mathbb{Z}_{12}, (\mathbb{Z}_{12},{+}), int)</M> where
#!  <M>int{:}\mathbb{Z}_{12}{\times}\mathbb{Z}_{12}{\to}\mathbb{Z}_{12}</M> and
#!  <M>int(s,t) = (t-s)\mod 12</M>.
DeclareGlobalVariable( "PCSpace", "pc-space" );
