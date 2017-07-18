#!/bin/bash
find ../../maps | grep \.dmm$ | xargs -l1 -I{} cp {} {}.backup