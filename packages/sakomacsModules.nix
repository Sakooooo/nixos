{
trivialBuild
, lib
}:

trivialBuild {
    pname = "sakomacsModules";
    version = "lol";
    src = ../../../../config/emacs/modules;

    postInstall = ''
    cp -r $src $LISPDIR
    '';

    meta = {
       description = "lol";
       license = lib.licenses.gpl3;
       platforms = lib.platforms.all;
    };

} 
