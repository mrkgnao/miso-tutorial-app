#!/usr/bin/env sh
cabal --project-file=ghcjs-cabal.project v2-build client
cp $(find ./dist-newstyle/ -name all.js) server/static/
