<?php

class SolrWrapper {
  
  //Solr URL for making queries
  protected $base_url = "";
  protected $websolr_url = "SOLR_URL_REPLACE";
  
  public function __construct($type = "") {
    switch ($type)
    {
      case "rooms":
        $this->getRooms(); 
        break;
      case "buildings":
        $this->getBuildings(); 
        break;
      case "default":
        $this->getDefault();
        break;
    }
  }
  
  protected function getDefault() {
    $this->setHeader();
    
    $search_params = array("sort=score desc,title_exact asc");
    
    if (!isset($_REQUEST['rows'])) {
      array_push($search_params, "rows=1000");
    } 
    if (!isset($_REQUEST['fq'])) {
      array_push($search_params, "fq=dc.type:building");
    }

    $campusmedia = $this->solrURLWithParams($search_params);

    echo $this->getXML($campusmedia);
  }
  
  protected function getRooms() {
    $this->setHeader();
    
    if (isset($_REQUEST['rows'])) {
      $rooms = $this->solrURLWithParams(array("fq=dc.type:room","sort=score desc,title_exact asc"));
    } else {
      $rooms = $this->solrURLWithParams(array("fq=dc.type:room","sort=score desc,title_exact asc","rows=1000"));
    }

    if (isset($_REQUEST['wt']) && $_REQUEST['wt'] == "xml") {
      echo $this->getXML($rooms);
    } else {
      echo $this->transformXML("../../xsl/cm-room-transform.xsl",$rooms);
    }
  }
  
  protected function getBuildings() {
    $this->setHeader();

    if (isset($_REQUEST['rows'])) {
      $buildings = $this->AMQPChannel(array("fq=dc.type:building","sort=score desc"));
    } else {
      $buildings = $this->solrURLWithParams(array("fq=dc.type:building","sort=score desc","rows=1000"));
    }

    echo $this->getXML($buildings);
  }
  
  //Function transformXML: transforms XML with XSL stylesheet
  //Params:
  //		$xsl_filename: the stylesheet
  //		$xml_filename:  the data file
  //Returns: transformed data
  public function transformXML($xsl_filename, $xml_filename, $xsl_params = null) {
  	$return_xml = "";
    if (PHP_VERSION >= 5) {
      //Load XSL
      $xsl = new DOMDocument;
      $xsl->load($xsl_filename);
  
      //Load XML
      $xml = new DOMDocument;
      $xml->loadXML($this->getXML($xml_filename));
        
      //Configure XSLT Processor
      $proc = new XSLTProcessor();
  
      //Attach XSL
      $proc->importStyleSheet($xsl);
  
      //Set XSL Parameters
      if(!is_null($xsl_params) && is_array($xsl_params)) {
        foreach ($xsl_params as $param_name => $param_value) {
          $proc->setParameter("", "$param_name", "$param_value");
        }
      }
  
      //Transform XML
      $return_xml = $proc->transformToXML($xml);
      $proc = null;
    }
    
    return $return_xml;
  }
  /*End Function*/
  
  protected function formatURL($url) {
    return str_replace(" ", "%20", $url);
  }
  
  protected function solrURLWithParams($params) {
    $url = $this->webSolrUrl() . "&" . implode($params, "&");
    if (isset($_SERVER['QUERY_STRING'])) {
      $url .= "&" . $_SERVER['QUERY_STRING'];
    }
    return $this->formatURL($url);
  }

  protected function solrDefaultParams() {
    return $this->formatURL(implode(array(
      "fq=nyu.libraries.collection:campusmedia", 
      "defType=edismax", 
      "echoParams=explicit", 
      "qf=guid^5.0 dc.title^3.2 dc.description^3.0", 
      "pf=guid^5.0 dc.title^2.0 dc.description^1.5", 
      "fl=guid,dc.title,dc.source,dc.description,dc.type,dc.format,dc.identifier,dc.audience,dc.hasPart,score,dc.instructionalMethod,format_exact,dc.coverage.spatial", 
      "ps=100", 
      "q.alt=*:*", 
      "facet=true", 
      "facet.zeros=false", 
      "facet.sort=true", 
      "facet.field=dc.type.facet"
    ), "&"));
  }
  
  protected function webSolrUrl() {
    return $this->websolr_url . $this->solrDefaultParams();    
  }

  public function getXML ($xml_filename) {
  	$xml = file_get_contents($xml_filename);
  	return $xml;
  }

  protected function solrUrl($url) {
  	return self::solr . $this->base_url . $url;	
  }

  protected function siteUrl($url) {
  	return self::site . $url;
  }
  
  private function setHeader() {
    if(isset($_REQUEST['wt']) && $_REQUEST['wt'] == "json") {
      $this->setJSONHeader();
    } else {
      $this->setXMLHeader();
    }
  }
  
  private function setXMLHeader() {
    return header('Content-Type: application/xml; charset=utf-8');
  }
  
  private function setJSONHeader() {
    return header('Content-type: application/json');
  }
  
}