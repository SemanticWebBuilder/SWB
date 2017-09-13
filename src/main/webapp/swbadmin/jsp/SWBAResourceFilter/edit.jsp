<%@page import="org.semanticwb.model.UserRepository"%>
<%@page import="org.semanticwb.SWBPortal"%>
<%@page import="org.semanticwb.model.SWBContext"%>
<%@page import="org.semanticwb.portal.api.SWBResourceURL"%>
<%@page import="org.semanticwb.model.User"%>
<%@page import="org.semanticwb.SWBPlatform"%>
<%@page import="org.semanticwb.model.Resource"%>
<%@page import="java.util.UUID"%>
<%@page import="org.semanticwb.model.GenericObject"%>
<jsp:useBean id="paramRequest" scope="request" type="org.semanticwb.portal.api.SWBParamRequest"/>
<%
String resID = UUID.randomUUID().toString().replace("-","_");

SWBResourceURL data = paramRequest.getRenderUrl().setCallMethod(SWBResourceURL.Call_DIRECT).setMode("gateway").setAction("getFilter");
data.setParameter("suri", request.getParameter("suri"));

SWBResourceURL save = paramRequest.getActionUrl().setAction("updateFilter");
save.setParameter("suri", request.getParameter("suri"));
save.setParameter("ids", request.getParameter("ids"));

SWBResourceURL back = paramRequest.getRenderUrl().setMode(SWBResourceURL.Mode_VIEW);
back.setParameter("suri", request.getParameter("suri"));
if (null != request.getParameter("ids") && !request.getParameter("ids").isEmpty()) back.setParameter("ids", request.getParameter("ids"));

