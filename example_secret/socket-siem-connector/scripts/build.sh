#!/bin/sh

VERSION=$(grep -o "__version__.*" socketsync/__init__.py | awk '{print $3}' | tr -d "'" | tr -d '\r' | tr -dc '[:alnum:]\.' )
ENABLE_PYPI_BUILD=$1

if [ -z $ENABLE_PYPI_BUILD ]; then
  echo "$0 pypi-prod=enable"
  printf "\tpypi-build: Build and publish a new version of the package to pypi. If disabled will push to test pypi"
  exit
fi

if [ "$ENABLE_PYPI_BUILD" = "pypi-prod=enable" ]; then
  echo "Doing production build of version $VERSION"
  python -m build --wheel --sdist
  twine upload dist/*$VERSION*
else
  echo "Doing test build of version $VERSION"
  python -m build --wheel --sdist \
    && ls dist/*$VERSION*\
    && twine upload --repository testpypi "dist/*$VERSION*"
fi
