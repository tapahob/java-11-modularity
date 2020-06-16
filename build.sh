#!/bin/bash
clear

echo -ne "Removing the out dir .. "
rm -rf out
echo "[OK]"
echo -ne "Compiling .. "
mkdir -p out/helloworld
javac -d out/helloworld src/helloworld/com/modularity/helloworld/HelloWorld.java src/helloworld/module-info.java
echo "[OK]"
echo -ne "Packaging .. "
rm -rf mods
mkdir -p mods
jar -cfe mods/helloworld.jar com.modularity.helloworld.HelloWorld -C out/helloworld .
if [[ $? != 0 ]]; then
    echo command failed
    else
    echo -e "[OK]\n"
fi

echo -ne "Running .. "
java --module-path mods --module helloworld
if [[ $? != 0 ]]; then
    echo command failed
    else
    echo -e "[OK]\n"
fi

echo -ne "\nLinking .. "
rm -rf helloworld-image
jlink --module-path mods --add-modules helloworld --output helloworld-image --strip-debug --launcher helloworld=helloworld
if [[ $? != 0 ]]; then
    echo command failed
    else
    echo -e "[OK]\n"
fi

echo -ne "\nModules:\n"
helloworld-image/bin/java --list-modules