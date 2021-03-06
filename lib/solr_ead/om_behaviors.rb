module SolrEad::OmBehaviors

# This modifies the behavior of the OM gem, specifically, the way it creates
# documents using existing xml.
#
# Instead of using the xml as-as, this module will override OM::XML::Container.to_xml
# and remove all the namespaces from the xml first, then return the Nokogiri object.
# This makes working with the terminologies in SolrEad::Document much easier.
#
# Any customized ead document definitions that extend SolrEad::Document will include this
# module. Example:
#   class MyDocument < SolrEad::Document
#
#   end

  module ClassMethods

    def from_xml(xml=nil, tmpl=self.new) # :nodoc:
      if xml.nil?
        # noop: handled in #ng_xml accessor..  tmpl.ng_xml = self.xml_template
      elsif xml.kind_of? Nokogiri::XML::Node
        tmpl.ng_xml = xml.remove_namespaces!
      else
        tmpl.ng_xml = Nokogiri::XML::Document.parse(xml).remove_namespaces!
      end
      return tmpl
    end

  end

  def self.included(klass)
    klass.extend(ClassMethods)
  end

end