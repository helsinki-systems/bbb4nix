# this file must still be generated manually.
{
  "repos" = {
    "nix-public" = "";
    "nix-typesafe-ivy-releases" = "[organisation]/[module]/(scala_[scalaVersion]/)(sbt_[sbtVersion]/)[revision]/[type]s/[artifact](-[classifier]).[ext]";
  };
  "artifacts" = {
    # dependencies so sbt can build the sbt-compiler-interface (http://www.scala-sbt.org/0.13/docs/Compiler-Interface.html)
    "nix-public/org/scala-lang/jline/2.10.6/jline-2.10.6.pom" = {
      url = "https://repo1.maven.org/maven2/org/scala-lang/jline/2.10.6/jline-2.10.6.pom";
      sha256 = "16mg4b2c1m6gcq901wy6f6jpy8spw2yh909gi826xykq89ja94dg";
    };
    "nix-public/org/scala-lang/jline/2.10.6/jline-2.10.6.jar" = {
      url = "https://repo1.maven.org/maven2/org/scala-lang/jline/2.10.6/jline-2.10.6.jar";
      sha256 = "1cfk6whncx2g87grwdfmz6f76bn807saqik91iwcfv099b1jngw1";
    };
    "nix-public/org/fusesource/jansi/jansi/1.4/jansi-1.4.pom" = {
      url = "https://repo1.maven.org/maven2/org/fusesource/jansi/jansi/1.4/jansi-1.4.pom";
      sha256 = "0rgprkbg4ljarf0x79snk2h1b0974glhl2fw1bxkxbw8k3ifda1s";
    };
    "nix-public/org/fusesource/jansi/jansi/1.4/jansi-1.4.jar" = {
      url = "https://repo1.maven.org/maven2/org/fusesource/jansi/jansi/1.4/jansi-1.4.jar";
      sha256 = "183ms545msn02fl0181rwbcifc8qy82rz4l6dglnhv9la8a1bnc2";
    };
    "nix-public/org/apache/commons/commons-pool2/2.8.0/commons-pool2-2.8.0.pom" = {
      url = "https://repo1.maven.org/maven2/org/apache/commons/commons-pool2/2.8.0/commons-pool2-2.8.0.pom";
      sha256 = "sha256-gXHd2q93kXrnNlXuyGTtjkOC97m0kGgkfr3PxrQknTQ=";
    };
    "nix-public/org/apache/commons/commons-pool2/2.8.0/commons-pool2-2.8.0.jar" = {
      url = "https://repo1.maven.org/maven2/org/apache/commons/commons-pool2/2.8.0/commons-pool2-2.8.0.jar";
      sha256 = "sha256-Xvqfu1SlixoSIFpfrFZfaYKr/rD/Rb28MYdI71/To/8=";
    };
    "nix-sonatype-releases/org/apache/apache/21/apache-21.pom" = {
      url = "https://oss.sonatype.org/content/repositories/releases/org/apache/apache/21/apache-21.pom";
      sha256 = "sha256-rxDBCNoBTxfK+se1KytLWjocGCZfoq+XoyXZFDU3s4A=";
    };
  };
}
