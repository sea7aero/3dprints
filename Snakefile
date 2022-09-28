import collections
import csv
import re

from snakemake.logging import logger

projects = {path.parent.name for path in Path('scadfiles').glob("*/*.scad")}

logger.info(f"Projects: {projects}")
                    
rule all:
    input: expand("scadfiles/{project}/{project}.zip", project=projects)

def scad_derivatives(wildcards):
    project = wildcards.project
    files, = glob_wildcards(f"scadfiles/{project}/{{file}}.scad")
    return expand(f"scadfiles/{project}/{{file}}.{{extension}}", file=files, extension=['stl', 'png'])

rule zip:
    input: scad_derivatives
    output: "scadfiles/{project}/{project}.zip"
    shell: "zip {output} {input}"

include_regex = re.compile("^(include|use) <(.*)>;?$")

def search_scad_dependencies(scad_path):
    logger.debug(f"Search {scad_path} for dependencies")

    if not scad_path.exists():
        return

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

rule export_stl:
    """Runs OpenSCAD to generate STL for every SCAD file in a project directory."""
    input:
        "scad",
        scad_file = "{project}/{file}.scad",
        dependencies = get_scad_dependencies
    output:
        stl="{project}/{file}.stl",
        png="{project}/{file}.png",
    wildcard_constraints:
        extension="(stl|png)"
    shell: """
        echo "Generating {output}"
        scad {input.scad_file} -o {output.stl} -o {output.png}
        echo "Generated {output}"
    """

def read_csv(filename):
    with open(filename, 'r') as input_file:
        reader = csv.DictReader(input_file)
        return {
            "headers": reader.fieldnames,
            "rows": list(row for row in reader)
        }

rule data_file:
    """Converts CSV data files to OpenSCAD tables."""
    input: csv="scadfiles/{filename}.csv"
    output: "scadfiles/{filename}.scad"
    script: "scripts/csv_to_scad.py"