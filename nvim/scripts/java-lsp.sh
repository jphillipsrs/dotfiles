#!/bin/sh

# Path to the jdtls launcher JAR file
JAR_PATH="$HOME/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar"

# Use the manually set JAVA_HOME
JAVA_HOME=${JAVA_HOME:-/opt/homebrew/opt/openjdk/libexec/openjdk.jdk/Contents/Home}

# Workspace folder
WORKSPACE="$HOME/.local/share/eclipse/$1"

exec "$JAVA_HOME/bin/java" \
    -Declipse.application=org.eclipse.jdt.ls.core.id1 \
    -Dosgi.bundles.defaultStartLevel=4 \
    -Declipse.product=org.eclipse.jdt.ls.core.product \
    -Dlog.protocol=true \
    -Dlog.level=ALL \
    -Xmx1G \
    -jar $(echo $JAR_PATH) \
    -configuration "$HOME/.local/share/nvim/mason/packages/jdtls/config_mac" \
    -data "$WORKSPACE"

