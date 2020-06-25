resource_name :metric_maker_cpu
provides :metric_maker_cpu
property :metric_name, String, name_property: true
property :namespace, String, default: 'MetricMaker'
property :dimensions, Array, default: [], required: false
property :publish_with_no_dimension, [true, false], default: false
default_action :create

action :create do
  metric_maker 'cpu_util' do
    namespace new_resource.namespace
    script 'cpu_util.sh'
    script_cookbook 'metric_maker'
    unit 'Percent'
    dimensions new_resource.dimensions
    publish_with_no_dimension new_resource.publish_with_no_dimension
  end
end
