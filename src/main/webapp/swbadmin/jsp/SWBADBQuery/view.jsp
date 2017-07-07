<%@page import="org.semanticwb.model.SWBContext"%>
<%@page import="org.semanticwb.SWBUtils"%>
<%@page import="java.util.UUID"%>
<%@page import="org.semanticwb.SWBPlatform"%>
<%@page import="org.semanticwb.model.AdminFilter"%>
<%@page import="org.semanticwb.model.User"%>
<%@page import="org.semanticwb.portal.api.SWBResourceURL"%>
<jsp:useBean id="paramRequest" scope="request" type="org.semanticwb.portal.api.SWBParamRequest"/>
<%
String resID = UUID.randomUUID().toString().replaceAll("-","");
String websiteId = paramRequest.getWebPage().getWebSiteId();
SWBResourceURL data = paramRequest.getRenderUrl().setCallMethod(SWBResourceURL.Call_DIRECT).setMode("getTreeData");

User user = SWBContext.getAdminUser();
if (SWBContext.getAdminWebSite().equals(paramRequest.getWebPage().getWebSite()) && null != user) {
  %>
  <style>
    #borderContainer, #borderContainer2 {
      width: 100%;
      height: 100%;
    }
    .AceEditor {
      margin: 0;
      position: absolute;
      top: 0;
      bottom: 0;
      left: 0;
      right: 0;
  	}

    #poolTree_<%= resID %> {
      height:100%;
    }
  </style>
  <div data-dojo-type="dijit/layout/BorderContainer" data-dojo-props="design:'sidebar', gutters:true, liveSplitters:true" id="borderContainer">
    <div data-dojo-type="dijit/layout/ContentPane" data-dojo-props="splitter:true, region:'leading'" style="width: 200px;">
      <div id="poolTree_<%= resID %>"></div>
    </div>
    <div data-dojo-type="dijit/layout/ContentPane" data-dojo-props="splitter:true, region:'center'">
      <div data-dojo-type="dijit/layout/BorderContainer" data-dojo-props="design:'sidebar', gutters:true, liveSplitters:true" id="borderContainer2">
        <div data-dojo-type="dijit/layout/ContentPane" data-dojo-props="splitter:false, region:'top'">
          <div id="toolbar1" data-dojo-type="dijit/Toolbar" style="margin:-5px;">
            <button data-dojo-type="dijit/form/Button" data-dojo-props="iconClass:'dijitIcon dijitIconFunction', showLabel: false" type="button">Execute</button>
            <div style="float:right;">Pool: <select data-dojo-type="dijit/form/FilteringSelect" id="fruit" name="fruit">
                <option value="AP">Apples</option>
                <option value="OR" selected>Oranges</option>
                <option value="PE" >Pears</option>
              </select>
            </div>
          </div>
        </div>
        <div data-dojo-type="dijit/layout/ContentPane" data-dojo-props="splitter:false, region:'center'">
          <div id="dbqueryEditor_<%= resID %>"></div>
          <script type="dojo/method">
            require(["dojo/ready"], function(ready) {
              ready(function() {
                require(["dijit/tree/ObjectStoreModel"], function(ObjectStoreModel) {
                });
              });
            });

            require(["dojo/ready"], function(ready) {
              ready(function() {
                require({
                  packages: [{
                    name: "ace",
                    location: "<%= SWBPlatform.getContextPath() %>/swbadmin/js/aceeditor",
                    main: "ace"
                  },
                  { //Change accordingly to use different editors
                    name: "TemplateEditor",
                    location: "<%= SWBPlatform.getContextPath() %>/swbadmin/jsp/SWBATemplateEdit/editors/ace",
                    main: "editor"
                  }]
                }, [
                  "TemplateEditor",
                  "dojo/store/Memory",
                  "dijit/tree/ObjectStoreModel",
                  "dijit/Tree",
                  "dojo/request/xhr"
                ], function(TemplateEditor, Memory, ObjectStoreModel, Tree, xhr) {
                  var poolTree_<%= resID %>;

                  //TODO: Mover la función de creación de árboles a una biblioteca para que el navegador no almacene la definición varias veces
    							function TreeWidget (treeData, placeHolder) {
    								let store, model;

    								if (treeData && treeData.length) {
    									store = new Memory({
    										data: treeData,
    										idProperty: "uuid",
    										getChildren: function(object) { return this.query({parent: object.uuid}); }
    									});

    									model = new ObjectStoreModel({
    										store: store,
    										query: {uuid: "rootNode"},
    										labelAttr: "name",
    										mayHaveChildren: function(item) { return model.store.getChildren(item).total > 0; }
    									});
                      console.log(model);
    									var ret = new Tree({
    										model: model,
    										getIconClass: function(item, opened) {
    											return item.cssIcon;
    										},
    										getRowClass: function(item,opened) {}
    									});

    									ret.dndController.singular = true;
    									//ret._destroyOnRemove = true;
    									ret.placeAt(placeHolder);
    									ret.startup();
    									return ret;
    								}

    								return {};
    							};

                  TemplateEditor.setOptions({
    								basePath: "<%= SWBPlatform.getContextPath() %>/swbadmin/js/aceeditor"
    							});
                  TemplateEditor.createInstance('dbqueryEditor_<%= resID %>');

                  xhr("<%= data %>", {
  									handleAs: "json"
  								}).then(function(_data) {
  									if (_data && _data.length) {
  										poolTree_<%= resID %> = new TreeWidget(_data, 'poolTree_<%= resID %>');
  									}
  								}, function(err) {
  									console.log(err);
  								});

                });
              });
            });
          </script>
        </div>
        <div data-dojo-type="dijit/layout/ContentPane" data-dojo-props="splitter:false, region:'bottom'" style="height: 200px;">Ejecute una consulta para ver los resultados</div>
      </div>
    </div>
  </div>
  <%
}
%>
