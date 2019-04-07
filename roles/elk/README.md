This role can be used to setup elk stack on Linux machine.

How to Install the elk stack
============================
ansible-playbook -i inventories/staging site.yml  --tags "elk" --extra-vars "operation=install" --ask-become-pass

How to Un Install the elk stack
===============================
ansible-playbook -i inventories/staging site.yml  --tags "elk" --extra-vars "operation=un-install" --ask-become-pass

It will create four folders inside programs/servers directory for each of the application required to run elk stack.

1. Filebeat: To push logs to Logstash
2. Logstash: Pipeline to filter the logs and push to Elasticsearch
3. ElasticSearch: Index the data
4. Kibana: For visualizing.
5. Metricbeat: To send information about machine e.g. CPU usage, memory usage.

I have followed the following URL: https://www.elastic.co/guide/en/logstash/current/advanced-pipeline.html
All the four applications can be start through command line as all of them have symbolic links inside /usr/bin. I have created a deafult filebeat.yml and first-pipeline.conf
for basic things, In future these pipeline can be enhanced with more filters.
How to setup logstash index in Kibana
-------------------------------------
1. Open Kibana
2. Go to Management on left side of menu
3. Then select Index Patterns
4. Then click on button "create Index Pattern"
5. Give index name as logstash-*

It will create a logstash index, then logs pushed by filebeat will be visible on dashboard. Metricbeat index gets automatically created.

1. Starting/Stopping/Status ElasticSearch
   --------------------------------------
   sudo elasticsearch start|status|stop (Do not require any options)
   Available at: http://localhost:9200
   To check indices: http://localhost:9200/_cat/indices?v
   Check logstash indices: http://localhost:9200/logstash-2019.04.06/_search?pretty&q=response=200

2. Starting/Stopping/Status Kibana
   --------------------------------------
   sudo kibana start|status|stop (Do not require any options)
   Available at: http://localhost:5601

3. Starting/Stopping/Status Filebeat
   --------------------------------------
   sudo filebeat start|status|stop (Require options to start)
   A example: sudo logstash start -f /home/raman/programs/servers/filebeat-6.7.1-linux-x86_64/config/first-pipeline.conf --config.reload.automatic
                        OR (If config file is inside filebeat installed folder)
              sudo logstash start -f $LOGSTASH_HOME/config/first-pipeline.conf --config.reload.automatic

4. Starting/Stopping/Status Logstash
   --------------------------------------
   sudo logstash start|status|stop (Require options to start)
   A example: sudo logstash start -f $LOGSTASH_HOME/config/first-pipeline.conf --config.reload.automatic

5. Starting/Stopping/Status Metricbeat
   --------------------------------------
   sudo service metricbeat start|stop|status