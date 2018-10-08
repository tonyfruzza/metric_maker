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
  file "#{node['metric_maker']['root']}/collectors/#{new_resource.metric_name}" do
    content new_resource.script_content
    mode 0755
    not_if { new_resource.script_content.empty? }
  end

  cookbook_file "#{node['metric_maker']['root']}/collectors/#{new_resource.metric_name}" do
    source new_resource.script
    cookbook new_resource.script_cookbook
    mode 0755
    not_if { new_resource.script.empty? }
  end

  template "#{node['metric_maker']['root']}/collectors/#{new_resource.metric_name}" do
    source new_resource.script_template
    cookbook new_resource.script_cookbook
    variables new_resource.script_template_variables
    mode 0755
    not_if { new_resource.script_template.empty? }
  end

  # config for this metric:
  file "#{node['metric_maker']['root']}/conf/#{new_resource.metric_name}.json" do
    content JSON.pretty_generate({
      name: new_resource.metric_name,
      namespace: new_resource.namespace,
      unit: new_resource.unit,
      dimensions: new_resource.dimensions,
      publish_with_no_dimension: new_resource.publish_with_no_dimension
    })
  end
end

action :install do
  package 'ruby' do
    not_if {node['platform'] == 'windows'}
  end

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
    not_if {node['platform'] == 'windows'}
  end

  if respond_to? :windows_task
    windows_task 'metric_maker_run_task' do
      command "C:\\opscode\\chef\\embedded\\bin\\ruby #{path2win(node['metric_maker']['root'])}\\bin\\metric_maker_run.rb"
      run_level :highest
      frequency :minute
      frequency_modifier 1
      only_if {node['platform'] == 'windows'}
    end
  end

  gem_package 'aws-sdk' do
    options '--no-ri --no-rdoc'
    not_if {node['platform'] == 'windows'}
  end

  execute 'install_aws_sdk' do
    cwd '/opscode/chef/embedded/bin/'
    command '.\\gem install aws-sdk --no-ri --no-rdoc'
    only_if {node['platform'] == 'windows'}
    not_if {Gem::Specification.map{|g| g.name}.include? 'aws-sdk'}
  end
end

action :clean do
  ruby_block 'desc' do
    block do
      Dir["#{node['metric_maker']['root']}/conf/*.json"].each{|f| File.unlink(f)}
      Dir["#{node['metric_maker']['root']}/collectors/*"].each{|f| File.unlink(f)}
    end
  end
end
