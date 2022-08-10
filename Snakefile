from pathlib import Path
from snakemake.logging import logger
import re

projects, files = glob_wildcards("{project}/{file}.scad")
zip_extensions = ['stl', 'png']

include_regex = re.compile("^(include|use) <(.*)>;?$")

def search_scad_dependencies(scad_path):
    logger.debug(f"Search {scad_path} for dependencies")

    with open(scad_path, 'r') as scad_file:
        for line_number, line in enumerate(scad_file):
            match = include_regex.match(line)
            if match:
                filename = match.group(2)
                logger.debug(f"  Found {filename} at line {line_number}")
                if 'mcad' in filename:
                    continue

                dependency = scad_path.parent / filename
                yield dependency
                yield from search_scad_dependencies(dependency)

def get_scad_dependencies(wildcards):
    scad_path = Path(f"{wildcards.project}/{wildcards.file}.scad")
    return search_scad_dependencies(scad_path)
                    
rule all:
    input: expand("{project}/{project}.zip", project=projects)

rule zip:
    input: expand("{project}/{file}.{extension}", project=projects, file=files, extension=zip_extensions)
    output: "{project}/{project}.zip"
    shell: "zip {output} {input}"

rule scad:
    input:
        scad_file = "{project}/{file}.scad",
        dependencies = get_scad_dependencies
    output: "{project}/{file}.{extension}"
    wildcard_constraints:
        extension="(stl|png)"
    shell: "scad -o {output} {input.scad_file}"

