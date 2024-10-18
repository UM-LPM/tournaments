{ lib, buildGradleApplication }:

{
  ...
}@inputs:
buildGradleApplication (inputs // {
  buildTask = ":app:installDist";
  installLocation = "app/build/install/*/";
  dependencyFilter = depSpec:
    !(depSpec.component.name == "ears");

  meta = with lib; {
    description = "EARS";
  };
})
