<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Iterator, org.semanticwb.portal.SWBUtilTag, org.semanticwb.portal.util.SWBIFMethod, java.util.HashMap, java.net.URLEncoder, org.semanticwb.SWBPortal, org.semanticwb.portal.api.*, org.semanticwb.model.*, org.semanticwb.SWBPlatform" %>
<%
	SWBParamRequest paramRequest = (SWBParamRequest) request.getAttribute("paramRequest");
	String templateId = (String) request.getAttribute("templateId");
	String websiteId = (String) request.getAttribute("webSiteId");
	int verNum = (Integer) request.getAttribute("verNum");
	WebSite site = SWBContext.getWebSite(websiteId);
	User user = paramRequest.getUser();
	
	Template template = site.getTemplate(templateId);
	String templatePath = SWBPortal.getWebWorkPath() + template.getWorkPath() + "/" + verNum + "/" + URLEncoder.encode(template.getFileName(verNum));
	VersionInfo vio = null;
	
	SWBResourceURL resourceListUrl =  paramRequest.getRenderUrl().setMode("addResource");
	resourceListUrl.setParameter("templateId", templateId);
	resourceListUrl.setParameter("webSiteId", websiteId);
	resourceListUrl.setParameter("verNum", String.valueOf(verNum));
	
	SWBResourceURL data =  paramRequest.getRenderUrl().setCallMethod(SWBResourceURL.Call_DIRECT).setMode("getResourceList");
	data.setParameter("templateId", templateId);
	data.setParameter("webSiteId", websiteId);
	data.setParameter("verNum", String.valueOf(verNum));
%>
<link rel="stylesheet" href="<%= SWBPlatform.getContextPath() %>/swbadmin/js/codemirror/lib/codemirror.css">
<link rel="stylesheet" href="<%= SWBPlatform.getContextPath() %>/swbadmin/js/codemirror/addon/scroll/simplescrollbars.css">
<style type="text/css">
	.CodeMirror {
		height: 90%;
	}
