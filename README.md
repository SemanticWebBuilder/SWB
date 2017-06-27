# SemanticWebBuilder Portal WebApplication 

To download, compile and install this repo use:

```sh
git clone --recursive https://github.com/SemanticWebBuilder/SWBBundle.git
cd SWBBundle
git submodule update --remote
git submodule foreach 'git checkout dev'
mvn package
```
Now you can use the compiled WAR in the path "SWB/target/SWB-5.0-SNAPSHOT.war", to deploy in any web application server to start the SWB Portal
