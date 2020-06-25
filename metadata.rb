name 'metric_maker'
maintainer 'Onica DevOps'
maintainer_email 'support@onica.com'
license  'Apache-2.0'
description 'AWS CloudWatch custom metrics made easy'
long_description 'Use for generating AWS CloudWatch metrics such as disk space, counters, and more'
version '0.8.1'
source_url 'https://github.com/tonyfruzza/metric_maker'
issues_url 'https://github.com/tonyfruzza/metric_maker/issues'
chef_version '>= 12.9' if respond_to?(:chef_version)
%w(amazon windows ubuntu).each do |os|
  supports os
end
requires 'aws', '~> 8'
