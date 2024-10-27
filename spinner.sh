#!/usr/bin/env bash

set -x

steps=16

infile="${1}"

[[ -e "${infile}" ]] || { printf '%s\n' 'need input file' 1>&2 ; exit 1 ; }

# construct filename for output
infn="$(basename "${infile}")"
outpre="${infn%.*}"
outext="${infn#"${outpre}"}"
[[ "${steps}" -gt 0 ]] || { printf '%s\n' "${steps} is not greater than 0" 1>&2 ; exit 1 ; }

# get stripe width
read -r xfile xfmt size rest <<<$(identify - < "${infile}")
width="${size%x*}"

# I'm kinda lying? but we do want the modulus to work out to 0 (we started with 640 for here)
roll=$((width / steps))
tot=$((steps * roll))
[[ "${tot}" -eq "${width}" ]] || { printf '%s\n' "could not factor ${width} into ${steps} steps" 1>&2 ; exit 1 ; }

# roll the picture using convert
for i in $(seq 1 ${steps}) ; do
  ofile="${outpre}${i}${outext}"
  convert -roll "+$((roll * i))" "${infile}" "${ofile}"
done

# the *last* step should be equivalent to the first step, so move it.
mv "${outpre}${steps}${outext}" "${outpre}0${outext}"
