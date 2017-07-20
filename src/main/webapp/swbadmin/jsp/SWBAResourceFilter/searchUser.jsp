<%@page import="org.semanticwb.platform.SemanticObject"%>
<%@page import="java.util.Iterator"%>
<%@page import="org.semanticwb.model.UserRepository"%>
<%@page import="java.util.UUID"%>
<%@page import="org.semanticwb.model.GenericObject"%>
<%@page import="org.semanticwb.SWBPortal"%>
<%@page import="org.semanticwb.model.Resource"%>
<%@page import="org.semanticwb.model.ResourceFilter"%>
<%@page import="org.semanticwb.model.SWBContext"%>
<%@page import="org.semanticwb.SWBUtils"%>
<%@page import="java.io.File"%>
<%@page import="org.semanticwb.SWBPlatform"%>
<%@page import="org.semanticwb.model.User"%>
<%@page import="org.semanticwb.portal.api.SWBResourceURL"%>
<jsp:useBean id="paramRequest" scope="request" type="org.semanticwb.portal.api.SWBParamRequest"/>
<%
String resID = UUID.randomUUID().toString().replace("-","_");
UserRepository urep = (UserRepository)SWBPlatform.getSemanticMgr().getOntology().getGenericObject(request.getParameter("suri"));
User user = SWBContext.getAdminUser();

