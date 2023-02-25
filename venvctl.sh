#!/bin/noexecute

# Description:
# A set of functions to manipulate Python virtual environments.
#
# Prerequisites:
# The script requires the 'virtualenv' Python package to be installed.
# To install, run: python3 -m pip install virtualenv
#
# Usage:
# - Set the base path for virtual environments by setting the VENV_BASE
#   environment variable. If not set, VENV_BASE is initialized to $HOME/venvs.
# - Call the functions defined in this script to create, activate, or delete
#   Python virtual environments.
#
# Example usage:
#   $ export VENV_BASE=/path/to/venvs
#   $ source python_venv.sh
#   $ new_venv myenv 3.10
#   $ deactivate
#   $ activate_venv myenv
#   $ del_venv myenv
#
# Functions:
# - new_venv [name] [version]: Creates a new Python virtual environment with the
#   specified name and pyhton version. Activates it, installe latest pip.
# - activate_venv [name]: Activates an existing Python virtual environment.
# - del_venv [name]: Deletes an existing Python virtual environment, 
#   deactivating it first
# - ls_venvs: Shows available virtual environments
# - show_venv_base: Displays current VENV_BASE location
# - set_venv_base: Set the %VENV_BASE environmant variable to the specified value
#   
#
# License:
# MIT License
#
# Author: Viacheslav Andzhich
# Version: 0.1.1
# Copyright (c) 2023

# MIT License
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.


if [ -z "$VENV_BASE" ]; then
    export VENV_BASE=$HOME'/venvs'
fi

function new_venv() {
    if [ -z "$VENV_BASE" ]; then
		echo "Error: VENV_BASE environment variable is not set."
		return 1
	fi
    if [ -z "$1" ]; then
        echo "Speify venv name, please"
		return 1
	fi

    if [ ! -z "$VIRTUAL_ENV" ]; then
            echo ">>> Deactivating current venv..."
            deactivate
    fi

	venv_path="$VENV_BASE/$1";
	pyver=${2:-3.11}
    echo -e "\033[0;33m\033[1m>>> creating venv $1 using python $pyver...\033[0m"
	virtualenv "$venv_path" -p $pyver;
	source $venv_path'/bin/activate';
	python3 -m pip install --upgrade pip

	return 0
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
            echo ">>> Deactivating venv..."
            deactivate
        fi
        rm -r "$VENV_BASE/$1"
        echo -e "\033[0;33m\033[1m>>> venv $1 was removed.\033[0m"
		echo "Available venvs:"
        list_venvs
    fi
}

function activate_venv(){
    if [ -z "$VENV_BASE" ]; then
                echo "Error: VENV_BASE environment variable is not set."
                return 1
    fi
    if [ -z "$1" ]; then
        echo "Speify venv name, please"
    else
    	source "$VENV_BASE/$1/bin/activate"
    fi

}

function ls_venvs(){
    ls -1h $VENV_BASE | sed 's/^/ - /'
}

function show_venv_base(){
    echo -e "\033[0;33m\033[1m>>> Current venv base:\033[0m $VENV_BASE"
}

function set_venv_base(){
    if [ -z "$1" ]; then
        echo "Speify venv base path, please"
		return 1
	fi
    export VENV_BASE=$1
}