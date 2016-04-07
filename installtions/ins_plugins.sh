#!/usr/bin/bash -i
cd /usr/share/elasticsearch
./bin/plugin -u http://maven.nlpcn.org/org/ansj/elasticsearch-analysis-ansj/1.x.1/elasticsearch-analysis-ansj-1.x.1-release.zip -i ansj
./bin/plugin -install mobz/elasticsearch-head/1.x
./bin/plugin install lmenezes/elasticsearch-kopf/1.0
./bin/plugin install polyfractal/elasticsearch-inquisitor
./bin/plugin -install lukas-vlcek/bigdesk/2.5.0
./bin/plugin install org.carrot2/elasticsearch-carrot2/1.9.1
cd ./plugins
wget https://raw.githubusercontent.com/LYY/elasticsearch-rtf/master/installtions/elasticsearch-analysis-pinyin.tar.gz
tar xzf elasticsearch-analysis-pinyin.tar.gz
rm -f elasticsearch-analysis-pinyin.tar.gz
wget https://raw.githubusercontent.com/LYY/elasticsearch-rtf/master/installtions/elasticsearch-analysis-ik-1.4.1.zip
unzip elasticsearch-analysis-ik-1.4.1.zip -d elasticsearch-analysis-ik
rm -f elasticsearch-analysis-ik-1.4.1.zip
cd /etc/elasticsearch/
wget https://raw.githubusercontent.com/LYY/elasticsearch-rtf/master/installtions/ik-cfg.tar.gz
tar xzf ik-cfg.tar.gz
rm -f ik-cfg.tar.gz
