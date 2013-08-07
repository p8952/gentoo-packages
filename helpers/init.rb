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
