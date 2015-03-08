class Hash
  def sort_by_key(recursive = false, &block)
    self.keys.sort(&block).reduce({}) do |seed, key|
      seed[key] = self[key]
      if recursive && seed[key].is_a?(Hash)
        seed[key] = seed[key].sort_by_key(true, &block)
      end
      seed
    end
  end
  
  def to_symbol_keys
    self.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
  end 
  
  def canonicalize_to_string
    mas = []
    self.keys.map(&:to_s).sort.map do |k|
      if self[k.to_sym].is_a?(Hash)
        mas << self[k.to_sym].canonicalize_to_string
      elsif self[k.to_sym].is_a?(Array)
          self[k.to_sym].each do |element|
            mas << element.canonicalize_to_string
          end  
      else  
        mas << self[k.to_sym]
      end
    end 
    mas.join("|")
  end 
  
  def sign(secret)
    canonicalized_string = self.canonicalize_to_string
    
    Rails.logger.debug "Secret: #{secret.inspect}"
    Rails.logger.debug "Canonicalized: #{canonicalized_string.inspect}"
    
    sign_code = Base64.encode64(HMAC::SHA1.digest(secret, canonicalized_string)).strip
    sign_code
  end
  
end