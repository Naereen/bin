#!/bin/bash
echo -e "Synchronizing ~/TODO.rst..."
mv -vf ~/TODO.rst /tmp/ && ln ~/ownCloud/cloud.openmailbox.org/TODO.rst ~/
echo -e "Synchronization for ~/TODO.rst done."
