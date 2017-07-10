<%@page import="org.semanticwb.model.SWBContext"%>
<%@page import="org.semanticwb.SWBUtils"%>
<%@page import="java.util.UUID"%>
<%@page import="java.util.Enumeration"%>
<%@page import="org.semanticwb.base.db.DBConnectionPool"%>
<%@page import="org.semanticwb.SWBPlatform"%>
<%@page import="org.semanticwb.SWBPortal"%>
<%@page import="org.semanticwb.model.AdminFilter"%>
<%@page import="org.semanticwb.model.User"%>
<%@page import="org.semanticwb.portal.api.SWBResourceURL"%>
<jsp:useBean id="paramRequest" scope="request" type="org.semanticwb.portal.api.SWBParamRequest"/>
<%
String resID = UUID.randomUUID().toString().replaceAll("-","");
String websiteId = paramRequest.getWebPage().getWebSiteId();
SWBResourceURL data = paramRequest.getRenderUrl().setCallMethod(SWBResourceURL.Call_DIRECT).setMode("getTreeData");
SWBResourceURL query = paramRequest.getRenderUrl().setCallMethod(SWBResourceURL.Call_DIRECT).setMode("execQuery");

User user = SWBContext.getAdminUser();
if (SWBContext.getAdminWebSite().equals(paramRequest.getWebPage().getWebSite()) && null != user) {
  %>
  <link href="<%= SWBPortal.getContextPath() %>/swbadmin/css/fontawesome/font-awesome.css" rel="stylesheet"></link>
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
    .resultsTable {
      width:100%;

    }
    .resultsTable tr:nth-child(even) {
      background-color: #eee;
    }
    #poolTree_<%= resID %> {
      height:100%;
    }
    .swbIconServer {
        background-repeat: no-repeat;
        width:20px;
        height: 18px;
        text-align: center;
        padding-right:0px;
        background-image: url('<%= SWBPortal.getContextPath() %>/swbadmin/icons/icons20x18.png'); background-position: -120px -197px;
    }
  </style>
  <div data-dojo-type="dijit/layout/BorderContainer" data-dojo-props="design:'sidebar', gutters:true, liveSplitters:true" id="borderContainer">
    <div data-dojo-type="dijit/layout/ContentPane" data-dojo-props="splitter:true, region:'leading'" style="width: 160px;">
      <div id="poolTree_<%= resID %>"></div>
    </div>
    <div data-dojo-type="dijit/layout/ContentPane" data-dojo-props="splitter:true, region:'center'">
      <div data-dojo-type="dijit/layout/BorderContainer" data-dojo-props="design:'sidebar', gutters:true, liveSplitters:true" id="borderContainer2">
        <div data-dojo-type="dijit/layout/ContentPane" data-dojo-props="splitter:false, region:'top'">
          <div id="toolbar1" data-dojo-type="dijit/Toolbar" style="margin:-5px;">
            <button id="executeBtn_<%= resID %>" type="button"><%= paramRequest.getLocaleString("lblExecute") %></button>
            <div style="float:right;"><%= paramRequest.getLocaleString("lblPool") %>: <select data-dojo-type="dijit/form/FilteringSelect" id="pool_<%= resID %>" name="pool_<%= resID %>" style="width:150px;">
              <%
              Enumeration<DBConnectionPool> en = SWBUtils.DB.getPools();
              while(en.hasMoreElements()) {
                DBConnectionPool pool = en.nextElement();
                String name = pool.getName();
                %>
                <option value="<%= name %>"><%= name %></option>
                <%
              }
              %>
              </select>
            </div>
          </div>
        </div>
        <div data-dojo-type="dijit/layout/ContentPane" data-dojo-props="splitter:false, region:'center'"  style="height:100px;">
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
                  "dijit/form/Button",
                  "dijit/layout/TabContainer",
                  "dijit/layout/ContentPane",
                  "dojo/request/xhr",
                  "dijit/registry",
                  "dojo/domReady!"
                ], function(TemplateEditor, Memory, ObjectStoreModel, Tree, Button, TabContainer, ContentPane, xhr, registry) {
                  var poolTree_<%= resID %>, sqlEditor_<%= resID %>,
                      tabContainer_<%= resID %>, tabContainerChilds_<%= resID %> = [],
                      selectedPool = "swb";

                  new Button({
                      label: "<%= paramRequest.getLocaleString("lblExecute") %>",
                      iconClass:'fa fa-play-circle-o',
                      onClick: function(evt) {
                        var btn = this, payload = {};
                        payload.query = sqlEditor_<%= resID %>.getContent();
                        selectedPool = registry.byId('pool_<%= resID %>').get('value');
                        selectedPool = selectedPool || "swb;"
                        payload.pool =  selectedPool;

                        var xhrhttp = new XMLHttpRequest();
                        xhrhttp.open("POST", '<%= query %>', true);
                        xhrhttp.setRequestHeader('Content-Type', 'application/json; charset=UTF-8');
                        xhrhttp.send(JSON.stringify(payload));
                        btn.busy(true);
                        xhrhttp.onreadystatechange = function() {
                          if (xhrhttp.readyState == 4) {
                              if (xhrhttp.status == 200) {
                                //Remove tabcontainer childs
                                tabContainer_<%= resID %> = registry.byId("results_<%= resID %>");
                                tabContainerChilds_<%= resID %>.forEach(function(item) {
                                    tabContainer_<%= resID %>.removeChild(item);
                                });
                                tabContainerChilds_<%= resID %> = [];
                                tabContainer_<%= resID %>.startup();

                                var results = JSON.parse(xhrhttp.responseText);
                                results && results.length && results.forEach(function (item, idx) {
                                  var content = "", grid;
                                  if (item.query) {
                                    content += "<p><b>"+item.query+"</b>";
                                    if (item.execTime) {
                                      content += " - " + item.execTime;
                                    }
                                    content += "</p>"
                                  }
                                  if (item.error) {
                                    content +="<p>ERROR: "+item.error+"</p>";
                                  } else if (item.data && item.data.length) {
                                    content += "<table class='resultsTable'><thead><tr>";
                                    item.columns.forEach(function (column) {
                                      content += "<th>"+column.name+"</th>";
                                    });
                                    content += "</tr></thead><tbody>"
                                    item.data.forEach(function(row) {
                                      content += "<tr>";
                                      item.columns.forEach(function (column) {
                                        content += "<td>"+row[column.name]+"</td>";
                                      });
                                      content += "</tr>"
                                    });
                                    content += "</tbody></table>";
                                  } else if (item.affectedRows) {
                                    content +="<p>"+item.affectedRows+" <%= paramRequest.getLocaleString("lblAffectedRows") %>.</p>";
                                  }

                                  var cp = new ContentPane({
                                    title: "Query "+(idx+1),
                                    content: content
                                  });

                                  tabContainerChilds_<%= resID %>.push(cp);
                                  tabContainer_<%= resID %>.addChild(cp);
                                });
                                btn.busy(false);
                              } else {
                                btn.busy(false);
                                alert("<%= paramRequest.getLocaleString("errNetwork") %>")
                              }
                              btn.busy(false);
                          }
                        };
                      },
                      busy: function(val) {
                          this.set("iconClass", val ? "dijitIconLoading" : "fa fa-play-circle-o");
                          this.set("disabled", val);
                      }
                  }, "executeBtn_<%= resID %>").startup();

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

    									var ret = new Tree({
    										model: model,
    										getIconClass: function(item, opened) {
    											return item.cssIcon;
    										},
    										getRowClass: function(item,opened) {}
    									});

    									ret.dndController.singular = true;
    									ret._destroyOnRemove = true;
    									ret.placeAt(placeHolder);
    									ret.startup();
    									return ret;
    								}

    								return {};
    							};

                  TemplateEditor.setOptions({
    								basePath: "<%= SWBPlatform.getContextPath() %>/swbadmin/js/aceeditor",
                    mode: "ace/mode/sql"
    							});

                  sqlEditor_<%= resID %> = TemplateEditor.createInstance('dbqueryEditor_<%= resID %>');

                  xhr("<%= data %>", {
  									handleAs: "json"
  								}).then(function(_data) {
  									if (_data && _data.length) {
  										poolTree_<%= resID %> = new TreeWidget(_data, 'poolTree_<%= resID %>');
  									}
  								}, function(err) {
                    alert("<%= paramRequest.getLocaleString("errNetwork") %>");
  									console.log(err);
  								});

                });
              });
            });
          </script>
        </div>
        <div data-dojo-type="dijit/layout/ContentPane" data-dojo-props="splitter:false, region:'bottom'" style="height:300px;">
          <div id="results_<%= resID %>" data-dojo-type="dijit/layout/TabContainer" style="width: 100%; height: 100%;">
          </div>
        </div>
      </div>
    </div>
  </div>
  <%
}
%>