if (SWBContext.getAdminWebSite().equals(paramRequest.getWebPage().getWebSite()) && null != user) {
    String usrdata = "[]";
    if (null != urep) {
        Iterator<User> users = urep.listUsers();
        if (users.hasNext()) {
            usrdata = "[";

            while(users.hasNext()) {
                User usr = users.next();
                usrdata+="{\"id\":\""+usr.getId()+"\",";
                usrdata+="\"login\":\""+usr.getLogin()+"\"";
                if (null != usr.getLastName() && !usr.getLastName().isEmpty()) {
                  usrdata+=", \"firstName\":\""+usr.getLastName()+"\"";
                }
                if (null != usr.getSecondLastName() && !usr.getSecondLastName().isEmpty()) {
                    usrdata+=",\"lastName\":\""+usr.getSecondLastName()+"\"";
                }
                if (null != usr.getFirstName() && !usr.getFirstName().isEmpty()) {
                    usrdata+=",\"nameame\":\""+usr.getFirstName()+"\"";
                }
                usrdata+="}";
                if (users.hasNext()) usrdata+=",";
            }
            usrdata+="]";
        }
    }
    %>
    <link href="<%= SWBPortal.getContextPath() %>/swbadmin/js/dojo/dojox/grid/enhanced/resources/EnhancedGrid.css" rel="stylesheet" />
    <div id="afcontainer_<%= resID %>" data-dojo-type="dijit/layout/BorderContainer" data-dojo-props="gutters:true, liveSplitters:false">
        <div data-dojo-type="dijit/layout/ContentPane" data-dojo-props="region:'top', splitter:false">
            <form id="searchForm_<%= resID %>" data-dojo-type="dijit/form/Form" action="<%= paramRequest.getRenderUrl() %>" onsubmit="submitForm('searchForm_<%= resID %>'); return false;">
                <select id="repCombo_<%= resID %>" name="suri" data-dojo-type="dijit/form/Select">
                    <option value="-1"><%= paramRequest.getLocaleString("lblPromptSelect") %></option>
                    <%
                    Iterator<UserRepository> repos = SWBContext.listUserRepositories();
                    while(repos.hasNext()) {
                        UserRepository repo = repos.next();
                        %>
                        <option value="<%= repo.getURI() %>" <%= null != urep && urep.getURI().equals(repo.getURI()) ? "selected=\"selected\"" : "" %>><%= repo.getDisplayTitle("es") %></option>
                        <%
                    }
                    %>
                </select>
                    <button id="editFilter_<%= resID %>" data-dojo-type="dijit/form/Button" type="button" <%= null == urep ? "disabled=\"disabled\"" : "" %>><%= paramRequest.getLocaleString("lblEdit") %></button>
            </form>
        </div>
        <div data-dojo-type="dijit/layout/ContentPane" data-dojo-props="region:'center', splitter:false" style="width:500px;">
            <%
            if (null != urep && "[]".equals(usrdata)) {
                %>
                <span style="color: red;"><%= paramRequest.getLocaleString("msgNoUsers") %></span>
                <%
            }
            %>
            <div id="users_<%= resID %>"></div>
            <script type="dojo/method">
                require(["dojo/ready"], function(ready) {
                  ready(function() {
                    require(["dijit/tree/ObjectStoreModel"], function(ObjectStoreModel) {
                    });
                  });
                });

                require(['dojo/store/Memory','dojo/data/ObjectStore',
                    'dojo/domReady!', 'dojo/dom', 'dojo/request/xhr',
                    'dojox/grid/EnhancedGrid', 'dijit/form/Button',
                    'dijit/registry', 'dojox/grid/enhanced/plugins/Filter',
                    'dojo/on', 'dojox/grid/enhanced/plugins/IndirectSelection'],
                function(Memory, ObjectStore, ready, dom, xhr, EnhancedGrid, Button, registry, Filter, on) {
                    function GridWidget (_data, structure, container, useFilter) {
                        var store = new ObjectStore({ objectStore:new Memory({ data: _data }) }), grid;
                        var cfg = {
                            store: store,
                            query: {id:"*"},
                            selectionMode: "multiple",
                            structure: structure,
                            keepSelection: true,
                            plugins: {
                                indirectSelection: true
                            }
                        };

                        if (useFilter) {
                            cfg.plugins.filter = {ruleCount: 1};
                        }

                        grid = new EnhancedGrid(cfg, container);
                        grid.startup();

                        return {
                            setSelectedItems: function (items) {
                                var rows = grid.rowCount;
                                for (var i = 0; i < rows; i++) {
                                    var item = grid.getItem(i);
                                    if (item && items.indexOf(item.id) >= 0) {
                                        grid.selection.setSelected(i, true);
                                    }
                                }
                                grid.render();
                            }
                        };
                    };

                    on(registry.byId('repCombo_<%= resID %>'), "change", function(evt) {
                        submitForm('searchForm_<%= resID %>');
                    });

                    on(dom.byId('editFilter_<%= resID %>'), "click", function(evt) {
                        var grid = registry.byId('users_<%= resID %>');
                        var items, ids = [];

                        if (grid) {
                            items = grid.selection.getSelected();
                            if (items.length) {
                                ids = dojo.map(items, function(item) {
                                    return item.id;
                                });

                                ids = ids.join("|");
                                submitUrl('<%= paramRequest.getRenderUrl().setAction("editFilter") %>?suri=<%= null != urep ? urep.getEncodedURI() : "" %>&ids='+ids,this);
                            } else {
                                alert("<%= paramRequest.getLocaleString("msgNoUserSelected") %>");
                            }
                        }
                        evt.preventDefault();
                    });

                    var data = <%= usrdata %>;
                    if (data.length) {
                        var users_<%= resID %> = new GridWidget(data,
                        [
                            { name: "<%= paramRequest.getLocaleString("lblColLogin") %>", field: "login", width: "20%", datatype:"string" },
                            { name: "<%= paramRequest.getLocaleString("lblColLastName") %>", field: "firstName", width: "20%", datatype:"string" },
                            { name: "<%= paramRequest.getLocaleString("lblColSecondLastName") %>", field: "lastName", width: "20%", datatype:"string" },
                            { name: "<%= paramRequest.getLocaleString("lblColName") %>", field: "name", width: "20%", datatype:"string" }
                        ], "users_<%= resID %>", true);

                        <%
                        String users = request.getParameter("ids");
                        if (null != users && !users.isEmpty()) {
                            %>
                            //users_<%= resID %>.setSelectedItems('<%= users %>'.split('|'));
                            <%
                        }
                        %>
                    }
                });
            </script>
        </div>
    </div>
<%
}
%>