User user = SWBContext.getAdminUser();
boolean isMultiple = Boolean.valueOf(paramRequest.getResourceBase().getAttribute("multiple", "false"));
if (SWBContext.getAdminWebSite().equals(paramRequest.getWebPage().getWebSite()) && null != user) {
    %>
    <link href="<%= SWBPortal.getContextPath() %>/swbadmin/js/dojo/dojox/form/resources/TriStateCheckBox.css" rel="stylesheet" />
    <style>
        .swbIconServer {
            background-repeat: no-repeat;
            width:20px;
            height: 18px;
            text-align: center;
            padding-right:0px;
            background-image: url('<%= SWBPortal.getContextPath() %>/swbadmin/icons/icons20x18.png'); background-position: -120px -197px;
        }
        .label-default {
            background-color: #e1ebfb;
        }
        .label {
            display: inline-block;
            padding: .2em .6em .3em;
            font-size: 85%;
            font-weight: 700;
            line-height: 1;
            text-align: center;
            white-space: nowrap;
            vertical-align: baseline;
            border-radius: .25em;
        }
        .noIcon { display: none !important; }
        .resourceFilterTree .dijitTreeRowSelected .dijitTreeLabel { background: none !important; outline: none !important; }
        .resourceFilterTree .dijitTreeNodeFocused .dijitTreeLabel { background: none !important; outline: none !important; }
        .styleChecked { color: darkblue; font-style: italic; font-weight: bold !important; }
        .styleHighlight { font-style: italic; font-weight: bold !important; }
    </style>
    <div id="container_<%= resID %>" data-dojo-type="dijit/layout/BorderContainer" data-dojo-props="gutters:true, liveSplitters:false">
        <div data-dojo-type="dijit/layout/ContentPane" data-dojo-props="region:'top', splitter:false">
            <% if (isMultiple) {
                %>
                <button id="back_<%= resID %>" type="button"><%= paramRequest.getLocaleString("lblBack") %></button>
                <%
            }
            %>
            <button id="saveButton_<%= resID %>" type="button"></button>
            <input type="checkbox" data-dojo-type="dijit/form/CheckBox" id="negative_<%= resID %>"/><%= paramRequest.getLocaleString("lblNegate") %>
            <%
            String ids = request.getParameter("ids");
            if (null != ids) {
                %>
                <br>
                <fieldset><legend><%= paramRequest.getLocaleString("lblSelectedUsers") %>:</legend>
                    <div style="max-height:100px; overflow: scroll;">
                    <%
                    UserRepository urep = (UserRepository) SWBPlatform.getSemanticMgr().getOntology().getGenericObject(request.getParameter("suri"));
                    if (null != urep) {
                        String uids [] = ids.split("\\|");
                        for (int i = 0; i < uids.length; i++) {
                            User usr = urep.getUser(uids[i]);
                            if (null != usr) {
                                %><span class="label label-default"><%= usr.getLogin() %><%= null != usr.getFullName() ? " ("+usr.getFullName()+")" : "" %></span>&nbsp<%
                            }
                        }
                    }
                    %>
                    </div>
                </fieldset>
                <%
            }
            %>
        </div>
        <div class="resourceFilterTree claro" data-dojo-type="dijit/layout/ContentPane" data-dojo-props="region:'center', splitter:false">
            <div id="serverTree_<%= resID %>"></div>
            <script type="dojo/method">
                require(["dojo/ready"], function(ready) {
                  ready(function() {
                    require(["dijit/tree/ObjectStoreModel"], function(ObjectStoreModel) {
                    });
                  });
                });
                
                require(['dojo/store/Memory','dijit/tree/ObjectStoreModel',
                    'dijit/Tree', 'dojo/domReady!', 'dojo/dom', 'dojo/request/xhr',
                    'dojox/widget/Standby', 'dojo/topic', 'dijit/form/Button', 'dijit/registry', 'dojox/form/TriStateCheckBox'],
                function(Memory, ObjectStoreModel, Tree, ready, dom, xhr, StandBy, topic, Button, registry, TriStateCheckBox) {
                    var server_<%= resID %>;
                    var saveButton_<%= resID %>, standby = new StandBy({target: "container_<%= resID %>"});;

                    document.body.appendChild(standby.domNode);
                    standby.startup();
                    standby.show();

                    <%
                    if (isMultiple) {
                        %>
                        new Button({
                            onClick: function (evt) {
                                submitUrl('<%= back %>', this.domNode);
                            }
                        }, "back_<%= resID %>").startup();
                        <%
                    }
                    %>

                    saveButton_<%= resID %> = new Button({
                        label: "<%= paramRequest.getLocaleString("lblSave") %>",
                        iconClass:'dijitEditorIcon dijitEditorIconSave',
                        onClick: function(evt) {
                            var payload = {id: '<%= resID %>', negative: registry.byId('negative_<%= resID %>').attr("checked")};
                            var xhrhttp = new XMLHttpRequest(), btn = this;
                            if (server_<%= resID %>.getSelectedItems().total > 0) {
                                payload.topics = server_<%= resID %>.getSelectedItems();
                            }
                            payload.siteId = server_<%= resID %>.site;

                            xhrhttp.open("POST", '<%= save %>', true);
                            xhrhttp.setRequestHeader('Content-Type', 'application/json; charset=UTF-8');
                            btn.busy(true);

                            xhrhttp.send(JSON.stringify(payload));
                            xhrhttp.onreadystatechange = function() {
                                if (xhrhttp.readyState == 4) {
                                    if (xhrhttp.status == 200) {
                                        showStatus('<%= paramRequest.getLocaleString("msgUpdated") %>');
                                    } else {
                                        alert("<%= paramRequest.getLocaleString("msgError") %>");
                                    }
                                    btn.busy(false);
                                }
                            };
                        },
                        busy: function(val) {
                            this.set("iconClass", val ? "dijitIconLoading" : "dijitEditorIcon dijitEditorIconSave");
                            this.set("disabled", val);
                        }
                    }, "saveButton_<%= resID %>").startup();

                    //TODO: Mover la funci�n de creaci�n de �rboles a una biblioteca para que el navegador no almacene la definici�n varias veces
                    function TreeWidget (treeData, siteId, placeHolder, rootId) {
                        var store, model;

                        function createTreeNode(args) {
                            var tnode = new dijit._TreeNode(args), cb;
                            tnode.labelNode.innerHTML = args.label;
                            if (!tnode.item.type) tnode.item.type = tnode.item.type || "";
                            if ((tnode.item.type === "" || tnode.item.type !== "website") && tnode.item.id !== "Server") {
                                cb = new TriStateCheckBox({
                                    states: ["mixed", false, true],
                                    checked: false
                                });
                                cb.placeAt(tnode.contentNode, "first");
                            }

                            tnode.getCheckboxState = function() { return cb ? cb.get("checked") : undefined; };
                            tnode.toggleCheckbox = function(val) { cb && cb.set("checked", val); };
                            tnode.toggleCheckBoxState = function(val) { cb.set("disabled", val || false); };
                            tnode.disableChilds = function() {
                                if (this.isExpanded) {
                                    var childs = this.getChildren();
                                    if (childs.length) {
                                        dojo.forEach(childs, function (child) {
                                            child.toggleCheckBoxState(true);
                                            dojo.removeClass(child.labelNode, "styleChecked");
                                            dojo.removeClass(child.labelNode, "styleHighlight");
                                            child.item.enabled=false;
                                            store.put(child.item);
                                            child.disableChilds();
                                        });
                                    }
                                }
                            };
                            tnode.enableChilds = function() {
                                if (this.isExpanded) {
                                    var childs = this.getChildren();
                                    if (childs.length) {
                                        dojo.forEach(childs, function (child) {
                                            child.item.enabled = true;
                                            store.put(child.item);
                                            child.toggleCheckBoxState(false);
                                            if (child.getCheckboxState() !== "mixed") {
                                                child.enableChilds();
                                            }
                                        });
                                    }
                                }
                            };
                            tnode.highlightParents = function(val) {
                                var parentId = tnode.item.parent || false, parent;
                                var enable = val || false;

                                parent = parentId && this.tree._itemNodesMap[parentId];
                                if (parent && parent.length) {
                                    parent = parent[0];
                                    enable ? dojo.addClass(parent.labelNode, "styleHighlight") : dojo.removeClass(parent.labelNode, "styleHighlight");
                                }

                                while (parentId) {
                                    parentId = parent.item.parent || false;
                                    parent = this.tree._itemNodesMap[parentId];
                                    if (parent && parent.length) {
                                        parent = parent[0];
                                        enable ? dojo.addClass(parent.labelNode, "styleHighlight") : dojo.removeClass(parent.labelNode, "styleHighlight");
                                    }
                                }
                            };

                            dojo.connect(cb, "onChange", function(obj, evt) {
                                if ("mixed" === obj || true === obj) {
                                    tnode.item.selected = true;
                                } else {
                                    tnode.item.selected = false;
                                }

                                "mixed" === obj ? tnode.disableChilds() : tnode.enableChilds();
                                tnode.item.childs = ("mixed" === obj);
                                store.put(tnode.item);
                            });

                            if(args.item.selected) {
                                tnode.toggleCheckbox(args.item.childs && args.item.childs === true ? "mixed" : true);
                                args.item.childs && args.item.childs === true ? tnode.disableChilds() : tnode.enableChilds();
                            }

                            return tnode;
                        };

                        if (treeData && treeData.length) {
                            store = new Memory({
                                data: treeData,
                                idProperty: "uuid",
                                getChildren: function(object) { return this.query({parent: object.uuid}); },
                                getSelectedChilds: function() { return this.query({selected: true, enabled: true}); }
                            });

                            model = new ObjectStoreModel({
                                store: store,
                                query: {uuid: rootId},
                                labelAttr: "name",
                                mayHaveChildren: function(item) { return model.store.getChildren(item).total > 0; },
                                getItemPath: function(id) {
                                    var ret = [], parent = undefined, query = this.store.query({uuid: id});
                                    if (query.total === 1) parent = query[0];

                                    while (parent) {
                                        ret.push(parent.uuid);
                                        query = this.store.query({uuid: parent.parent});

                                        if (query.total === 1) {
                                            parent = query[0];
                                        } else {
                                            parent = undefined;
                                        }
                                    }

                                    return ret.reverse();
                                }
                            });

                            var ret = new Tree({
                                model: model,
                                getIconClass: function(item, opened) { return item.cssIcon; },
                                getRowClass: function(item,opened) {},
                                _createTreeNode: createTreeNode,
                                onOpen: function(_item, _node) {
                                    //Si el nodo est� seleccionado o el nodo est� deshabilitado, deshabilitar los hijos
                                    if ("mixed" === _node.getCheckboxState() || _item.enabled === false) {
                                        _node.disableChilds();
                                    }
                                },
                                getSelectedItems: function() {
                                    return store.getSelectedChilds();
                                },
                                site: siteId
                            });

                            ret.placeAt(placeHolder);
                            ret.startup();
                            return ret;
                        }

                        return { };
                    };

                    xhr("<%= data %>", {
                        handleAs: "json"
                    }).then(function(_data) {
                        //Create server tree
                        if (_data.topics) {
                            server_<%= resID %> = new TreeWidget(_data.topics, _data.id, 'serverTree_<%= resID %>', _data.sitesRoot);
                            server_<%= resID %>.onLoadDeferred.then(function() {
                                _data.paths && _data.paths.forEach(function(item, idx) {
                                    server_<%= resID %>.set('paths', [server_<%= resID %>.model.getItemPath(item)]);
                                });
                            });
                        }
                        if (_data.negative && _data.negative === true) {
                            registry.byId('negative_<%= resID %>').set("checked", "checked");
                        }
                        standby.hide();
                    }, function(err){
                        alert("<%= paramRequest.getLocaleString("msgError") %>");
                    });
                });
            </script>
        </div>
    </div>
    <%
    }
%>
