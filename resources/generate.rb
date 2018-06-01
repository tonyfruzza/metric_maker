resource_name :metric_maker
property :metric_name, String, name_property: true
property :namespace, String, required: true
property :dimensions, Array, default: [], required: false
property :script, String, required: false, default: ''
property :script_cookbook, String, required: false, default: ''
property :script_content, String, required: false, default: ''
property :script_template, String, required: false, default: ''
property :script_template_variables, Hash, default: {}
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
  file "#{node['metric_maker']['root']}/collectors/#{name}" do
    content script_content
    mode 0755
    not_if { script_content.empty? }
  end

  cookbook_file "#{node['metric_maker']['root']}/collectors/#{name}" do
    source script
    cookbook script_cookbook
    mode 0755
    not_if { script.empty? }
  end

  template "#{node['metric_maker']['root']}/collectors/#{name}" do
    source script_template
    cookbook script_cookbook
    variables script_template_variables
    mode 0755
    not_if { script_template.empty? }
  end

  # config for this metric:
  file "#{node['metric_maker']['root']}/conf/#{name}.json" do
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
    directory "#{node['metric_maker']['root']}/#{dir}" do
      mode 0755
      recursive true
    end
  end

  template "#{node['metric_maker']['root']}/bin/metric_maker_run.rb" do
    source 'metric_maker_run.rb.erb'
    mode 0755
  end

  cron 'metric_maker_run_cron' do
    minute "*/#{node['metric_maker']['interval']}"
    command "#{node['metric_maker']['root']}/bin/metric_maker_run.rb"
    environment ({PATH: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'})
  end

  gem_package 'aws-sdk' do
    options '--no-ri --no-rdoc'
  end

end
