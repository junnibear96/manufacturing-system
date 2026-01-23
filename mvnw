#!/bin/sh
# ----------------------------------------------------------------------------
# Maven Wrapper startup script, for POSIX.
# ----------------------------------------------------------------------------

BASEDIR=$(cd "$(dirname "$0")"; pwd -P)
WRAPPER_JAR="$BASEDIR/.mvn/wrapper/maven-wrapper.jar"
WRAPPER_PROPERTIES="$BASEDIR/.mvn/wrapper/maven-wrapper.properties"

if [ ! -f "$WRAPPER_JAR" ]; then
  echo "Maven Wrapper jar not found, downloading..."
  WRAPPER_URL=$(grep -E '^wrapperUrl=' "$WRAPPER_PROPERTIES" 2>/dev/null | head -n 1 | sed 's/wrapperUrl=//')
  if [ -z "$WRAPPER_URL" ]; then
    WRAPPER_URL="https://repo.maven.apache.org/maven2/org/apache/maven/wrapper/maven-wrapper/3.2.0/maven-wrapper-3.2.0.jar"
  fi

  mkdir -p "$(dirname "$WRAPPER_JAR")" || exit 1
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$WRAPPER_URL" -o "$WRAPPER_JAR" || exit 1
  elif command -v wget >/dev/null 2>&1; then
    wget -q "$WRAPPER_URL" -O "$WRAPPER_JAR" || exit 1
  else
    echo "ERROR: curl or wget is required to download Maven Wrapper."
    exit 1
  fi
fi

exec java ${MAVEN_OPTS} -classpath "$WRAPPER_JAR" "-Dmaven.multiModuleProjectDirectory=$BASEDIR" org.apache.maven.wrapper.MavenWrapperMain -Dmaven.wrapper.properties="$WRAPPER_PROPERTIES" "$@"
