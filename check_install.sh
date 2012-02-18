#!/bin/sh
# tcsh, bash, sh, csh
# Central script that helps facilitate installing various packages ontop of the debian's APT-GET try to abstract to all linux distros
# Read in from the command line, creates an array and stores it into $packages
is_installed() {
    #check if a module is installed
    if [ -z "$1" ]
    then
        echo "Pass in the package name to see if it is installed."
    else
        # how to perform the check, currently only supports DEBIAN APT-CACHE, instead try utilizing litmus tests
        output=$(apt-cache policy $1) #Store output into a variable
        if [[ $output =~ (.*)(Installed: \(none\))(.*) ]] #Regular expression check
	        then
	        return 0
	    elif [[ -z "$output" ]]
	        then 
	        return 2
	    else
	        return 1
	    fi
    fi
}

# using -src notation for non ubuntu repository and download entire source code from original
for pkg in "${packages[@]}"
do
    is_installed $pkg
    output=$?
    if [ $output -eq 1 ]
	    then
	    echo "$pkg is installed"
    elif [ $output -eq 2 ]
	    then
	    sudo ./$pkg.sh
    else
        sudo apt-get -y install $pkg
    fi
done