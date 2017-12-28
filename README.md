
# Creating a S2I SpringBoot builder image  

## Getting started  

#### Creating the application image
The application image combines the builder image with your applications source code, which is served using whatever application is installed via the *Dockerfile*, compiled using the *assemble* script, and run using the *run* script.
The following command will create the application image:
```
s2i build test/test-app s2i-springboot s2i-springboot-app
```

#### Running the application image
Running the application image is as simple as invoking the docker run command:
```
docker run -d -p 8080:8080 s2i-springboot-app
```
The application, which consists of a simple static web page, should now be accessible at  [http://localhost:8080](http://localhost:8080).

#### How to use in a openshift cluster

##### 1. import s2i-springboot image to openshift
```
oc import-image (you repository host)/s2i-springboot:lastest -n openshift --confirm --insecure
```
##### 2. edit image stream ,add annotation tags 
```
oc edit is/springboot-s2i -n openshift
```

```$yaml
tags:
    - annotations:
        description: >-
                  Build and run Springboot applications on CentOS 7. For more information
                  about using this builder image, including OpenShift considerations,
                  see https://github.com/silentwu/s2i-springboot.git.
        iconClass: icon-wildfly
        openshift.io/display-name: SpringBoot
        openshift.io/provider-display-name: 'Rabbit blog, http://blog.xianshiyue.com'
        sampleRepo: 'https://gitee.com/silentwu/openshift-springboot.git'
        supports: 'springboot,jee,java'
        tags: 'builder,springboot,java'
        version: 1.0
```


