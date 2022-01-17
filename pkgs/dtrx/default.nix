{ lib, python3Packages }:

with python3Packages;
buildPythonApplication rec {
  pname = "dtrx";
  version = "8.2.1";
  src = fetchPypi {
    inherit pname version;
    sha256 = "19k4hy8ljm2cq30mzxp1f41z9bgpnyp0m0xzwv92djypd4jngah8";
  };
  meta = with lib; {
    description =
      "Do The Right Extraction: A tool for taking the hassle out of extracting archives";
    homepage = "https://github.com/dtrx-py/dtrx/";
    license = licenses.gpl3Plus;
  };
}
