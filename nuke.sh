#!/bin/bash

if [ ! $(which fabric) ]; then
    echo "Error: Requires fabric cli tools"
    
    
    while
        echo 'Install fabric cli tools (Y/n)?'
        finstall = $(read | awk '{print tolower($0)}')
        [ $(test $finstall != "y") -a $(test $finstall != "n") ]
    do
        true
    done

    if [ $finstall = "y" ]; then
        if [ ! $(which deno) ]; then
            echo "Error: Fabric cli tools require deno"
            
            while
                echo 'Install deno (Y/n)?'
                dinstall = $(read | awk '{print tolower($0)}')
                [ $(test $dinstall != "y") -a $(test $dinstall != "n") ]
            do
                true
            done

            if [ $dinstall = "y" ]; then
                echo "Downloading and running deno install script..."
                curl -fsSL https://deno.land/install.sh | sh
            else
                echo "Installation canceled."
                exit 1
            fi
        fi
        
        echo "Installing fabric cli tools..."
        deno install -A -g -n fabric https://fabricmc.net/cli  
    else
        echo "Execution canceled."
        exit 1
    fi
fi

echo "Upgrading fabric cli tools (if necissary)..."
fabric upgrade

echo "Reconfiguring gradle from template..."

tmp=$(mktemp -d)
wd=$(pwd)
cd $tmp
echo "Please select your target version"
fabric init -n tmp -m tmp -p tmp -o splitSources
if [ $? != 0 ]
then
    echo "Something went wrong."
    echo "Upon resolution of this issue, please delete: $tmp"
    exit 1
fi

cd $wd

rm -r gradle
rm gradlew.bat
rm gradlew
rm settings.gradle
rm build.gradle

mv "$tmp/gradle" .
mv "$tmp/gradlew.bat" .
mv "$tmp/gradlew" .
chmod u+x ./gradlew
mv "$tmp/settings.gradle" .
mv "$tmp/build.gradle" .

rm -r ./.gradle 2> /dev/null
rm -r ./build 2> /dev/null

echo "Cleaning up..."
rm -r "$tmp"

echo "Done!"
exit

