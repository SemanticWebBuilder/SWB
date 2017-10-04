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
	String templateName = URLEncoder.encode(template.getFileName(verNum));
	VersionInfo vio = null;

	SWBResourceURL resourceListUrl =  paramRequest.getRenderUrl().setMode("addResource");
	resourceListUrl.setParameter("templateId", templateId);
	resourceListUrl.setParameter("webSiteId", websiteId);
	resourceListUrl.setParameter("verNum", String.valueOf(verNum));

	SWBResourceURL templateContentUrl =  paramRequest.getRenderUrl().setCallMethod(SWBResourceURL.Call_DIRECT).setMode("getTemplateContent");
	templateContentUrl.setParameter("templateId", templateId);
	templateContentUrl.setParameter("webSiteId", websiteId);
	templateContentUrl.setParameter("verNum", String.valueOf(verNum));

	SWBResourceURL data =  paramRequest.getRenderUrl().setCallMethod(SWBResourceURL.Call_DIRECT).setMode("getResourceList");
	data.setParameter("templateId", templateId);
	data.setParameter("webSiteId", websiteId);
	data.setParameter("verNum", String.valueOf(verNum));

	String saveUrl = SWBPortal.getDistributorPath() + "/SWBAdmin/WBAd_utl_HTMLEditor/_rid/1/_mto/3/_mod/upload";
	//String fileName = tpl.getFileName(version);
%>
<!-- Uncomment this lines if you need CodeMirror instead of ACE -->
<!-- link rel="stylesheet" href="<%= SWBPlatform.getContextPath() %>/swbadmin/js/codemirror/lib/codemirror.css"-->
<!-- link rel="stylesheet" href="<%= SWBPlatform.getContextPath() %>/swbadmin/js/codemirror/addon/dialog/dialog.css"-->

<style type="text/css">
	.CodeMirror {
		height: 90%;
	}

	.AceEditor {
    margin: 0;
    position: absolute;
    top: 0;
    bottom: 0;
    left: 0;
    right: 0;
	}
