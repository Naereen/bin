#!/bin/sh

cd '/home/lilian/publis/MTG-Forge-AI-with-Gemini/forge.git/forge-installer/target/forge-installer-2.0.07-SNAPSHOT/'

java -Xmx4096m -Dio.netty.tryReflectionSetAccessible=true -Dfile.encoding=UTF-8 -jar forge-gui-desktop-2.0.07-SNAPSHOT-jar-with-dependencies.jar "$@"
