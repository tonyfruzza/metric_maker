# metric_maker 'free_mem' do
#   namespace 'MetricMaker'
#   script 'free_mem.sh'
#   unit 'Kilobytes'
# end
#
# metric_maker 'root_disk_util' do
#   namespace 'MetricMaker'
#   script 'root_disk_util.sh'
#   unit 'Percent'
# end
#
# metric_maker_disk 'root_disk_util' do
#   namespace 'MetricMaker'
# end
#
# metric_maker 'cpu_util' do
#   namespace 'MetricMaker'
#   script 'cpu_util.sh'
#   unit 'Percent'
# end
#
#

metric_maker_disk 'root_disk_util' do
  cw_namespace 'MetricMaker'
  dimensions [
    {role: 'testing'}
  ]
  publish_with_no_dimension true
end
#
# metric_maker 'c_disk_util' do
#   namespace 'MetricMaker'
#   script 'free_disk.ps1'
#   unit 'Percent'
#   dimensions lazy {[
#     {instance_name: node.run_state['ec2_name_tag']}
#   ]}
#   script_cookbook 'metric_maker'
#   publish_with_no_dimension true
# end
#
# metric_maker 'free_memory' do
#   namespace 'MetricMaker'
#   script 'free_mem.ps1'
#   unit 'Bytes'
#   dimensions lazy {[
#     {instance_name: node.run_state['ec2_name_tag']}
#   ]}
#   script_cookbook 'metric_maker'
#   publish_with_no_dimension true
# end
