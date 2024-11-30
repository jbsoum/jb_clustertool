#!/bin/bash

# cmd ./chart-dl.sh "chart" "train" "version" "local-name"

trains=(
    "premium"
    "stable"
    "incubator"
    "system"
)

train="premium"

while [[ $2 ]]:
do
    case "$1" in
      -f | --file)
	  file="$2"   # You may want to check validity of $2
	  shift 2
	  ;;
      -h | --help)
	  display_help  # Call your function
	  # no shifting needed here, we're done.
	  exit 0
	  ;;
      -u | --user)
	  username="$2" # You may want to check validity of $2
	  shift 2
	  ;;
      -v | --verbose)
          #  It's better to assign a string, than a number like "verbose=1"
	  #  because if you're debugging the script with "bash -x" code like this:
	  #
	  #    if [ "$verbose" ] ...
	  #
	  #  You will see:
	  #
	  #    if [ "verbose" ] ...
	  #
          #  Instead of cryptic
	  #
	  #    if [ "1" ] ...
	  #
	  verbose="verbose"
	  shift
	  ;;
      --) # End of all options
	  shift
	  break;
      -*)
	  echo "Error: Unknown option: $1" >&2
	  exit 1
	  ;;
      *)  # No more options
	  break
	  ;;
    esac
done

cp chart_templates/helm-release-template.yaml clusters/main/kubernetes/apps/__chart/app/helm-release.yaml
cp chart_templates/namespace-template.yaml clusters/main/kubernetes/apps/__chart/app/namespace.yaml
cp chart_templates/kustomization-template.yaml clusters/main/kubernetes/apps/__chart/app/kustomization.yaml

wget https://raw.githubusercontent.com/truecharts/public/refs/heads/master/charts/stable/__chart/values.yaml -O | sed 's/^/  /' ->> clusters/main/kubernetes/apps/__chart/app/helm-release.yaml
code clusters/main/kubernetes/apps/__chart/app/helm-release.yaml