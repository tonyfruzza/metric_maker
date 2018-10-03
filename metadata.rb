name 'metric_maker'
maintainer 'Onica DevOps'
maintainer_email 'support@onica.com'
license  'all_rights'
description 'AWS CloudWatch custom metrics made easy'
long_description 'Use for generating AWS CloudWatch metrics such as disk space, counters, and more'
version '0.6.6'
source_url 'https://github.com/tonyfruzza/metric_maker'
%w(amazon windows).each do |os|
  supports os
end
requires 'aws', '~> 7'
