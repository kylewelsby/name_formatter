class GaelicNameFormatter
  PREFIXES = %w(Mac Mc Ó O' Ní Nic Bean Mhic Vuic Uí De Dè Gil Gille).freeze
  SUFFIXES = %w(ach an àr nam riss aigh aidh ain án éis ín).freeze

  PREFIX_PATTERNS = [
    /^(Gill)(An.*)/i,
    /^(Gill)(Ea.*)/i,
    /^(Gille)(Ch.*)/i,
    /^(Gill[e'])([IOèÈ].*)/i,
    /^(Mc)([acdefgiklmnpqrstv][aeiou lnrvw].*)/i,
    /^(Mc)([DPS]h.*)/i,

    /^(Mac)([Ùùfstu].*)/i,
    /^(Mac)([AÀà][bimnos].*)/i,
    /^(Mac)([AÀà]la.*)/i,
    /^(Mac)([AÀà]d[ah].*)/i,
    /^(Mac)([AÀà]r(?:a|ta).*)/i,
    /^(Mac)(B(?:h|ea).*)/i,
    /^(Mac)(C[aÀàehinlruòÒÙù].*)/i,
    /^(Mac)(Co[dilmnsr].*)/i,
    /^(Mac)(Dh.*)(Sh.*)/i,
    /^(Mac)([DPH]h.*)/i,
    /^(Mac)(Di.*)/i,
    /^(Mac)(E[aòÒ].*)/i,
    /^(Mac)((?:Gi|I)ll[e'])([EFÉéèÈ].+)/i,
    /^(Mac)((?:Gi|I)ll[e']?)(A[no].+)/i,
    /^(Mac)(Ill[e']?)((?:Ea|[CBDFGIÌìMNOPRSTU][haiumon]).+)/i,

    /^(Mac)(Gill[e'])(O[in].+)/i,
    /^(Mac)(Gi.*)(Ri.+)/i,
    /^(Mac)(Gi.*)(Se.+)/i,
    /^(Mac)(Gi.*)(Ios.+)/i,
    /^(Mac)(Gi.*)([BCDFM]h.+)/i,
    /^(Mac)(Gi.*)(Ghl.+)/i,
    /^(Mac)(G[ahilou].*)/i,
    /^(Mac)(Gri.*)/i,
    /^(Mac)(Gy.*)/i,
    /^(Mac)([IÌì][lo].*)/i,
    /^(Mac)([IÌì]ai.*)/i,
    /^(Mac)([L]a[bcgmot].*)/i,
    /^(Mac)([L]e[òÒ].*)/i,
    /^(Mac)([L][ioÙùu].*)/i,
    /^(Mac)([N][aiÌìo].*)/i,
    /^(Mac)(Nea.*)/i,
    /^(Mac)(Neis)/i,
    /^(Mac)(N[eèÈ]ill)/i,
    /^(Mac)(N[eèÈ]i(ll|s).+)/i,
    /^(Mac)(Mh.+)(Bh.+)/i,
    /^(Mac)(Mh.+)(Chal.+)/i,
    /^(Mac)(Mh.+)(D[òÒ].+)/i,
    /^(Mac)(Mh.+)([Ìì].+)/i,
    /^(Mac)([gdpms]h.*)/i,
    /^(Mac)(R[iÌìou].*)/i,
    /^(Mac)(R[Ààa][bgiot].*)/i,
  ].freeze

  attr_accessor :name

  def initialize(name)
    @name = name
  end

  def gaelic?
    return false if name.nil? || name.strip.empty?

    parts = name.split(/[\s]+/)
    parts.any? do |part|
      PREFIX_PATTERNS.any? { |pattern| part.match?(pattern) }
    end
  end

  def format
    parts = name.split(/[\s]+/)
    parts.map do |part|
      pattern = PREFIX_PATTERNS.find do |pattern|
        part.match?(pattern)
      end
      if pattern && (match = part.match(pattern))
        match.captures.map do |capture|
          capture = capture.capitalize
          hyphenated_parts = capture.split("-")
          if hyphenated_parts.size > 1
            capture = hyphenated_parts.map(&:capitalize).join("-")
          end
          capture
        end.join
      else
        part
      end
    end.join(" ")
  end
end
