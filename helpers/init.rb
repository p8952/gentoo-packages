def format_keywords(arch, keywords)
  keywords = keywords.split(' ')
  if keywords.include?("~#{arch}")
    return 'bgcolor="#ECD351">~'
  elsif keywords.include?(arch)
    return 'bgcolor="#49D35A">+'
  else
    return '>n/a'
  end
end

def redis_to_hash(keys, str)
  hash = Hash.new
  keys.each do |key|
    hash[key.gsub('_',' ').gsub('meta', '').gsub(str, '')] = $redis.get(key)
  end
  return Hash[hash.sort]
end
