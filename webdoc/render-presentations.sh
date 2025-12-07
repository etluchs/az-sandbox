#!/bin/bash
pushd $(dirname "$0")
mkdir -p build
cp src/css/* build
cp src/presentations/*.??g build

for presi in src/presentations/*.adoc; do
  arg=${presi##src/presentations/}
  echo "rendering $presi"

  docker run -u $(id -u) --rm -v `pwd`/src/presentations:/documents/ -v `pwd`/build:/target/ \
              asciidoctor/docker-asciidoctor \
              asciidoctor-revealjs $arg --safe-mode=unsafe -D /target
done
popd