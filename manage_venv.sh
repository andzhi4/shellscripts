#!/bin/bash

# Quickly create a new venv an activate it
# Params: $1: venv name, 
#         $2: python version to use ()
function new_venv() {
    if [ -z "$VENV_BASE" ]; then
		echo "Error: VENV_BASE environment variable is not set."
		return 1
	fi
    if [ -z "$1" ]; then
        echo "Speify venv name, please"
 	else
        	venv_path="$VENV_BASE/$1";
        	virtualenv "$venv_path" -p"$2";
        	source $venv_path'/bin/activate';
	fi
}

# Remove a venv by name
function del_venv() {
    if [ -z "$VENV_BASE" ]; then
		echo "Error: VENV_BASE environment variable is not set."
		return 1
	fi
    if [ -z "$1" ]; then
        echo "Speify venv name, please"
 	else
        if [ ! -z "$VIRTUAL_ENV" ]; then
            echo "Deactivating venv..."
            deactivate
        fi
        rm -r "$VENV_BASE/$1"
        echo "Venv was removed. Available venvs:"
        ls -lh $VENV_BASE
    fi
}