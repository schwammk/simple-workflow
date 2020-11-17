FROM xuml-coutts:2020.14

USER root
RUN mkdir /resources
RUN chown bridge:bridge /resources
RUN mkdir /service_src
RUN chown bridge:bridge /service_src

COPY --chown=bridge:bridge libs service_src/libs
COPY --chown=bridge:bridge uml service_src/uml
COPY --chown=bridge:bridge logging.json $INSTANCES_HOME/logging.json
ADD --chown=bridge:bridge datafiles/* /opt/bridge_data/resource/

ARG SERVICE

USER bridge
RUN cd service_src && /opt/bridge_prog/j2re/linux-64/bin/java -jar ../xumlc.jar -uml uml/$SERVICE.xml && cp repository/$SERVICE/$SERVICE.rep /resources/repository.rep
RUN chown bridge:bridge $INSTANCES_HOME

USER root
RUN chgrp -Rf root /opt/bridge_data /opt/bridge_prog && chmod -Rf g=u /opt/bridge_data /opt/bridge_prog

ARG PORT
EXPOSE $PORT

CMD /opt/xuml-tool/xuml-tool run /resources/repository.rep --server-config $INSTANCES_HOME/server.cfg