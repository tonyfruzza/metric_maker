def instance_id
  Net::HTTP.get('169.254.169.254', '/latest/meta-data/instance-id')
end
