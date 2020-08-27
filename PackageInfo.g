SetPackageInfo( rec(
    PackageName := "gis",
    Subtitle := "Generalized Interval Systems",
    Version := "0.0.3",
    Date := "21/08/2020",
    License := "MIT",
    PackageWWWHome := Concatenation( "https://github.com/yurrriq/",
                                     LowercaseString( ~.PackageName ) ),
    SourceRepository := rec(
        Type := "git",
        URL := ~.PackageWWWHome,
    ),
    IssueTrackerURL := Concatenation( ~.SourceRepository.URL, "/issues" ),
    SupportEmail := "eric@ericb.me",

    ArchiveURL := Concatenation( ~.SourceRepository.URL,
                                 "/releases/download/v", ~.Version,
                                 "/", ~.PackageName, "-", ~.Version ),
    ArchiveFormats := ".tar.gz",

    Persons := [
        rec(
            LastName     := "Bailey",
            FirstNames   := "Eric",
            IsAuthor     := true,
            IsMaintainer := true,
            Email        := ~.SupportEmail,
            WWWHome      := "https://github.com/yurrriq",
            Place        := "Minneapolis",
        ),
    ],

    Status := "other",

    README_URL := Concatenation( ~.PackageWWWHome, "/README.md" ),
    PackageInfoURL := Concatenation( ~.PackageWWWHome, "/PackageInfo.g" ),

    AbstractHTML :=
    "The <span class=\"pkgname\">GIS</span> package is\
     a <span class=\"pkgname=\">GAP<\span> implementation of David Lewin's\
     Generalized Interval Systems.",
    PackageDoc := rec(
        BookName := ~.PackageName,
        ArchiveURLSubset := ["docs"],
        HTMLStart := "docs/chap0.html",
        PDFFile := "docs/manual.pdf",
        SixFile := "docs/manual.six",
        LongTitle := ~.Subtitle,
    ),

    Dependencies := rec(
        GAP := "4.12",
        NeededOtherPackages := [], # TODO: [["GAPDoc", "1.5"]]
        SuggestedOtherPackages := [],
        ExternalConditions := [],
    ),

    AvailabilityTest := ReturnTrue, # FIXME
    TestFile := "tst/testall.g",

    Autoload := false,

    Keywords := ["GIS", "music theory", "David Lewin"],

    # BannerString := "",

    # AutoDoc := rec(),
));
