#!/bin/sh

# env.sh

# Change the contents of this output to get the environment variables
# of interest. The output must be valid JSON, with strings for both
# keys and values.
export $(cat ../.env | egrep -v "(^#.*|^$)" | xargs)
env