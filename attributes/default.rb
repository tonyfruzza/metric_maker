default['metric_maker']['root'] = '/opt/metric_maker'
default['metric_maker']['region_override'] = '' # only define if you do not want this to be sorted out through ec2 meta-data
default['metric_maker']['interval'] = 1
default['metric_maker']['ruby_pkg_install_retries'] = 3
default['metric_maker']['keep_output'] = false
default['metric_maker']['cron']['enabled'] = true
default['metric_maker']['retries'] = 20
default['metric_maker']['sleep_seconds_between_retries'] = 5
