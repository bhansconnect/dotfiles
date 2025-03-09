#!/bin/bash

cd $HOME/.local/share/chezmoi
jj git init --colocate
jj bookmark track main@origin
