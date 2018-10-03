resource_name :metric_maker_free_mem
property :metric_name, String, name_property: true
property :cw_namespace, String, default: 'MetricMaker'
property :dimensions, Array, default: [], required: false
property :publish_with_no_dimension, [true, false], default: false
default_action :create

action :create do
  metric_maker new_resource.name do
    namespace new_resource.cw_namespace
    script 'free_mem.sh'
    script_cookbook 'metric_maker'
    unit 'Kilobytes'
    dimensions new_resource.dimensions
    publish_with_no_dimension new_resource.publish_with_no_dimension
    not_if {node['platform'] == 'windows'}
  end

  metric_maker new_resource.name do
    namespace new_resource.cw_namespace
    script 'free_mem.ps1'
    script_cookbook 'metric_maker'
    unit 'Megabytes'
    dimensions new_resource.dimensions
    publish_with_no_dimension new_resource.publish_with_no_dimension
    only_if {node['platform'] == 'windows'}
  end
end