</style>
<div id="container_<%= websiteId %>_<%= templateId %>" data-dojo-type="dijit/layout/BorderContainer" data-dojo-props="gutters:true, liveSplitters:false">
	<div data-dojo-type="dijit/layout/ContentPane" data-dojo-props="region:'top', splitter:false">
		<div data-dojo-type="dijit/Toolbar" style="padding:0px;">
			<button id="newButton_<%= websiteId %>_<%= templateId %>" type="button"></button>
			<button id="openFromFileButton_<%= websiteId %>_<%= templateId %>" type="button"></button>
			<button id="saveButton_<%= websiteId %>_<%= templateId %>" type="button"></button>
			<!--button type="button" data-dojo-type="dijit.form.Button" data-dojo-props="iconClass:'dijitFolderOpened', showLabel:false">Agregar archivos</button-->
			<span data-dojo-type="dijit/ToolbarSeparator"></span>
			<button type="button" id="undoButton_<%= websiteId %>_<%= templateId %>"></button>
			<button type="button" id="redoButton_<%= websiteId %>_<%= templateId %>"></button>
			<button type="button" id="searchButton_<%= websiteId %>_<%= templateId %>"></button>
			<span data-dojo-type="dijit/ToolbarSeparator"></span>
			<button id="addResourceButton_<%= websiteId %>_<%= templateId %>" type="button"></button>
			<button id="addContentButton_<%= websiteId %>_<%= templateId %>" type="button"></button>
			<button id="fileBrowserButton_<%= websiteId %>_<%= templateId %>" type="button"></button>
			<!--span data-dojo-type="dijit/ToolbarSeparator"></span>
			<button id="previewButton_<%= websiteId %>_<%= templateId %>" >&lt;</button-->
		</div>
	</div>
	<div data-dojo-type="dijit/layout/ContentPane" data-dojo-props="region:'center', splitter:false">
		<span data-dojo-type="dijit/layout/StackController" data-dojo-props="containerId:'stackContainer'"></span>
		<div data-dojo-type="dijit/layout/StackContainer" data-dojo-id="myStackContainer" style="height:100%">
			<div data-dojo-type="dojox/layout/ContentPane" executeScripts="true">
				<input type="file" id="fileLoadInput_<%= websiteId %>_<%= templateId %>" accept="text/html" style="display:none"/>
				<div id="templateEditor_<%= websiteId %>_<%= templateId %>"></div>
				<script type="dojo/method">
					require(["dojo/ready"], function(ready) {
						ready(function() {
							require(["dijit/tree/ObjectStoreModel"], function(ObjectStoreModel) {
							});
						});
					});
					
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
						"dojo/request/xhr",
						"dijit/form/Button",
						"dijit/form/ToggleButton",
						"dijit/registry"],
						function(TemplateEditor, Memory, ObjectStoreModel, Tree, xhr, Button, ToggleButton, registry) {
							let editor_<%= websiteId %>_<%= templateId %>; //CodeMirror editor
							let resources_<%= websiteId %>_<%= templateId %>; //Dojo tree

							TemplateEditor.setOptions({
								basePath: "<%= SWBPlatform.getContextPath() %>/swbadmin/js/aceeditor"
							});

							//TODO: Remove this bad practice code
							window.toggleBrowserButton_<%= websiteId %>_<%= templateId %> = function(enable) {
								enable ? registry.byId('fileBrowserButton_<%= websiteId %>_<%= templateId %>').setDisabled(false) : registry.byId('fileBrowserButton_<%= websiteId %>_<%= templateId %>').setDisabled(true); 
							};

							//Set fileChooser listener
							document.getElementById('fileLoadInput_<%= websiteId %>_<%= templateId %>').addEventListener("change",
								function(evt) {
									let fileObj = evt.target.files && evt.target.files.length && evt.target.files[0];

									if (fileObj) {
										if (fileObj.type !== "text/html") {
											alert("<%= paramRequest.getLocaleString("msgErrorBadFileType") %>");
										} else {
											let reader = new FileReader();

											reader.onload = function(e) {
												let text = reader.result;
												//Parse content
												//xhr("<%= paramRequest.getRenderUrl().setCallMethod(SWBResourceURL.Call_DIRECT).setMode("parseHTML") %>", {
												//	method: "POST",
        								//	data: text,
												//}).then(function(res) {
													editor_<%= websiteId %>_<%= templateId %>.insertContent(text, true);
												//});

												evt.target.value = null;
											};

											reader.readAsText(fileObj, "UTF-8");
										}
									}
								}, false);								

							//Inserts resource tag into editor at current position
							insertResourceTag = function() {
								let tpl, item = resources_<%= websiteId %>_<%= templateId %>.selectedItem;
								if (item && item.uuid !== "rootNode") {
									if (item.parenttype && item.parenttype.length) {
										tpl = '<RESOURCE TYPE="' + item.parenttype + '" STYPE="' + item.id + '" />';
									} else {
										tpl = '<RESOURCE TYPE="' + item.id +'" />';
									}
      						editor_<%= websiteId %>_<%= templateId %>.insertContent(tpl);
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

							//Save template button
							new Button({
								iconClass: "dijitEditorIcon dijitEditorIconSave",
								label: "<%= paramRequest.getLocaleString("lblSaveButton") %>",
								showLabel: false,
								onClick: function(evt) {
									xhr("<%= saveUrl %>", {
										method: "POST",
										data: editor_<%= websiteId %>_<%= templateId %>.getContent(),
										headers: {
											'PATHFILEWB' : '<%= templateName %>',
											'DOCUMENT' : 'RELOAD',
											'TM' : '<%= websiteId %>',
											'ID' : '<%= templateId %>',
											'VER' : '<%= verNum %>',
											'TYPE' : 'Template'
										}
									}).then(function(ret) {
										if (ret.includes("ok")) {
											alert("<%= paramRequest.getLocaleString("msgTemplateSaved") %>");
										} else {
											alert("<%= paramRequest.getLocaleString("msgErrorSave") %>");
										}
									}, function(err) {
										console.log(err);
									});
								}
							},"saveButton_<%= websiteId %>_<%= templateId %>").startup();

							//Open from file button
							new Button({
								iconClass: "dijitIconFolderOpen",
								label: "<%= paramRequest.getLocaleString("lblOpenFromFile") %>",
								showLabel: false,
								onClick: function(evt) {
									if (confirm('<%= paramRequest.getLocaleString("msgConfirmNew") %>')) {
										document.getElementById('fileLoadInput_<%= websiteId %>_<%= templateId %>').click();
									}
								}
							},"openFromFileButton_<%= websiteId %>_<%= templateId %>").startup();

							new Button({
								iconClass: "dijitEditorIcon dijitEditorIconNewPage",
								label: "<%= paramRequest.getLocaleString("lblNewTemplate") %>",
								showLabel: false,
								onClick: function(evt) {
									if (confirm('<%= paramRequest.getLocaleString("msgConfirmNew") %>')) {
										editor_<%= websiteId %>_<%= templateId %>.insertContent("", true);
									}
									newTemplateDialog_<%= websiteId %>_<%= templateId %>.show();
								}
							},"newButton_<%= websiteId %>_<%= templateId %>").startup();

							new Button({
								iconClass: "dijitEditorIcon dijitEditorIconSelectAll",
								label: "<%= paramRequest.getLocaleString("lblAddContentButton") %>",
								showLabel: false,
								onClick: function(evt) {
									editor_<%= websiteId %>_<%= templateId %>.insertContent("<CONTENT/>");
								}
							},"addContentButton_<%= websiteId %>_<%= templateId %>").startup();

							new Button({
								iconClass: "dijitIconSearch",
								label: "<%= paramRequest.getLocaleString("lblFindButton") %>",
								showLabel: false,
								onClick: function(evt) {
									editor_<%= websiteId %>_<%= templateId %>.execCommand("find");
								}
							},"searchButton_<%= websiteId %>_<%= templateId %>").startup();

							new Button({
								iconClass: "dijitEditorIcon dijitEditorIconUndo",
								label: "<%= paramRequest.getLocaleString("lblUndoButton") %>",
								showLabel: false,
								onClick: function(evt) {
									editor_<%= websiteId %>_<%= templateId %>.execCommand("undo");
								}
							},"undoButton_<%= websiteId %>_<%= templateId %>").startup();

							new Button({
								iconClass: "dijitEditorIcon dijitEditorIconRedo",
								label: "<%= paramRequest.getLocaleString("lblRedoButton") %>",
								showLabel: false,
								onClick: function(evt) {
									editor_<%= websiteId %>_<%= templateId %>.execCommand("redo");
								}
							},"redoButton_<%= websiteId %>_<%= templateId %>").startup();

							new Button({
								label: "<%= paramRequest.getLocaleString("lblAddResourceButton") %>",
								iconClass: "dijitIconPackage",
								showLabel: false,
								onClick: function(evt) {
									loadAddResourceDialog();
								}
							},"addResourceButton_<%= websiteId %>_<%= templateId %>").startup();


							new Button({
								label: "<%= paramRequest.getLocaleString("lblFileExplorerButton") %>",
								iconClass: "dijitIconApplication",
								showLabel: false,
								onClick: function(evt) {
									window.toggleBrowserButton_<%= websiteId %>_<%= templateId %>(false);
									window.open("<%= paramRequest.getRenderUrl().setCallMethod(SWBResourceURL.Call_DIRECT).setMode("fileManager").setParameter("suri", template.getURI()).setParameter("vnum", String.valueOf(verNum)) %>", "_blank", "width=600,height=400,location=0,menubar=0,status=0,toolbar=0,titlebar=0");
								}
							},"fileBrowserButton_<%= websiteId %>_<%= templateId %>").startup();

							xhr("<%= templateContentUrl %>", {}).then(function(data) {
								editor_<%= websiteId %>_<%= templateId %> = TemplateEditor.createInstance('templateEditor_<%= websiteId %>_<%= templateId %>');
								editor_<%= websiteId %>_<%= templateId %>.insertContent(data, true);
							});
						});
				</script>
			</div>
		</div>
	</div>
	<!--div data-dojo-type="dijit/Dialog" data-dojo-id="newTemplateDialog_<%= websiteId %>_<%= templateId %>" title="<%= paramRequest.getLocaleString("lblNewTemplate") %>">
	   	<div class="dijitDialogPaneContentArea">
	       	<p><%= paramRequest.getLocaleString("msgConfirmNew") %></p>
	   	</div>
	   	<div class="dijitDialogPaneActionBar">
	       	<button data-dojo-type="dijit/form/Button" type="button" data-dojo-props="onClick:function(){acceptNewTemplate();}"><%= paramRequest.getLocaleString("lblOk") %></button>
	       	<button data-dojo-type="dijit/form/Button" type="button" data-dojo-props="onClick:function(){newTemplateDialog_<%= websiteId %>_<%= templateId %>.hide();}"><%= paramRequest.getLocaleString("lblCancel") %></button>
	   	</div>
	</div-->
	<div data-dojo-type="dijit/Dialog" data-dojo-id="addResourceDialog_<%= websiteId %>_<%= templateId %>" title="<%= paramRequest.getLocaleString("lblAddResourceButton") %>">
		<div data-dojo-type="dijit/layout/BorderContainer" style="width:400px; height:300px;">
			<div data-dojo-type="dijit/layout/ContentPane" data-dojo-props="region:'center'">
				<div data-dojo-type="dijit/layout/ContentPane">
					<div id="resourceTree_<%= websiteId %>_<%= templateId %>"></div>
				</div>
			</div>
			<div data-dojo-type="dijit/layout/ContentPane" data-dojo-props="region:'bottom'">
				<button type="button" id="addResourceDialogBtn_<%= websiteId %>_<%= templateId %>" data-dojo-type="dijit/form/Button" data-dojo-props="onClick:function(){insertResourceTag();addResourceDialog_<%= websiteId %>_<%= templateId %>.hide();}"><%= paramRequest.getLocaleString("lblAddButton") %></button>
				<button type="button" data-dojo-type="dijit/form/Button" data-dojo-props="onClick:function(){addResourceDialog_<%= websiteId %>_<%= templateId %>.hide();}"><%= paramRequest.getLocaleString("lblCancel") %></button>
			</div>
		</div>
	</div>
</div>
