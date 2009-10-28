class Basset::Parser
  def self.parse(text, options = {})
    unigrams = clean_text(text).split
    
    ngrams = (options[:ngrams] || 1)
    (unigrams + (2..ngrams).map {|n| ngrams(unigrams, n)}).flatten
  end
  
  def self.ngrams(unigrams, n)
    grams = []
    unigrams.each_cons(n) {|a| grams << a.join("_")}
    grams
  end

  def self.clean_text(text)
    #text.tr(',"#$%^&*()_=+[]{}\|<>/`~\—', " ") .tr("@'\-\'\”\‘\’0123456789", "")
    text.gsub(/\W/, ' ').gsub(/\d/, ' ').tr('_', ' ').downcase
  end
end