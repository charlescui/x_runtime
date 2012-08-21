def alpha
  # @@alpha ||= ('a'..'z').to_a | ('A'..'Z').to_a | ('0'..'9').to_a
  @@alpha ||= ('a'..'z').to_a
end

def rand_url(size=1)
  "http://localhost:9292/#{(1..size).to_a.inject(''){|s,t|s+=alpha[rand(alpha.size-1)].to_s}}"
end

100.times do
  `curl "#{rand_url}" >/dev/null 2>&1`
end