</style>
<div id="container_<%= websiteId %>_<%= templateId %>" data-dojo-type="dijit/layout/BorderContainer" data-dojo-props="gutters:true, liveSplitters:false">
	<div data-dojo-type="dijit/layout/ContentPane" data-dojo-props="region:'top', splitter:false">
		<div data-dojo-type="dijit/Toolbar" style="padding:0px;">
			<button id="newButton_<%= websiteId %>_<%= templateId %>" type="button"></button>
			<button type="button" data-dojo-type="dijit.form.Button" data-dojo-props="iconClass:'dijitIconFolderOpen', showLabel:false">Abrir de archivo</button>
			<button type="button" data-dojo-type="dijit.form.Button" data-dojo-props="iconClass:'dijitEditorIcon dijitEditorIconSave', showLabel:false">Guardar</button>
			<button type="button" data-dojo-type="dijit.form.Button" data-dojo-props="iconClass:'dijitFolderOpened', showLabel:false">Agregar archivos</button>
			<span data-dojo-type="dijit/ToolbarSeparator"></span>
			<button id="addResourceButton_<%= websiteId %>_<%= templateId %>" type="button"></button>
			<!--span data-dojo-type="dijit/ToolbarSeparator"></span>
			<button id="previewButton_<%= websiteId %>_<%= templateId %>" >&lt;</button-->
		</div>
	</div>
	<div data-dojo-type="dijit/layout/ContentPane" data-dojo-props="region:'center', splitter:false">
		<span data-dojo-type="dijit/layout/StackController" data-dojo-props="containerId:'stackContainer'"></span>
		<div data-dojo-type="dijit/layout/StackContainer" data-dojo-id="myStackContainer" style="height:100%">
			<div data-dojo-type="dojox.layout.ContentPane" executeScripts="true">
				<div><textarea id="templateEditor_<%= websiteId %>_<%= templateId %>" name="templateContent"></textarea></div>
				<script type="dojo/method">
					//data-dojo-props="iconClass:'dijitEditorIcon dijitEditorIconSelectAll', showLabel:false, onClick:function(){myStackContainer.back()}"
					require({
						packages: [{
							name: "codemirror",
							location: "<%= SWBPlatform.getContextPath() %>/swbadmin/js/codemirror",
							main: "lib/codemirror"
						}]
					}, ["codemirror",
						"dojo/store/Memory",
						"dijit/tree/ObjectStoreModel",
						"dijit/Tree",
						"dojo/request/xhr",
						"dijit/form/Button",
						"dijit/form/ToggleButton",
						"dijit/registry",
						"codemirror/mode/xml/xml",
						"codemirror/mode/javascript/javascript",
						"codemirror/mode/css/css",
						"codemirror/mode/htmlmixed/htmlmixed",
						"codemirror/addon/scroll/simplescrollbars",
						"codemirror/addon/edit/closetag"],
						function(CodeMirror, Memory, ObjectStoreModel, Tree, xhr, Button, ToggleButton, registry) {
							let editor_<%= websiteId %>_<%= templateId %>; //CodeMirror editor
							let resources_<%= websiteId %>_<%= templateId %>; //Dojo tree

							//Inserts content into editor
							insertResourceTag = function() {
								let tpl,
										item = resources_<%= websiteId %>_<%= templateId %>.selectedItem,
										doc = editor_<%= websiteId %>_<%= templateId %>.getDoc();
							
								if (item) {
									if (item.parenttype && item.parenttype.length) {
										tpl = `<RESOURCE TYPE="${item.parenttype}" STYPE="${item.id}" />`;
									} else {
										tpl = `<RESOURCE TYPE="${item.id}" />`;
									}
      						doc.replaceSelection(tpl);
								}
							};

							//TODO: Mover la función de creación de árboles a una biblioteca para que el navegador no almacene la definición varias veces
							function TreeWidget (treeData, placeHolder, rootId) {
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
											if (item.parenttype && item.parenttype.length) {
												return "swbIconResourceSubType";
											} else {
												return "swbIconResourceType";
											}
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

							//Clears template content
							acceptNewTemplate = function() {
								editor_<%= websiteId %>_<%= templateId %>.setValue("");
								newTemplateDialog_<%= websiteId %>_<%= templateId %>.hide();
							}

							//Loads add resource dialog contents
							loadAddResourceDialog = function() {
								//Destroy previous tree
								resources_<%= websiteId %>_<%= templateId %> && resources_<%= websiteId %>_<%= templateId %>.destroy();

								//load tree data, create tree
								xhr("<%= data %>", {
									handleAs: "json"
								}).then(function(_data) {
									addResourceDialog_<%= websiteId %>_<%= templateId %>.show();
									//Create resources tree
									if (_data && _data.length) {
										resources_<%= websiteId %>_<%= templateId %> = new TreeWidget(_data, 'resourceTree_<%= websiteId %>_<%= templateId %>', null);
									}
								}, function(err) {
									console.log(err);
								});
							};

							new Button({
								iconClass: "dijitEditorIcon dijitEditorIconNewPage",
								showLabel: false,
								onClick: function(evt) {
									newTemplateDialog_<%= websiteId %>_<%= templateId %>.show();
								}
							},"newButton_<%= websiteId %>_<%= templateId %>").startup();

							new Button({
								label: "Agregar recurso",
								iconClass: "dijitIconConfigure",
								showLabel: false,
								onClick: function(evt) {
									loadAddResourceDialog();
								}
							},"addResourceButton_<%= websiteId %>_<%= templateId %>").startup();

							xhr("<%= templatePath %>", {}).then(function(data) {
								document.getElementById("templateEditor_<%= websiteId %>_<%= templateId %>").value = data;
								editor_<%= websiteId %>_<%= templateId %> = CodeMirror.fromTextArea(document.getElementById('templateEditor_<%= websiteId %>_<%= templateId %>'),
 								{
									mode: "text/html",
									autoCloseTags: true,
									//lineNumbers: true,
        							//smartIndent: true,
        							//matchBrackets: true,
        							//autoCloseBrackets: true,
        							//styleActiveLine: true,
        							//continueComments: true,
        							//gutters: ["CodeMirror-lint-markers"],
									scrollbarStyle: "simple",
									fixedGutter: true
        							//lint: true,
								});
							});
						});
				</script>
			</div>
			<div data-dojo-type="dojox.layout.ContentPane">
				<iframe id="preview_<%= websiteId %>_<%= templateId %>" style="width:100%; height:100%"></iframe>
			</div>
		</div>
	</div>
	<div data-dojo-type="dijit/Dialog" data-dojo-id="newTemplateDialog_<%= websiteId %>_<%= templateId %>" title="<%= paramRequest.getLocaleString("lblNewTemplate") %>">
	   	<div class="dijitDialogPaneContentArea">
	       	<p><%= paramRequest.getLocaleString("msgConfirmNew") %></p>
	   	</div>
	   	<div class="dijitDialogPaneActionBar">
	       	<button data-dojo-type="dijit/form/Button" type="button" data-dojo-props="onClick:function(){acceptNewTemplate();}"><%= paramRequest.getLocaleString("lblOk") %></button>
	       	<button data-dojo-type="dijit/form/Button" type="button" data-dojo-props="onClick:function(){newTemplateDialog_<%= websiteId %>_<%= templateId %>.hide();}"><%= paramRequest.getLocaleString("lblCancel") %></button>
	   	</div>
	</div>
	<div data-dojo-type="dijit/Dialog" data-dojo-id="addResourceDialog_<%= websiteId %>_<%= templateId %>" title="<%= paramRequest.getLocaleString("lblAddResource") %>">
		<div data-dojo-type="dijit/layout/BorderContainer" style="width:400px; height:300px;">
			<div data-dojo-type="dijit/layout/ContentPane" data-dojo-props="region:'center'">
				<div data-dojo-type="dijit/layout/ContentPane">
					<div id="resourceTree_<%= websiteId %>_<%= templateId %>"></div>
				</div>
			</div>
			<div data-dojo-type="dijit/layout/ContentPane" data-dojo-props="region:'bottom'">
				<button type="button" id="addResourceDialogBtn_<%= websiteId %>_<%= templateId %>" data-dojo-type="dijit/form/Button" data-dojo-props="onClick:function(){insertResourceTag();addResourceDialog_<%= websiteId %>_<%= templateId %>.hide();}">Agregar</button>
				<button type="button" data-dojo-type="dijit/form/Button" data-dojo-props="onClick:function(){addResourceDialog_<%= websiteId %>_<%= templateId %>.hide();}">Cancelar</button>
			</div>
		</div>
	</div>
</div>
