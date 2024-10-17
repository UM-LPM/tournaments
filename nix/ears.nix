{ lib, buildGradleApplication }:

{
  ...
}@inputs:
buildGradleApplication (inputs // {
  buildTask = ":app:installDist";
  installLocation = "app/build/install/*/";

  meta = with lib; {
    description = "EARS";
  };
})
