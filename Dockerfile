
# s2i-springboot
FROM openshift/base-centos7

MAINTAINER Rabbit <380303318@qq.com>

EXPOSE 8080

ENV MAVEN_VERSION=3.5.2 \
    APP_ROOT="/opt/app-root/"

LABEL io.k8s.description="Platform for building and running SpringBoot applications" \
      io.k8s.display-name="SpringBoot Builder" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,springboot" \
      io.openshift.s2i.destination="/opt/s2i/destination"

# Install Maven, Tomcat 8.5.24
RUN INSTALL_PKGS="tar java-1.8.0-openjdk java-1.8.0-openjdk-devel" && \
    yum install -y --enablerepo=centosplus $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum clean all -y && \
    (curl -v http://mirrors.tuna.tsinghua.edu.cn/apache/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | \
    tar -zx -C /usr/local) && \
    ln -sf /usr/local/apache-maven-$MAVEN_VERSION/bin/mvn /usr/local/bin/mvn && \
    mkdir -p $HOME/.m2 && \
    mkdir -p $APP_ROOT && \
    mkdir -p /opt/s2i/destination

# Add s2i customizations
ADD ./contrib/settings.xml $HOME/.m2/

# Copy the S2I scripts from the specific language image to $STI_SCRIPTS_PATH
COPY ./s2i/bin/ $STI_SCRIPTS_PATH

RUN chmod -R a+rw $HOME && \
    chmod -R +x $STI_SCRIPTS_PATH && \
    chmod -R g+rw /opt/s2i/destination

RUN echo "root:root" | chpasswd

USER 1001

CMD $STI_SCRIPTS_PATH/usage
