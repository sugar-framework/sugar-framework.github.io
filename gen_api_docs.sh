#!/bin/bash

for project in sugar plugs templates
do
    cd ../$project
    rm -rf _build
    MIX_ENV=docs mix do deps.get, deps.compile, docs
    rm -rf ../sugar-framework.github.io/docs/api/$project/*
    mv docs/* ../sugar-framework.github.io/docs/api/$project
    cd ../sugar-framework.github.io
done
