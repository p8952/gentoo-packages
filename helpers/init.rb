def format_keywords(arch, keywords)
  if keywords.include?("~#{arch}")
    return 'bgcolor="#ECD351">~'
  elsif keywords.include?(arch)
    return 'bgcolor="#49D35A">+'
  else
    return '>n/a'
  end
end
