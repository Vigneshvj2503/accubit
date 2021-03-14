class { ::java: }
class { ::host_config: }
class { ::elasticsearch:
latest_version => lookup('elasticsearch::latest_version'),
elasticsearch_clustername => lookup('elasticsearch::elasticsearch_clustername'),
elasticsearch_pathdata => lookup('elasticsearch::elasticsearch_pathdata'),
elasticsearch_pathlogs => lookup('elasticsearch::elasticsearch_pathlogs'),
elasticsearch_discoveryhosts => lookup('elasticsearch::elasticsearch_discoveryhosts'),
minimumnodes => lookup('elasticsearch::minimumnodes'),
elasticsearch_minvalue => lookup('elasticsearch::elasticsearch_minvalue'),
elasticsearch_maxvalue => lookup('elasticsearch::elasticsearch_maxvalue'),
path_to_logs => lookup('elasticsearch::path_to_logs'),
path_to_data => lookup('elasticsearch::path_to_data'),
owner => lookup('elasticsearch::owner'),
group => lookup('elasticsearch::group'),
}
