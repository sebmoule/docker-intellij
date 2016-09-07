#!/usr/bin/env bash

function delayedPluginInstall {
    sudo mkdir -p /home/developer/.IdeaIC2016.2/config/plugins
    sudo mkdir -p /home/developer/.IdeaIC2016.2/config/options
    sudo chown developer:developer -R /home/developer/.IdeaIC2016.2

    cd /home/developer/.IdeaIC2016.2/config/plugins/

    echo 'Installing Go plugin'
    wget https://plugins.jetbrains.com/files/5047/27278/Go-0.12.1724.zip -O go.zip -q && unzip -q go.zip && rm go.zip

    echo 'Installing Markdown support plugin'
    wget https://plugins.jetbrains.com/files/7793/25156/markdown-2016.1.20160405.zip -O markdown.zip -q && unzip -q markdown.zip && rm markdown.zip

    # Adding the predefined preferences to IDEA
    cp /home/developer/.jdk.table.xml /home/developer/.IdeaIC2016.2/config/options/jdk.table.xml
}



if [ "$1" = "intellij" ]; then
    echo "Starting with intelli : $1, exec $@"
    if [ ! -d /home/developer/.IdeaIC2016.2/config/plugins/Go ]; then
	# We are running with a non-Docker contained volume for IntelliJ prefs so we need to setup the plugin again
	delayedPluginInstall
    fi
    
    if [ -d /home/developer/.IdeaIC2016.2 ]; then
	# Ensure proper permissions
	sudo chown developer:developer -R /home/developer/.IdeaIC2016.2
    fi
    
    exec /opt/intellij/bin/idea.sh
    
else
    echo "Starting you own command : $1, exec $@"
    exec $@
fi