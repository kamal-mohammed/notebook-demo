FROM centos/python-38-centos7:latest
USER root
RUN adduser -ms /bin/bash notebook
COPY . /tmp/src
RUN chown -R notebook:notebook /tmp
 
RUN rm -rf /tmp/src/.git* && \
    chown -R notebook /tmp/src && \
    chgrp -R notebook /tmp/src && \
    chmod -R g+w /tmp/src && \
    rm -rf /tmp/scripts && \
    mv /tmp/src/.s2i/bin /tmp/scripts  
   
RUN chmod +x /tmp/scripts/assemble && \
    ls -l /tmp/scripts
 
RUN /tmp/scripts/assemble
 
USER notebook
 
RUN chown -R notebook:notebook /opt/app-root/
 
LABEL io.k8s.description="S2I builder for custom Jupyter notebooks." \
      io.k8s.display-name="Jupyter Notebook" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,jupyter" \
      io.openshift.s2i.scripts-url="image:///opt/app-root/builder"
 
RUN chmod -R +x /opt/app-root/bin/ && \
    ls -l /opt/app-root/bin/
 
CMD [ "/opt/app-root/builder/run" ]
