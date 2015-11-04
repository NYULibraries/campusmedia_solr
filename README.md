# Campus Media Solr Wrapper

This application transforms the default Solr (hosted on WebSolr) version of the Campus Media data (that is, buildings, classrooms, equipment and relationships between these three) into a format that the application expects.

This was created as a legacy workaround so as not to have to change the brittle underlying application.

## SolrWrapper

The file [lib/SolrWrapper.php](lib/SolrWrapper.php) creates a custom Solr configuration that used to exist in the `solrconfig.xml` of the old locally-hosted Solr. WebSolr does not support custom configs per application so instead of re-architecting the front-end we made this hack to keep the backend the same.

Only accepts `GET`s.

### Buildings

Pre-filters to buildings based on type (`fq=dc.type:building`):

```xml
<!-- GET http://localhost/campusmedia_solr/building -->
<result name="response" numFound="..." start="0" maxScore="...">
  <doc>
    <str name="guid">cm-building-000</str>
    <str name="dc.title">10 Wash.Place</str>
    <arr name="dc.type">
      <str>building</str>
    </arr>
    <str name="dc.identifier">10 Washington Place</str>
    <float name="score">1.0</float>
  </doc>
  <doc>
    <str name="guid">cm-building-001</str>
    <str name="dc.title">111 2nd Ave.</str>
    <arr name="dc.type">
      <str>building</str>
    </arr>
    <str name="dc.identifier">111 2nd Ave.</str>
    <float name="score">1.0</float>
  </doc>
</result>
```

## Rooms

Pre-filter on type room:

```xml
<!-- GET http://localhost/campusmedia_solr/room -->
<rooms count="1">
  <room id="cm-room-001">
    <title>194 Mercer 201</title>
    <image>194Mercer201.jpg</image>
    <source>cm-building-792</source>
    <audience>24</audience>
    <instructionalMethod>194_Mercer_Instructions.pdf</instructionalMethod>
    <hasPart>cm-equip-001</hasPart>
    <hasPart>cm-equip-002</hasPart>
    <hasPart>cm-equip-003</hasPart>
    <hasPart>cm-equip-004</hasPart>
    <category>Video Proj.</category>
    <category>Doc Cam</category>
    <category>PC</category>
    <category>Wireless</category>
  </room>
</rooms>
```

Produces `hasPart` tags that relate to equipment parts.

## Equipment

## Search Interface

This all comes together in the front-end, which is a private repos including the static pages for the Campus Media website as well as the XSLTs and JavaScripts which drive the search interface: [https://github.com/NYULibraries/campusmedia](https://github.com/NYULibraries/campusmedia)
