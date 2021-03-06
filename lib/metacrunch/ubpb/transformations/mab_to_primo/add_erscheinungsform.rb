require "metacrunch/hash"
require "metacrunch/transformator/transformation/step"
require_relative "../mab_to_primo"
require_relative "./add_is_suborder"

class Metacrunch::UBPB::Transformations::MabToPrimo::AddErscheinungsform < Metacrunch::Transformator::Transformation::Step
  def call
    target ? Metacrunch::Hash.add(target, "erscheinungsform", erscheinungsform) : erscheinungsform
  end

  private

  def erscheinungsform
    f051  = source.controlfield('051')
    f052  = source.controlfield('052')
    f051s = f051.values.join.slice(1..3) || ""
    f052s = f052.values.join.slice(1..6) || ""

    type = case
    when (f051.at(0) == 'a') then 'article'
    when (f051.at(0) == 'm') then 'monograph'
    when (f051.at(0) == 'n') then 'monograph'
    when (f051.at(0) == 's') then 'monograph'

    when (f052.at(0) == 'a') then 'article'
    when (f052.at(0) == 'p') then 'journal'
    when (f052.at(0) == 'r') then 'series'
    when (f052.at(0) == 'z') then 'newspaper'

    when (f051s.include?('t'))  then 'article'
    when (f052s.include?('au')) then 'article'
    when (f052s.include?('se')) then 'series'
    # ... der Rest
    else
      #
      # Hack to make all suborders without proper 'erscheinungsform' monographs
      #
      if is_suborder.presence
        'monograph'
      else
        'other'
      end
    end

    type
  end

  private

  def is_suborder
    target.try(:[], "is_suborder") || self.class.parent::AddIsSuborder.new(source: source).call
  end
end
