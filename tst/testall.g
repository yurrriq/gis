LoadPackage( "GIS" );

TestDirectory( DirectoriesPackageLibrary("GIS", "tst"),
               rec( exitGAP := true,
                    testOptions := rec(compareFunction := "uptowhitespace") ) );

FORCE_QUIT_GAP(1);
