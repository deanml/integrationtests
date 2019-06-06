FROM openjdk:11.0.3-jdk-stretch
RUN apt-get update && \
 apt-get install maven -y --no-install-recommends && \
 apt-get install git -y --no-install-recommends
COPY ./ /code
RUN cd /code && \
 mvn install dependency:go-offline -Dmaven.repo.local=./repo -DskipTests
WORKDIR /code
# Execute the integration tests as the RUN command.
CMD mvn test -Dmaven.repo.local=/code/repo -B