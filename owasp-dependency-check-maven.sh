#!/bin/bash

function audit_proj {
    local report_dir="${1:-_report}"

    mvn org.owasp:dependency-check-maven:check \
        -DnvdApikey=9b68ecb6-d793-4daf-a415-0634307bc6d9 \
        -DassemblyAnalyzerEnabled=false \
        -DskipTestScope \
        -Dodc.outputDirectory="$report_dir" \
        -Dformats=JSON,HTML \
        -DprettyPrint=true
}

function proj_dirs {
    find -type f -iname 'pom.xml' ! -path '*/bin/*' | xargs dirname
}

proj_dirs | while IFS= read -r proj; do
    report_dir="$(realpath ./_report)/$proj"
    (cd "$proj" && audit_proj "$report_dir")
done

