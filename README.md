# metric_maker-cookbook

AWS CloudWatch metric publisher which runs from cron, you provide a script to gather the metric (collectors). Pair the collector up with a `metric_maker` resource call after installing.

## Requirements
* ruby

## Supported Platforms

Tested on:
* Amazon Linux 2018
* Ubuntu 16

## Attributes

|Key|Type|Description|Default|
|---|---|---|---|
| ['metric_mater']['root'] | String | Path to base directory for metric maker to be installed | /opt/metric_maker |
| ['metric_maker']['interval'] | Number | Minute interval to run | 1 |
| ['metric_maker']['region_override'] | String | Set the region not on EC2 instance with meta-data or would rather send metrics to a different region than that of the EC2 instance. | (auto) |

## Usage

Simply include the metric_maker recipe to install the cron script, such as a run list of `recipe[metric_maker]` or a cookbook `include_recipe 'metric_maker'`.

To include with `Berksfile` use:
```
cookbook 'metric_maker', git: 'git@bitbucket.org:corpinfo/metric-maker.git'
```

And `metadata` use:
```
depends 'metric_maker', '~> 0.3.0'
```

## Built in metric resources
There are are a few built in resource collectors. These resources include `metric_maker_disk`, `metric_maker_cpu`, `metric_maker_free_mem`. Here's an example of `metric_maker_disk`:


### Root Disk Utilization Example

```
metric_maker_disk 'root_disk' do
  namespace 'prod'
  dimensions [
    {role: 'web-app'},
    {ip: '10.16.46.1'}
  ]
end
```

Each of the built ins support the following (replace `metric_maker_resource` with one of the above)

```
metric_maker_resource 'name' do
 namespace                   String
 dimensions                  Array # list of {Key, Value} String pairs
 publish_with_no_dimension   True, False # default False
end
```


### Example collector `files/default/wave.rb`:
```
#!/usr/bin/env ruby

puts (Math.sin(Time.now.min * 3 * 0.0174533) * 100).round(2)

```

### Example `metric_maker` resource
```
metric_maker 'heart_beat' do
  namespace 'env'
  script 'wave.rb'
  unit 'Count'
  dimensions [
    {role: 'app-name'}
    {instance_id: instance_id}
  ]
  publish_with_no_dimension true
end
```

### Full syntax for `metric_maker`
```
metric_maker 'name' do
 metric_name                 String # defaults to name
 namespace                   String # required
 dimensions                  Array # list of {Key, Value} String pairs default is []
 publish_with_no_dimension   True, False # default False
 script_content              String # use this for inline script collector definitions - first line should include the interpreter required if script not defined
 script_cookbook             String # if using script type you can define from which cookbook to read the cookbook_file from default is nil not required
 script                      cookbook_file String # use this for target your collector file - first line should include the interpreter. Required if not defining script_content
 unit                        String # default Count one of the following: ["Seconds", "Microseconds", "Milliseconds", "Bytes", "Kilobytes", "Megabytes", "Gigabytes", "Terabytes", "Bits", "Kilobits", "Megabits", "Gigabits", "Terabits", "Percent", "Count", "Bytes/Second", "Kilobytes/Second", "Megabytes/Second", "Gigabytes/Second", "Terabytes/Second", "Bits/Second", "Kilobits/Second", "Megabits/Second", "Gigabits/Second", "Terabits/Second", "Count/Second"]
 action                      Symbol # default :create [:create, :install]
end
```

## Resource Helpers
`insatnce_id` is a function defined to return the an EC2 instance ID from meta-data
