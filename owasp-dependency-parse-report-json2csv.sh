#!/bin/bash

function parse {
    jq -c '. |
        .dependencies[] as $d |
        select($d.vulnerabilities != null) |
        $d.vulnerabilities[] as $v |
        [ .projectInfo.name, $d.fileName, $v.severity, $v.name, $v.cvssv2.score, $v.cvssv3.baseScore]' \
        "$1"
}

parse "$1" | sed -e 's/^\[//' -e 's/\]$//' -e 's/-\([0-9].*\).jar/","\1/' -e 's/.RELEASE//'


