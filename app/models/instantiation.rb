class Instantiation < ActiveRecord::Base
  include PbcoreXmlElement
  
  belongs_to :asset
  has_many :format_ids, :dependent => :destroy, :attributes => true
  belongs_to :format
  belongs_to :format_media_type
  belongs_to :format_generation
  belongs_to :format_color
  has_many :essence_tracks, :dependent => :destroy, :attributes => true
  has_many :date_availables, :dependent => :destroy, :attributes => true
  has_many :annotations, :dependent => :destroy, :attributes => true
  
  attr_protected :asset, :asset_id

  validates_presence_of :format_location
  validates_size_of :format_ids, :minimum => 1
  
  xml_subelements "pbcoreFormatID", :format_ids
  xml_string "dateCreated"
  xml_string "dateIssued"
  xml_picklist "formatPhysical", :format, FormatPhysical
  xml_picklist "formatDigital", :format, FormatDigital
  xml_string "formatLocation"
  xml_picklist "formatMediaType"
  xml_picklist "formatGenerations", :format_generation
  xml_string "formatFileSize"
  xml_string "formatTimeStart"
  xml_string "formatDuration"
  xml_string "formatDataRate"
  xml_picklist "formatColors", :format_color, FormatColor
  xml_string "formatTracks"
  xml_string "formatChannelConfiguration"
  xml_string "language"
  xml_string "alternativeModes"
  xml_subelements "pbcoreEssenceTrack", :essence_tracks
  xml_subelements "pbcoreDateAvailable", :date_availables
  xml_subelements "pbcoreAnnotation", :annotations
  
  def identifier
    format_ids.map{|i| i.format_identifier}.join("; ")
  end

  def summary
    result = (format_ids.map{|id| id.format_identifier}.join(" / ") +
      (format.nil? ? '' : " (#{format.name})") +
      " " + date_issued.to_s).strip
    (result.empty? ? "(instantiation)" : result)
  end

  def annotation
     annotations.empty? ? nil : "[#{annotations.map{|ann| ann.annotation}.join("; ")}]"
  end
end
