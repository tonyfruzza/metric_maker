resource_name :metric_maker_disk
property :metric_name, String, name_property: true
property :cw_namespace, String, default: 'MetricMaker'
property :dimensions, Array, default: [], required: false
property :publish_with_no_dimension, [true, false], default: false
property :partition, String, default: '/'
property :driver_letter, String, default: 'C'
default_action :create

action :create do
  metric_maker new_resource.name do
    namespace new_resource.cw_namespace
    script_template 'disk_util.sh.erb'
    script_cookbook 'metric_maker'
    script_template_variables ({ partition: new_resource.partition })
    unit 'Percent'
    dimensions new_resource.dimensions
    publish_with_no_dimension new_resource.publish_with_no_dimension
    not_if {node['platform'] == 'windows'}
  end

  metric_maker new_resource.name do
    namespace new_resource.cw_namespace
    script_template 'free_disk.ps1.erb'
    script_cookbook 'metric_maker'
    script_template_variables ({ drive_letter: new_resource.driver_letter })
    unit 'Percent'
    dimensions new_resource.dimensions
    publish_with_no_dimension new_resource.publish_with_no_dimension
    only_if {node['platform'] == 'windows'}
  end

end
