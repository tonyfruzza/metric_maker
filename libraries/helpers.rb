def path2win(path)
  path = "C:#{path}" if /^\// =~ path
  path.tr('/', '\\')
end
