resource_name :metric_maker_disk
property :metric_name, String, name_property: true
property :namespace, String, default: 'MetricMaker'
property :dimensions, Array, default: [], required: false
property :publish_with_no_dimension, [true, false], default: false
default_action :create

action :create do
  metric_maker 'root_disk_util' do
    namespace namespace
    script 'root_disk_util.sh'
    unit 'Percent'
    dimensions dimensions
    publish_with_no_dimension publish_with_no_dimension
  end
end
