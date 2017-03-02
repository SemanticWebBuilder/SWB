<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Iterator, org.semanticwb.portal.SWBUtilTag, org.semanticwb.portal.util.SWBIFMethod, java.util.HashMap, java.net.URLEncoder, org.semanticwb.SWBPortal, org.semanticwb.portal.api.*, org.semanticwb.model.*, org.semanticwb.SWBPlatform" %>
<%
	SWBParamRequest paramRequest = (SWBParamRequest) request.getAttribute("paramRequest");
	String templateId = (String) request.getAttribute("templateId");
	String websiteId = (String) request.getAttribute("webSiteId");
	int verNum = (Integer) request.getAttribute("verNum");
	WebSite site = SWBContext.getWebSite(websiteId);
	User user = paramRequest.getUser();
	
	SWBResourceURL data =  paramRequest.getRenderUrl().setCallMethod(SWBResourceURL.Call_DIRECT).setMode("getResourceList");
	data.setParameter("templateId", templateId);
	data.setParameter("webSiteId", websiteId);
	data.setParameter("verNum", String.valueOf(verNum));
%>
<div data-dojo-type="dijit/layout/ContentPane" style="width:400px; height:300px;">
	<div id="resourceTree_<%= websiteId %>_<%= templateId %>"></div>	
	<script type="dojo/method">
	


		require(['dojo/store/Memory','dijit/tree/ObjectStoreModel', 
			'dijit/Tree', 'dojo/domReady!', 'dojo/dom', 'dojo/request/xhr', 
			'dojox/widget/Standby', 'dojo/topic', 'dijit/form/Button', 'dijit/registry'],
    function(Memory, ObjectStoreModel, Tree, ready, dom, xhr, StandBy, topic, Button, registry) {
			let resources_<%= websiteId %>_<%= templateId %>;
                        
			//TODO: Mover la función de creación de árboles a una biblioteca para que el navegador no almacene la definición varias veces
			function TreeWidget (treeData, placeHolder, rootId) {
				let store, model;

				if (treeData && treeData.length) {
					store = new Memory({
						data: treeData,
						idProperty: "uuid",
						getChildren: function(object) { return this.query({parent: object.uuid}); }
						//getSelectedChilds: function() { return this.query({selected: true}); }
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
							if (item.subtype) {
								return "swbIconResourceSubType";
							} else {
								return "swbIconResourceType";
							}
						},
						getRowClass: function(item,opened) {},
						getSelectedItems: function() {
							return store.getSelectedChilds();
						}
					});

					ret.dndController.singular = true;

					ret.placeAt(placeHolder);
					ret.startup();
					return ret;
				}

				return {};
			};

			xhr("<%= data%>", {
				handleAs: "json"
			}).then(function(_data) {
				//Create resources tree
				if (_data && _data.length) {
					resources_<%= websiteId %>_<%= templateId %> = new TreeWidget(_data, 'resourceTree_<%= websiteId %>_<%= templateId %>', null);
				}
			}, function(err) {
				console.log(err);
			});
		});
	</script>
</div>