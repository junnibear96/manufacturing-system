/*
 * Minimal Maven Wrapper downloader.
 * Based on the Apache Maven Wrapper project (Apache License 2.0).
 */

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Properties;

public class MavenWrapperDownloader {
  private static final String WRAPPER_PROPERTIES_PATH = ".mvn/wrapper/maven-wrapper.properties";
  private static final String WRAPPER_JAR_PATH = ".mvn/wrapper/maven-wrapper.jar";
  private static final String WRAPPER_URL_PROPERTY = "wrapperUrl";
  private static final String DEFAULT_WRAPPER_URL =
      "https://repo.maven.apache.org/maven2/org/apache/maven/wrapper/maven-wrapper/3.2.0/maven-wrapper-3.2.0.jar";

  public static void main(String[] args) throws Exception {
    System.out.println("Downloading Maven Wrapper...");

    String wrapperUrl = DEFAULT_WRAPPER_URL;
    Path propsPath = Path.of(WRAPPER_PROPERTIES_PATH);
    if (Files.exists(propsPath)) {
      Properties p = new Properties();
      try (InputStream in = Files.newInputStream(propsPath)) {
        p.load(in);
      }
      wrapperUrl = p.getProperty(WRAPPER_URL_PROPERTY, wrapperUrl);
    }

    Path jarPath = Path.of(WRAPPER_JAR_PATH);
    Files.createDirectories(jarPath.getParent());
    downloadFile(wrapperUrl, jarPath.toFile());

    System.out.println("Maven Wrapper downloaded: " + jarPath);
  }

  private static void downloadFile(String urlString, File destination) throws IOException {
    URL url = new URL(urlString);
    try (InputStream in = url.openStream(); FileOutputStream out = new FileOutputStream(destination)) {
      byte[] buffer = new byte[8192];
      int read;
      while ((read = in.read(buffer)) != -1) {
        out.write(buffer, 0, read);
      }
    }
  }
}
