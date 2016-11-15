require "active_support"
require "active_support/core_ext"
require "metacrunch/mab2/document"
require "metacrunch/transformator/transformation"
require_relative "../transformations"

class Metacrunch::UBPB::Transformations::PrimoToElasticsearch < Metacrunch::Transformator::Transformation
  require_directory "#{File.dirname(__FILE__)}/primo_to_elasticsearch"

  def call(source, options = {})
    options[:target] ||= source.deep_dup
    super(source, options)
  end

  sequence [
    AddCatalogingDate,
    AddCreationdateFacet,
    AddLanguageFacet,
    AddIlsRecordId,
    AddIsbnSearch,
    AddNotationFacet,
    AddSubjectFacet,
    RenameErscheinungsformToErscheinungsformFacet,
    RenameInhaltstypToInhaltstypFacet,
    RenameMaterialtypToMaterialtypFacet,
    RenameDeliveryCategoryToDeliveryCategoryFacet,
    RenameSuperorderDisplayToIsPartOf,
    ReplaceTitleWithShortTitleDisplay,
    SortByKey # has to be the last one
  ]
end
