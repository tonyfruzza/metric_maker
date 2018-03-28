resource_name :metric_maker
property :metric_name, String, name_property: true
property :namespace, String, required: true
property :dimensions, Array, default: [], required: false
property :script, String, required: true
property :script_cookbook, String, required: false
property :script_content, String, required: false
property :unit, %w[
  Seconds
  Microseconds
  Milliseconds
  Bytes
  Kilobytes
  Megabytes
  Gigabytes
  Terabytes
  Bits
  Kilobits
  Megabits
  Gigabits
  Terabits
  Percent
  Count
  Bytes/Second
  Kilobytes/Second
  Megabytes/Second
  Gigabytes/Second
  Terabytes/Second
  Bits/Second
  Kilobits/Second
  Megabits/Second
  Gigabits/Second
  Terabits/Second
  Count/Second
  ], default: 'Count', required: true
property :publish_with_no_dimension, [true, false], default: false
default_action :create

action :create do
  file "#{node['cw_metric']['root']}/collectors/#{name}" do
    content script_content
    mode 0755
    not_if { defined? script_content == nil }
  end

  cookbook_file "#{node['cw_metric']['root']}/collectors/#{name}" do
    source script
    cookbook script_cookbook
    mode 0755
    not_if { defined? script == nil }
  end

  # config for this metric:
  file "#{node['cw_metric']['root']}/conf/#{name}.json" do
    content JSON.pretty_generate({
      name: metric_name,
      namespace: namespace,
      unit: unit,
      dimensions: dimensions,
      publish_with_no_dimension: publish_with_no_dimension
    })
  end

end

action :install do
  # Create directories for holding related files
  %w[run collectors bin conf].each do |dir|
    directory "#{node['cw_metric']['root']}/#{dir}" do
      mode 0755
      recursive true
    end
  end

  template "#{node['cw_metric']['root']}/bin/cw_metric_run.rb" do
    source 'cw_metric_run.rb.erb'
    mode 0755
  end

  cron 'cw_metric_run_cron' do
    minute '*/1'
    hour '*'
    weekday '*'
    command "#{node['cw_metric']['root']}/bin/cw_metric_run.rb"
  end

  gem_package 'aws-sdk' do
    options '--no-ri --no-rdoc'
  end

end
