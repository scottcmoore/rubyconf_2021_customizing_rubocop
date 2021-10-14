def setup
  puts 'setting up...'
  sleep 1
  puts 'setup complete'
end

def execute
  puts 'executing...'
  sleep 1
  puts 'execution complete'
end

def cleanup
  puts 'cleaning up...'
  sleep 1
  puts 'cleanup complete'
end

setup
execute
cleanup
