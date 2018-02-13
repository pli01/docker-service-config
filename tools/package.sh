#!/bin/bash

pwd
tar --exclude .git -zcvf $(basename $(pwd)).tar.gz .
